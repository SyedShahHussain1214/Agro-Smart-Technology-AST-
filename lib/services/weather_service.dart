import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// OpenWeatherMap API Service
class WeatherService {
  static final WeatherService _instance = WeatherService._internal();

  factory WeatherService() {
    return _instance;
  }

  WeatherService._internal();

  /// Get current weather for a city
  Future<Map<String, dynamic>> getCurrentWeather(String city) async {
    try {
      final response = await http
          .get(
            Uri.parse(
                '${ApiConfig.weatherBaseUrl}/weather?q=$city&units=metric&appid=${ApiConfig.openweatherApiKey}'),
          )
          .timeout(const Duration(seconds: ApiConfig.requestTimeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'data': {
            'temp': data['main']['temp'].toInt(),
            'feelsLike': data['main']['feels_like'].toInt(),
            'humidity': data['main']['humidity'],
            'condition': data['weather'][0]['main'],
            'description': data['weather'][0]['description'],
            'windSpeed': data['wind']['speed'],
            'icon': data['weather'][0]['icon'],
            'city': data['name'],
            'country': data['sys']['country'],
            'pressure': data['main']['pressure'],
            'visibility': data['visibility'],
          }
        };
      }

      return {
        'success': false,
        'error': 'موسم کی معلومات نہیں ملی',
        'data': null,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'data': null,
      };
    }
  }

  /// Get weather forecast for next 5 days
  Future<Map<String, dynamic>> getForecast(String city) async {
    try {
      final response = await http
          .get(
            Uri.parse(
                '${ApiConfig.weatherBaseUrl}/forecast?q=$city&units=metric&appid=${ApiConfig.openweatherApiKey}'),
          )
          .timeout(const Duration(seconds: ApiConfig.requestTimeout));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final list = data['list'] as List;

        // Group by day
        final Map<String, dynamic> dailyForecasts = {};

        for (var item in list) {
          final dateStr = item['dt_txt'].toString().split(' ')[0];

          if (!dailyForecasts.containsKey(dateStr)) {
            dailyForecasts[dateStr] = item;
          }
        }

        final forecasts = dailyForecasts.entries
            .take(5)
            .map((entry) {
              final item = entry.value;
              final date = DateTime.parse('${entry.key} 12:00:00');

              return {
                'date': _formatDate(date),
                'temp': item['main']['temp'].toInt(),
                'tempMin': item['main']['temp_min'].toInt(),
                'tempMax': item['main']['temp_max'].toInt(),
                'condition': item['weather'][0]['main'],
                'description': item['weather'][0]['description'],
                'icon': item['weather'][0]['icon'],
                'humidity': item['main']['humidity'],
                'windSpeed': item['wind']['speed'],
                'rainfall': item['rain'] != null ? item['rain']['3h'] ?? 0 : 0,
              };
            })
            .toList();

        return {
          'success': true,
          'data': forecasts,
        };
      }

      return {
        'success': false,
        'error': 'پیشن گوئی نہیں ملی',
        'data': [],
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'data': [],
      };
    }
  }

  /// Get agricultural recommendations based on weather
  Map<String, dynamic> getAgricultureRecommendations(
      Map<String, dynamic> weather) {
    final int temp = weather['temp'] as int;
    final int humidity = weather['humidity'] as int;
    final String condition = weather['condition'] as String;

    List<String> recommendations = [];

    // Temperature-based recommendations
    if (temp < 10) {
      recommendations.add(
          'سردی زیادہ ہے۔ فسلوں کو سردی سے بچائیں۔ سردی سہنے والی فسلیں لگائیں۔');
    } else if (temp > 35) {
      recommendations.add(
          'گرمی زیادہ ہے۔ پانی زیادہ دیں۔ پودوں کو دھول سے بچائیں۔');
    }

    // Humidity-based recommendations
    if (humidity > 80) {
      recommendations.add('نمی زیادہ ہے۔ فنگل بیماریوں کا خطرہ ہے۔');
    } else if (humidity < 40) {
      recommendations.add('نمی کم ہے۔ زمین میں نمی برقرار رکھیں۔');
    }

    // Condition-based recommendations
    if (condition.contains('Rain')) {
      recommendations.add('بارش ہو رہی ہے۔ تھوڑا انتظار کریں پھر کام کریں۔');
    } else if (condition.contains('Cloud')) {
      recommendations.add('ابر آلود موسم۔ کھادیں اور زمین کی تیاری کریں۔');
    } else if (condition.contains('Clear')) {
      recommendations.add('صاف موسم۔ باہری کام کے لیے اچھا وقت۔');
    }

    return {
      'recommendations': recommendations,
      'urgency': recommendations.isNotEmpty ? 'high' : 'low',
    };
  }

  /// Format date for display
  String _formatDate(DateTime date) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'آج';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'کل';
    }

    final weekdays = [
      'پیر',
      'منگل',
      'بدھ',
      'جمعہ',
      'ہفتہ',
      'اتوار',
      'اتوار'
    ];
    return '${weekdays[date.weekday - 1]} ${date.day}';
  }
}
