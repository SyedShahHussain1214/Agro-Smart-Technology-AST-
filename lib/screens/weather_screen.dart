import 'package:flutter/material.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();

  String _selectedCity = 'Lahore';
  Map<String, dynamic>? _currentWeather;
  List<Map<String, dynamic>> _forecast = [];
  bool _isLoading = false;
  String? _error;

  final List<String> _cities = const [
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
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final weatherResult = await _weatherService.getCurrentWeather(_selectedCity);
    final forecastResult = await _weatherService.getForecast(_selectedCity);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (weatherResult['success'] == true) {
        _currentWeather = weatherResult['data'] as Map<String, dynamic>;
      } else {
        _error = weatherResult['error']?.toString();
      }

      if (forecastResult['success'] == true) {
        _forecast = List<Map<String, dynamic>>.from(forecastResult['data'] as List);
      } else {
        _forecast = [];
        _error ??= forecastResult['error']?.toString();
      }
    });
  }

  String _conditionIcon(String condition) {
    if (condition.toLowerCase().contains('clear')) return '☀️';
    if (condition.toLowerCase().contains('cloud')) return '☁️';
    if (condition.toLowerCase().contains('rain')) return '🌧️';
    if (condition.toLowerCase().contains('storm')) return '⛈️';
    if (condition.toLowerCase().contains('snow')) return '❄️';
    return '🌡️';
  }

  List<Map<String, dynamic>> _hourlyFromForecast() {
    // The API provides 3h steps; surface the next 6 slots for a quick glance.
    return _forecast.take(6).toList();
  }

  List<String> _adviceLines() {
    if (_currentWeather == null) return ['Load weather to get tailored advice.'];
    final rec = _weatherService.getAgricultureRecommendations({
      'temp': _currentWeather!['temp'],
      'humidity': _currentWeather!['humidity'],
      'condition': _currentWeather!['condition'],
    });
    final lines = List<String>.from(rec['recommendations'] as List? ?? []);
    if (lines.isEmpty) lines.add('Conditions are stable. Continue regular field operations.');
    return lines;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadWeather,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildCityPicker(),
                      const SizedBox(height: 16),
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CircularProgressIndicator(color: Color(0xFF1976D2)),
                        )
                      else if (_error != null)
                        _buildErrorCard()
                      else if (_currentWeather != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildCurrentCard(),
                            const SizedBox(height: 16),
                            _buildMetricsRow(),
                            const SizedBox(height: 16),
                            _buildHourlyStrip(),
                            const SizedBox(height: 16),
                            _buildForecastCards(),
                            const SizedBox(height: 16),
                            _buildAdvisory(),
                            const SizedBox(height: 16),
                            _buildRadarPlaceholder(),
                          ],
                        )
                      else
                        const Text('No weather data yet'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Weather & Forecast',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Plan irrigation, spraying, and field work with precision.',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildCityPicker() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: DropdownButton<String>(
              value: _selectedCity,
              isExpanded: true,
              underline: const SizedBox(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedCity = val);
                  _loadWeather();
                }
              },
              items: _cities
                  .map(
                    (c) => DropdownMenuItem<String>(
                      value: c,
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 18),
                          const SizedBox(width: 8),
                          Text(c),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          icon: const Icon(Icons.refresh, color: Color(0xFF1976D2)),
          onPressed: _loadWeather,
        ),
      ],
    );
  }

  Widget _buildErrorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent),
          const SizedBox(width: 8),
          Expanded(child: Text(_error ?? 'Unable to load weather data.')),
          TextButton(
            onPressed: _loadWeather,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentCard() {
    final w = _currentWeather!;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF42A5F5).withOpacity(0.18),
            const Color(0xFF1976D2).withOpacity(0.22),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF42A5F5).withOpacity(0.4)),
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${w['temp']}°C',
                  style: const TextStyle(fontSize: 42, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  '${w['condition']} • Feels ${w['feelsLike']}°C',
                  style: const TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  '${w['city']}, ${w['country']}',
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                _conditionIcon(w['condition']),
                style: const TextStyle(fontSize: 36),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Text(
                  w['description'],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsRow() {
    final w = _currentWeather!;
    return Row(
      children: [
        _metricCard(Icons.water_drop, 'Humidity', '${w['humidity']}%'),
        const SizedBox(width: 10),
        _metricCard(Icons.air, 'Wind', '${w['windSpeed']} m/s'),
        const SizedBox(width: 10),
        _metricCard(Icons.compress, 'Pressure', '${w['pressure']} mb'),
      ],
    );
  }

  Widget _metricCard(IconData icon, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF1976D2)),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildHourlyStrip() {
    final hours = _hourlyFromForecast();
    if (hours.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Next Hours',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: hours.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final h = hours[index];
              return Container(
                width: 110,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_conditionIcon(h['condition']), style: const TextStyle(fontSize: 22)),
                    const SizedBox(height: 6),
                    Text('${h['temp']}°C', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(h['date'] ?? 'Today', style: const TextStyle(fontSize: 11, color: Colors.black54)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildForecastCards() {
    if (_forecast.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '5-Day Outlook',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 10),
        ..._forecast.map((day) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                ),
              ],
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Text(_conditionIcon(day['condition']), style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(day['date'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(day['description'], style: const TextStyle(color: Colors.black54, fontSize: 12)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${day['temp']}°C', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Min ${day['tempMin']}° • Max ${day['tempMax']}°',
                        style: const TextStyle(fontSize: 11, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAdvisory() {
    final lines = _adviceLines();
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green[300]!),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.agriculture, color: Colors.green),
              SizedBox(width: 8),
              Text('Farming Advice', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ...lines.map((l) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('• $l'),
              )),
        ],
      ),
    );
  }

  Widget _buildRadarPlaceholder() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.blueGrey[100]!),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: const [
          Icon(Icons.radar, color: Color(0xFF1976D2)),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Radar & maps integration placeholder. Connect to map tiles when API key available.',
              style: TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
