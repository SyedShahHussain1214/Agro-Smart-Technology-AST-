import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

const String OPENAI_API_KEY = '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';

class VoiceQAScreen extends StatefulWidget {
  const VoiceQAScreen({Key? key}) : super(key: key);

  @override
  State<VoiceQAScreen> createState() => _VoiceQAScreenState();
}

class _VoiceQAScreenState extends State<VoiceQAScreen> {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  final TextEditingController _textController = TextEditingController();
  
  bool _isListening = false;
  bool _isLoading = false;
  List<Map<String, String>> _conversation = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initTts();
  }

  Future<void> _initSpeech() async {
    await Permission.microphone.request();
    await _speech.initialize();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('ur-PK');
    await _tts.setSpeechRate(0.5);
  }

  Future<void> _startListening() async {
    setState(() => _isListening = true);
    await _speech.listen(
      onResult: (result) {
        setState(() {
          _textController.text = result.recognizedWords;
        });
      },
      localeId: 'ur_PK',
    );
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
    if (_textController.text.isNotEmpty) {
      await _askAI(_textController.text);
    }
  }

  Future<void> _askAI(String question) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final messages = [
        {
          'role': 'system',
          'content': 'You are an expert agricultural AI assistant for Pakistani farmers. Provide practical advice in simple language.'
        },
        ..._conversation,
        {'role': 'user', 'content': question}
      ];

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $OPENAI_API_KEY',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': messages,
          'temperature': 0.7,
          'max_tokens': 500,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final answer = data['choices'][0]['message']['content'];
        
        setState(() {
          _conversation.add({'role': 'user', 'content': question});
          _conversation.add({'role': 'assistant', 'content': answer});
          _isLoading = false;
          _textController.clear();
        });

        await _tts.speak(answer);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Could not get response')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Q&A'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                _conversation.clear();
                _textController.clear();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _conversation.length,
              itemBuilder: (context, index) {
                final msg = _conversation[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isUser ? Theme.of(context).colorScheme.primary : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg['content']!,
                      style: TextStyle(color: isUser ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type or speak your question...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (text) {
                      if (text.isNotEmpty) {
                        _askAI(text);
                      }
                    },
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: _isListening ? _stopListening : _startListening,
                  child: Icon(_isListening ? Icons.stop : Icons.mic),
                  backgroundColor: _isListening ? Colors.red : Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _speech.cancel();
    _tts.stop();
    _textController.dispose();
    super.dispose();
  }
}
