/// API Configuration for Agro Smart Technology
/// All API keys should be defined as constants or read from environment

class ApiConfig {
  // ============ API Endpoints ============
  static const String geminBaseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
  static const String openaiBaseUrl = 'https://api.openai.com/v1';
  static const String weatherBaseUrl = 'https://api.openweathermap.org/data/2.5';
  static const String firebaseProjectId = 'agro-smart-technology';

  // ============ API Keys ============
  // IMPORTANT:
  // Never hardcode real API keys in source code.
  // Provide them at runtime using --dart-define.
  // Example:
  // flutter run --dart-define=OPENAI_API_KEY=sk-proj-... --dart-define=GEMINI_API_KEY=... --dart-define=OPENWEATHER_API_KEY=...

  static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  static const String openaiApiKey = String.fromEnvironment('OPENAI_API_KEY', defaultValue: '');
  static const String openweatherApiKey = String.fromEnvironment('OPENWEATHER_API_KEY', defaultValue: '');

  // ============ API Models ============
  static const String geminiFlashModel = 'gemini-2.0-flash-exp';
  static const String openaiModel = 'gpt-4o-mini';

  // ============ Default Settings ============
  static const String defaultLanguage = 'ur'; // Urdu
  static const String defaultCity = 'Lahore';
  static const String defaultCountry = 'Pakistan';

  // ============ API Request Configuration ============
  static const int requestTimeout = 30; // seconds
  static const int maxRetries = 3;
  static const int retryDelayMs = 1000;

  // ============ Feature Flags ============
  static const bool enableOfflineMode = true;
  static const bool enableLocalCaching = true;
  static const bool enableAnalytics = true;
}

/// Environment-specific configuration
enum Environment { development, staging, production }

class EnvironmentConfig {
  static Environment currentEnvironment = Environment.production;

  static String getApiKey(String keyName) {
    switch (keyName) {
      case 'gemini':
        return ApiConfig.geminiApiKey;
      case 'openai':
        return ApiConfig.openaiApiKey;
      case 'openweather':
        return ApiConfig.openweatherApiKey;
      default:
        throw Exception('Unknown API key: $keyName');
    }
  }
}
