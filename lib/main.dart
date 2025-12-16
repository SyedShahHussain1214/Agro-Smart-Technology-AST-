import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'config/theme.dart';
import 'config/theme_provider.dart';
import 'screens/home_screen_website_style.dart';
import 'screens/voice_qa_screen.dart';
import 'screens/disease_detection_screen.dart';
import 'screens/weather_screen.dart';
import 'screens/mandi_rates_screen.dart';
import 'screens/marketplace_screen_enhanced.dart';
import 'screens/notifications_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/settings_screen.dart';
import 'services/weather_service.dart';
import 'screens/otp_screen.dart';
import 'screens/about_us_screen.dart';
import 'screens/account_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const AgroSmartEnhanced(),
    ),
  );
}

class AgroSmartEnhanced extends StatelessWidget {
  const AgroSmartEnhanced({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Agro Smart Technology',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeProvider.themeMode,
          routes: {
            OtpScreen.routeName: (context) => const OtpScreen(),
            AboutUsScreen.routeName: (context) => const AboutUsScreen(),
            AccountScreen.routeName: (context) => const AccountScreen(),
            SettingsScreen.routeName: (context) => const SettingsScreen(),
          },
          home: const MainNavigationScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreenWebsiteStyle(),
    VoiceQAScreen(),
    MarketplaceScreenEnhanced(),
    DiseaseDetectionScreen(),
    WeatherScreen(),
    MandiRatesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 8,
          selectedItemColor: const Color(0xFF2E7D32),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mic_rounded),
              label: 'Voice',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_rounded),
              label: 'Market',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt_rounded),
              label: 'Disease',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud_rounded),
              label: 'Weather',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up_rounded),
              label: 'Mandi',
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final WeatherService _weatherService = WeatherService();
  late Future<Map<String, dynamic>> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _controller.forward();
    _weatherFuture = _weatherService.getCurrentWeather('Lahore');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===== HERO SECTION =====
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF2E7D32),
                    const Color(0xFF1B5E20),
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Agro Smart',
                              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Technology',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                        ScaleTransition(
                          scale: Tween(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.white30),
                            ),
                            child: const Icon(Icons.account_circle, color: Colors.white, size: 32),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Weather Widget
                  FutureBuilder<Map<String, dynamic>>(
                    future: _weatherFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!['success']) {
                        final weather = snapshot.data!['data'] as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.all(20),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: Colors.white30),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${weather['temp']}°C',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        weather['condition'],
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on, color: Colors.white70, size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${weather['city']}, ${weather['country']}',
                                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Icon(Icons.wb_sunny, color: Colors.yellow, size: 48),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    },
                  ),
                ],
              ),
            ),

            // ===== QUICK SERVICES GRID =====
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Services',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                    children: [
                      _ServiceCard(
                        icon: Icons.camera_alt_rounded,
                        title: 'Detect\nDisease',
                        color: const Color(0xFFEF5350),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const DiseaseDetectionScreen()),
                        ),
                      ),
                      _ServiceCard(
                        icon: Icons.mic_rounded,
                        title: 'Voice\nHelp',
                        color: const Color(0xFF42A5F5),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const VoiceQAScreen()),
                        ),
                      ),
                      _ServiceCard(
                        icon: Icons.shopping_bag_rounded,
                        title: 'Market\nplace',
                        color: const Color(0xFF66BB6A),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MarketplaceScreenEnhanced()),
                        ),
                      ),
                      _ServiceCard(
                        icon: Icons.trending_up_rounded,
                        title: 'Mandi\nRates',
                        color: const Color(0xFFFFA726),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MandiRatesScreen()),
                        ),
                      ),
                      _ServiceCard(
                        icon: Icons.cloudy_snowing,
                        title: 'Weather',
                        color: const Color(0xFF42A5F5),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const WeatherScreen()),
                        ),
                      ),
                      _ServiceCard(
                        icon: Icons.notifications_active_rounded,
                        title: 'Alerts',
                        color: const Color(0xFF9C27B0),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                        ),
                      ),
                      _ServiceCard(
                        icon: Icons.bar_chart_rounded,
                        title: 'Reports',
                        color: const Color(0xFF00ACC1),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const ReportsScreen()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ===== DAILY TIP SECTION =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: const Border(left: BorderSide(color: Color(0xFF2E7D32), width: 4)),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.lightbulb_rounded, color: Color(0xFFFFA726), size: 24),
                          const SizedBox(width: 8),
                          Text(
                            'Daily Farming Tip',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'To prevent cotton leaf curl virus, remove weeds from the field and use resistant varieties. Apply neem oil spray for better pest control.',
                        style: TextStyle(color: Colors.grey, height: 1.5, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ===== FEATURES SHOWCASE =====
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why Choose Agro Smart?',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _FeatureRow(
                    icon: Icons.speed,
                    title: 'Lightning Fast',
                    description: 'Instant responses with AI-powered analysis',
                  ),
                  const SizedBox(height: 12),
                  _FeatureRow(
                    icon: Icons.language,
                    title: 'Urdu Support',
                    description: 'Complete bilingual interface for farmers',
                  ),
                  const SizedBox(height: 12),
                  _FeatureRow(
                    icon: Icons.offline_bolt,
                    title: 'Works Offline',
                    description: 'Access cached data without internet',
                  ),
                  const SizedBox(height: 12),
                  _FeatureRow(
                    icon: Icons.verified,
                    title: 'Accurate Data',
                    description: 'Real-time market prices & forecasts',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 0.95).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        ),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: widget.color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(widget.icon, color: widget.color, size: 32),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFF2E7D32), size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
