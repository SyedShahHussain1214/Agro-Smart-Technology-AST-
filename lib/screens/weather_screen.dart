import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

const String OPENWEATHER_API_KEY = 'bd0a7106c8a51f1eb7d128794e741c7f';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _city = 'Lahore';
  Map<String, dynamic>? _weatherData;
  List<dynamic>? _forecast;
  bool _isLoading = false;

  final List<String> _cities = [
    'Lahore',
    'Karachi',
    'Islamabad',
    'Multan',
    'Faisalabad',
    'Peshawar',
    'Quetta',
    'Sialkot',
    'Gujranwala',
    'Rawalpindi',
  ];

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() => _isLoading = true);

    try {
      final currentWeather = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$_city&units=metric&appid=$OPENWEATHER_API_KEY'),
      );

      final forecast = await http.get(
        Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$_city&units=metric&appid=$OPENWEATHER_API_KEY'),
      );

      if (currentWeather.statusCode == 200 && forecast.statusCode == 200) {
        setState(() {
          _weatherData = jsonDecode(currentWeather.body);
          _forecast = jsonDecode(forecast.body)['list'];
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch weather');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching weather data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchWeather,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchWeather,
              child: ListView(
                padding: EdgeInsets.all(16),
                children: [
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: DropdownButtonFormField<String>(
                        value: _city,
                        decoration: InputDecoration(
                          labelText: 'Select City',
                          prefixIcon: Icon(Icons.location_city),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        items: _cities.map((city) => DropdownMenuItem(value: city, child: Text(city))).toList(),
                        onChanged: (value) {
                          setState(() => _city = value!);
                          _fetchWeather();
                        },
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  if (_weatherData != null) ...[
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              _city,
                              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${_weatherData!['main']['temp'].round()}°C',
                              style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            SizedBox(height: 8),
                            Text(
                              _weatherData!['weather'][0]['description'].toString().toUpperCase(),
                              style: TextStyle(fontSize: 18, color: Colors.white70, letterSpacing: 1.2),
                            ),
                            SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildWeatherInfo('Humidity', '${_weatherData!['main']['humidity']}%', Icons.water_drop, Colors.white),
                                _buildWeatherInfo('Wind', '${_weatherData!['wind']['speed']} m/s', Icons.air, Colors.white),
                                _buildWeatherInfo('Feels Like', '${_weatherData!['main']['feels_like'].round()}°C', Icons.thermostat, Colors.white),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: Theme.of(context).colorScheme.primary),
                        SizedBox(width: 8),
                        Text('5-Day Forecast', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 12),
                    
                    if (_forecast != null)
                      ...(_forecast!.take(8).toList().map((item) {
                        final temp = item['main']['temp'].round();
                        final desc = item['weather'][0]['description'];
                        final time = item['dt_txt'].toString().substring(11, 16);
                        final date = item['dt_txt'].toString().substring(5, 10);
                        
                        return Card(
                          margin: EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.wb_cloudy, size: 28, color: Theme.of(context).colorScheme.primary),
                            ),
                            title: Text('$temp°C', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            subtitle: Text(desc, style: TextStyle(fontSize: 12)),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(time, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text(date, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                              ],
                            ),
                          ),
                        );
                      })),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildWeatherInfo(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        SizedBox(height: 8),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
        Text(label, style: TextStyle(fontSize: 12, color: color.withOpacity(0.8))),
      ],
    );
  }
}
