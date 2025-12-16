import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Gemini AI Service for Voice Q&A and context-aware responses
class GeminiService {
  static final GeminiService _instance = GeminiService._internal();

  factory GeminiService() {
    return _instance;
  }

  GeminiService._internal();

  List<Map<String, dynamic>> conversationHistory = [];

  /// Send a query to Gemini API with conversation context
  Future<Map<String, dynamic>> sendQuery(String query, {bool includeWeather = false, String? weatherContext}) async {
    try {
      final systemPrompt = '''You are AgriVoice AI, an expert agricultural assistant for Pakistani farmers.
You provide practical, concise agricultural advice in simple Urdu and English.
User is from Pakistan and likely has limited digital literacy.
Keep responses short, actionable, and practical.
${weatherContext != null ? 'Weather context: $weatherContext' : ''}
Always be helpful and encouraging.''';

      conversationHistory.add({
        'role': 'user',
        'parts': [{'text': query}]
      });

      final requestBody = {
        'contents': conversationHistory,
        'systemInstruction': {
          'parts': [{'text': systemPrompt}]
        },
        'generationConfig': {
          'temperature': 0.7,
          'maxOutputTokens': 500,
          'topP': 0.9,
        }
      };

      final response = await http
          .post(
            Uri.parse(
                '${ApiConfig.geminBaseUrl}/${ApiConfig.geminiFlashModel}:generateContent?key=${ApiConfig.geminiApiKey}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: ApiConfig.requestTimeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final answer = data['candidates'][0]['content']['parts'][0]['text'];
          
          conversationHistory.add({
            'role': 'model',
            'parts': [{'text': answer}]
          });

          return {
            'success': true,
            'answer': answer,
            'error': null,
          };
        }
      }

      return {
        'success': false,
        'answer': 'سماف کریں، میں نے جواب دینے میں مسئلہ کا سامنا کیا۔ براہ کرم دوبارہ کوشش کریں۔',
        'error': 'API returned status ${response.statusCode}',
      };
    } catch (e) {
      return {
        'success': false,
        'answer': 'کنکشن کی خرابی۔ براہ کرم انٹرنیٹ چیک کریں۔',
        'error': e.toString(),
      };
    }
  }

  /// Clear conversation history
  void clearHistory() {
    conversationHistory.clear();
  }

  /// Get conversation history
  List<Map<String, dynamic>> getHistory() {
    return List.from(conversationHistory);
  }

  /// Analyze image with Gemini Vision
  Future<Map<String, dynamic>> analyzeImage(List<int> imageBytes, String mimeType) async {
    try {
      final base64Image = base64Encode(imageBytes);

      final requestBody = {
        'contents': [
          {
            'parts': [
              {'text': 'Identify any crop diseases in this image. Provide disease name, severity (mild/moderate/severe), and treatment recommendations in Urdu and English. Be specific and practical for Pakistani farmers.'},
              {
                'inlineData': {
                  'mimeType': mimeType,
                  'data': base64Image,
                }
              }
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.4,
          'maxOutputTokens': 600,
        }
      };

      final response = await http
          .post(
            Uri.parse(
                '${ApiConfig.geminBaseUrl}/${ApiConfig.geminiFlashModel}:generateContent?key=${ApiConfig.geminiApiKey}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: ApiConfig.requestTimeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final analysis = data['candidates'][0]['content']['parts'][0]['text'];
          return {
            'success': true,
            'analysis': analysis,
            'error': null,
          };
        }
      }

      return {
        'success': false,
        'analysis': 'تصویر کا تجزیہ نہیں ہو سکا۔',
        'error': 'API Error',
      };
    } catch (e) {
      return {
        'success': false,
        'analysis': 'تصویر اپ لوڈ کرنے میں خرابی',
        'error': e.toString(),
      };
    }
  }
}
