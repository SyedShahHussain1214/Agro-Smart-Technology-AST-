import 'dart:convert';
import 'package:http/http.dart' as http;

/// Mandi Rates Service - Real crop price data from markets
class MandiService {
  static final MandiService _instance = MandiService._internal();

  factory MandiService() {
    return _instance;
  }

  MandiService._internal();

  // Mock data with real Pakistani mandi data structure
  // In production, this would connect to a real API
  final List<Map<String, dynamic>> _mandiData = [
    {
      'id': 1,
      'name': 'Wheat',
      'nameUrdu': 'گندم',
      'price': 3500,
      'previousPrice': 3350,
      'unit': 'per 40kg',
      'city': 'Lahore',
      'marketName': 'Chakbeli',
      'lastUpdated': DateTime.now().subtract(const Duration(hours: 2)),
      'quality': 'Grade A',
    },
    {
      'id': 2,
      'name': 'Rice',
      'nameUrdu': 'چاول',
      'price': 4200,
      'previousPrice': 4280,
      'unit': 'per 40kg',
      'city': 'Faisalabad',
      'marketName': 'Grain Market',
      'lastUpdated': DateTime.now().subtract(const Duration(hours: 1)),
      'quality': 'Grade A',
    },
    {
      'id': 3,
      'name': 'Cotton',
      'nameUrdu': 'کپاس',
      'price': 7500,
      'previousPrice': 7500,
      'unit': 'per 40kg',
      'city': 'Multan',
      'marketName': 'Cotton Exchange',
      'lastUpdated': DateTime.now().subtract(const Duration(hours: 3)),
      'quality': 'Grade B',
    },
    {
      'id': 4,
      'name': 'Sugarcane',
      'nameUrdu': 'گنا',
      'price': 320,
      'previousPrice': 300,
      'unit': 'per 40kg',
      'city': 'Lahore',
      'marketName': 'Sugar Market',
      'lastUpdated': DateTime.now().subtract(const Duration(hours: 2)),
      'quality': 'Fresh',
    },
    {
      'id': 5,
      'name': 'Maize',
      'nameUrdu': 'مکئی',
      'price': 2800,
      'previousPrice': 2800,
      'unit': 'per 40kg',
      'city': 'Faisalabad',
      'marketName': 'Grain Market',
      'lastUpdated': DateTime.now().subtract(const Duration(hours: 4)),
      'quality': 'Grade A',
    },
    {
      'id': 6,
      'name': 'Potato',
      'nameUrdu': 'آلو',
      'price': 1200,
      'previousPrice': 1300,
      'unit': 'per 40kg',
      'city': 'Multan',
      'marketName': 'Vegetable Market',
      'lastUpdated': DateTime.now().subtract(const Duration(minutes: 30)),
      'quality': 'Fresh',
    },
    {
      'id': 7,
      'name': 'Onion',
      'nameUrdu': 'پیاز',
      'price': 2500,
      'previousPrice': 2300,
      'unit': 'per 40kg',
      'city': 'Lahore',
      'marketName': 'Vegetable Market',
      'lastUpdated': DateTime.now().subtract(const Duration(minutes: 45)),
      'quality': 'Fresh',
    },
    {
      'id': 8,
      'name': 'Tomato',
      'nameUrdu': 'ٹماٹر',
      'price': 3000,
      'previousPrice': 2700,
      'unit': 'per 40kg',
      'city': 'Faisalabad',
      'marketName': 'Vegetable Market',
      'lastUpdated': DateTime.now().subtract(const Duration(minutes: 20)),
      'quality': 'Fresh',
    },
  ];

  /// Get all mandi rates
  Future<Map<String, dynamic>> getMandiRates({String? city}) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      List<Map<String, dynamic>> filteredData = List.from(_mandiData);

      if (city != null && city.isNotEmpty) {
        filteredData = filteredData.where((item) => 
          item['city'].toString().toLowerCase() == city.toLowerCase()
        ).toList();
      }

      // Calculate trend
      for (var item in filteredData) {
        final current = item['price'] as int;
        final previous = item['previousPrice'] as int;

        if (current > previous) {
          item['trend'] = 'up';
          item['change'] = '+${current - previous}';
        } else if (current < previous) {
          item['trend'] = 'down';
          item['change'] = '-${previous - current}';
        } else {
          item['trend'] = 'stable';
          item['change'] = '0';
        }
      }

      return {
        'success': true,
        'data': filteredData,
        'lastUpdated': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'data': [],
      };
    }
  }

  /// Get rates for a specific crop
  Future<Map<String, dynamic>> getCropRates(String cropName) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final crop = _mandiData.firstWhere(
        (item) =>
            item['name'].toString().toLowerCase() ==
            cropName.toLowerCase(),
        orElse: () => {},
      );

      if (crop.isEmpty) {
        return {
          'success': false,
          'error': 'فصل نہیں ملی',
          'data': null,
        };
      }

      return {
        'success': true,
        'data': crop,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
        'data': null,
      };
    }
  }

  /// Get rates for a specific city
  Future<Map<String, dynamic>> getCityRates(String city) async {
    return getMandiRates(city: city);
  }

  /// Get all available cities
  Future<List<String>> getAvailableCities() async {
    try {
      final cities = _mandiData.map((item) => item['city'] as String).toSet();
      return cities.toList()..sort();
    } catch (e) {
      return [];
    }
  }

  /// Get price history for a crop (mock data)
  Future<Map<String, dynamic>> getPriceHistory(String cropName,
      {int days = 7}) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final crop = _mandiData.firstWhere(
        (item) =>
            item['name'].toString().toLowerCase() ==
            cropName.toLowerCase(),
        orElse: () => {},
      );

      if (crop.isEmpty) {
        return {
          'success': false,
          'error': 'ڈیٹا نہیں ملا',
        };
      }

      // Generate mock historical data
      final history = <Map<String, dynamic>>[];
      final basePrice = crop['price'] as int;

      for (int i = days; i >= 0; i--) {
        final date = DateTime.now().subtract(Duration(days: i));
        final variation = (i * 50 - 100); // Small daily variations
        history.add({
          'date': '${date.day}/${date.month}',
          'price': (basePrice + variation).abs(),
        });
      }

      return {
        'success': true,
        'data': {
          'name': crop['name'],
          'nameUrdu': crop['nameUrdu'],
          'history': history,
        },
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Update a mandi rate (for admin/backend)
  Future<Map<String, dynamic>> updateRate(int id, int newPrice) async {
    try {
      final index = _mandiData.indexWhere((item) => item['id'] == id);
      if (index != -1) {
        _mandiData[index]['previousPrice'] = _mandiData[index]['price'];
        _mandiData[index]['price'] = newPrice;
        _mandiData[index]['lastUpdated'] = DateTime.now();

        return {
          'success': true,
          'message': 'قیمت اپڈیٹ ہو گئی',
        };
      }

      return {
        'success': false,
        'error': 'آئٹم نہیں ملا',
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
