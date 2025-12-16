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

class _VoiceQAScreenState extends State<VoiceQAScreen> with SingleTickerProviderStateMixin {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  final TextEditingController _textController = TextEditingController();
  final GeminiService _geminiService = GeminiService();
  final WeatherService _weatherService = WeatherService();
  final ScrollController _scrollController = ScrollController();
  
  bool _isListening = false;
  bool _isLoading = false;
  String _currentLanguage = 'en';
  List<Map<String, dynamic>> _conversation = [];
  String? _lastWeatherContext;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _initSpeech();
    _initTts();
    _loadLastWeather();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _initSpeech() async {
    await Permission.microphone.request();
    try {
      await _speech.initialize();
    } catch (e) {
      _showError('Microphone access denied');
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
        setState(() {
          _lastWeatherContext = 'Current weather in Lahore: ${weather['data']['main']['temp']}°C, ${weather['data']['weather'][0]['main']}';
        });
      }
    } catch (e) {
      // Weather loading failed, continue without context
    }
  }

  Future<void> _handleVoiceInput() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
      return;
    }

    if (!_speech.isAvailable) {
      _showError('Speech recognition not available');
      return;
    }

    try {
      setState(() => _isListening = true);
      await _speech.listen(
        onResult: (result) {
          setState(() {
            _textController.text = result.recognizedWords;
          });
        },
        localeId: _currentLanguage == 'ur' ? 'ur_PK' : 'en_US',
      );
    } catch (e) {
      _showError('Error starting voice input');
      setState(() => _isListening = false);
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.isEmpty) return;

    setState(() {
      _conversation.add({'role': 'user', 'text': text, 'timestamp': DateTime.now()});
      _textController.clear();
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      final response = await _geminiService.sendQuery(
        text,
        weatherContext: _lastWeatherContext,
      );

      setState(() {
        _conversation.add({
          'role': 'assistant',
          'text': response['answer'],
          'timestamp': DateTime.now(),
        });
        _isLoading = false;
      });

      _scrollToBottom();
      await _tts.speak(response['answer']);
    } catch (e) {
      _showError('Failed to get response');
      setState(() => _isLoading = false);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Header with gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Voice Assistant',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _currentLanguage == 'ur' ? 'آپ کے سوالات کا جواب دینے کے لیے تیار' : 'Ready to assist you',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _currentLanguage == 'ur' ? 'اردو' : 'English',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentLanguage = _currentLanguage == 'ur' ? 'en' : 'ur';
                      });
                      _initTts();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white30),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.language, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            _currentLanguage == 'ur' ? 'Switch to English' : 'اردو میں بدلیں',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Chat Messages
          Expanded(
            child: _conversation.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(0xFF42A5F5).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.mic_none_rounded,
                            size: 48,
                            color: Color(0xFF42A5F5),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _currentLanguage == 'ur'
                              ? 'اپنا سوال بھیجیں یا مائیک دبائیں'
                              : 'Ask your question or press the mic',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _conversation.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _conversation.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      final msg = _conversation[index];
                      final isUser = msg['role'] == 'user';

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment:
                              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.75,
                              ),
                              decoration: BoxDecoration(
                                color: isUser
                                    ? Color(0xFF42A5F5)
                                    : Colors.grey[100],
                                borderRadius: BorderRadius.circular(16).copyWith(
                                  bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                                  bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              child: Text(
                                msg['text'],
                                style: TextStyle(
                                  color: isUser ? Colors.white : Colors.black87,
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Input Area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Column(
              children: [
                if (_lastWeatherContext != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info, color: Colors.blue, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _lastWeatherContext!,
                              style: const TextStyle(fontSize: 12, color: Colors.blue),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: _currentLanguage == 'ur'
                              ? 'اپنا سوال لکھیں...'
                              : 'Type your question...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onSubmitted: _sendMessage,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _handleVoiceInput,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _isListening
                              ? Colors.red
                              : Color(0xFF42A5F5),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _sendMessage(_textController.text),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Color(0xFF42A5F5),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
