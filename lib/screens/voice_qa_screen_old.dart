import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/gemini_service.dart';
import '../services/weather_service.dart';

class VoiceQAScreen extends StatefulWidget {
  const VoiceQAScreen({Key? key}) : super(key: key);

  @override
  State<VoiceQAScreen> createState() => _VoiceQAScreenState();
}

class _VoiceQAScreenState extends State<VoiceQAScreen> {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  final TextEditingController _textController = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  final WeatherService _weatherService = WeatherService();
  final ScrollController _scrollController = ScrollController();
  
  bool _isListening = false;
  bool _isLoading = false;
  String _currentLanguage = 'ur';
  bool _isSpeaking = false;
  List<Map<String, dynamic>> _conversation = [];
  String? _lastWeatherContext;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initTts();
    _loadLastWeather();
  }

  Future<void> _initSpeech() async {
    await Permission.microphone.request();
    try {
      await _speech.initialize();
    } catch (e) {
      print('Speech init error: $e');
    }
  }

  Future<void> _initTts() async {
    await _tts.setLanguage(_currentLanguage == 'ur' ? 'ur-PK' : 'en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
  }

  Future<void> _loadLastWeather() async {
    try {
      final weather = await _weatherService.getCurrentWeather('Lahore');
      if (weather['success']) {
        final data = weather['data'];
        _lastWeatherContext =
            'Current weather in ${data['city']}: ${data['temp']}°C, ${data['condition']}, Humidity: ${data['humidity']}%';
      }
    } catch (e) {
      print('Weather load error: $e');
    }
  }

  Future<void> _startListening() async {
    if (!_isListening) {
      setState(() => _isListening = true);
      try {
        await _speech.listen(
          onResult: (result) {
            setState(() {
              _textController.text = result.recognizedWords;
            });
          },
          localeId: _currentLanguage == 'ur' ? 'ur_PK' : 'en_US',
        );
      } catch (e) {
        setState(() => _isListening = false);
        _showError('مائیک کھول نہیں سکا');
      }
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
    if (_textController.text.isNotEmpty) {
      await _askAI(_textController.text);
    }
  }

  Future<void> _askAI(String question) async {
    setState(() => _isLoading = true);

    try {
      final result = await _geminiService.sendQuery(
        question,
        weatherContext: _lastWeatherContext,
      );

      setState(() {
        _conversation.add({
          'role': 'user',
          'content': question,
          'timestamp': DateTime.now(),
        });
        
        _conversation.add({
          'role': 'assistant',
          'content': result['answer'],
          'timestamp': DateTime.now(),
          'success': result['success'],
        });
        
        _isLoading = false;
        _textController.clear();
      });

      _scrollToBottom();

      if (result['success']) {
        await _speakResponse(result['answer']);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('جواب نہیں ملا: ${e.toString()}');
    }
  }

  Future<void> _speakResponse(String text) async {
    try {
      setState(() => _isSpeaking = true);
      await _tts.speak(text);
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() => _isSpeaking = false);
    } catch (e) {
      print('TTS Error: $e');
      setState(() => _isSpeaking = false);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _clearHistory() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('گفتگو صاف کریں'),
        content: const Text('کیا آپ یقینی ہیں؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('منسوخ کریں'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _conversation.clear();
                _geminiService.clearHistory();
                _textController.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('صاف کریں'),
          ),
        ],
      ),
    );
  }

  void _toggleLanguage() {
    setState(() {
      _currentLanguage = _currentLanguage == 'ur' ? 'en' : 'ur';
    });
    _initTts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ذہین زرعی مشیر | Smart Farm Assistant'),
        backgroundColor: const Color(0xFF28a745),
        elevation: 0,
        actions: [
          Tooltip(
            message: _currentLanguage == 'ur' ? 'English میں بدلیں' : 'اردو میں بدلیں',
            child: IconButton(
              icon: Text(
                _currentLanguage == 'ur' ? 'EN' : 'اردو',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              onPressed: _toggleLanguage,
            ),
          ),
          Tooltip(
            message: _currentLanguage == 'ur' ? 'صاف کریں' : 'Clear',
            child: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _clearHistory,
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF28a745).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            // Conversation History
            Expanded(
              child: _conversation.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.agriculture,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _currentLanguage == 'ur'
                                ? 'کوئی سوال پوچھیں'
                                : 'Ask a question',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _conversation.length,
                      itemBuilder: (context, index) {
                        final msg = _conversation[index];
                        final isUser = msg['role'] == 'user';

                        return Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.75,
                            ),
                            decoration: BoxDecoration(
                              color: isUser
                                  ? const Color(0xFF28a745)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: isUser
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  msg['content'] ?? '',
                                  style: TextStyle(
                                    color: isUser ? Colors.white : Colors.black87,
                                    fontSize: 15,
                                    height: 1.5,
                                  ),
                                ),
                                if (!isUser && msg['success'] == false)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      _currentLanguage == 'ur'
                                          ? '⚠️ خرابی'
                                          : '⚠️ Error',
                                      style: TextStyle(
                                        color: Colors.red[600],
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Loading Indicator
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFF28a745)),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _currentLanguage == 'ur'
                          ? 'جواب تلاش کیا جا رہا ہے...'
                          : 'Finding answer...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

            // Input Area
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey[300] ?? Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: TextField(
                            controller: _textController,
                            textAlign: _currentLanguage == 'ur'
                                ? TextAlign.right
                                : TextAlign.left,
                            decoration: InputDecoration(
                              hintText: _currentLanguage == 'ur'
                                  ? 'سوال لکھیں یا بولیں...'
                                  : 'Type or speak...',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              suffixIcon: _textController.text.isEmpty
                                  ? null
                                  : IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        _textController.clear();
                                        setState(() {});
                                      },
                                    ),
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                            onSubmitted: (text) {
                              if (text.isNotEmpty && !_isLoading) {
                                _askAI(text);
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      FloatingActionButton.extended(
                        onPressed:
                            _isListening ? _stopListening : _startListening,
                        backgroundColor: _isListening
                            ? Colors.red
                            : const Color(0xFF28a745),
                        icon: Icon(
                          _isListening ? Icons.stop : Icons.mic,
                          color: Colors.white,
                        ),
                        label: Text(
                          _isListening
                              ? (_currentLanguage == 'ur'
                                  ? 'رکو'
                                  : 'Stop')
                              : (_currentLanguage == 'ur'
                                  ? 'بولیں'
                                  : 'Speak'),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  if (_isListening)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        _currentLanguage == 'ur'
                            ? '🎤 سن رہے ہیں...'
                            : '🎤 Listening...',
                        style: TextStyle(
                          color: Colors.red[600],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _speech.cancel();
    _tts.stop();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
