import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../config/theme_provider.dart';
import '../screens/voice_qa_screen.dart';
import '../screens/disease_detection_screen.dart';
import '../screens/marketplace_screen_enhanced.dart';
import '../screens/weather_screen.dart';
import '../screens/mandi_rates_screen.dart';

class HomeScreenWebsiteStyle extends StatelessWidget {
  const HomeScreenWebsiteStyle({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Theme Toggle FAB
          FloatingActionButton(
            heroTag: 'theme',
            onPressed: () {
              themeProvider.toggleTheme();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    themeProvider.themeMode == ThemeMode.light
                        ? '☀️ Light Mode'
                        : themeProvider.themeMode == ThemeMode.dark
                            ? '🌙 Dark Mode'
                            : '🌓 System Default',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            backgroundColor: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
            child: Icon(
              themeProvider.themeMode == ThemeMode.light
                  ? Icons.light_mode
                  : themeProvider.themeMode == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.brightness_auto,
              color: isDark ? Colors.black : Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          // Settings FAB
          FloatingActionButton(
            heroTag: 'settings',
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
            backgroundColor: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
            child: Icon(
              Icons.settings,
              color: isDark ? Colors.black : Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===== WEBSITE-STYLE HERO SECTION =====
            Container(
              height: size.height * 0.75,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF141E30).withOpacity(0.85),
                    const Color(0xFF243B55).withOpacity(0.75),
                    const Color(0xFF28a745).withOpacity(0.65),
                  ],
                ),
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/images/Real pakistani farmers using AST/Farmer-Empowered-with-mobile-tech-1536x643.jpg',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black54,
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Stack(
                children: [
                  // Gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            const Color(0xFF28a745).withOpacity(0.2),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Main Headline
                          Text(
                            'Empowering\nPakistani Farmers',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -0.8,
                              height: 1.1,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(0, 4),
                                  blurRadius: 30,
                                ),
                                Shadow(
                                  color: const Color(0xFF28a745).withOpacity(0.3),
                                  offset: const Offset(0, 0),
                                  blurRadius: 60,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Urdu Headline
                          Text(
                            'پاکستانی کسانوں کو بااختیار بنائیں',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoNastaliqUrdu(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFe8f5e9),
                              height: 1.4,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.6),
                                  offset: const Offset(0, 4),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Subtitle
                          Text(
                            'اردو میں بولیں، تصویر لیں، فوراً جواب پائیں',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoNastaliqUrdu(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.95),
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.5),
                                  offset: const Offset(0, 2),
                                  blurRadius: 15,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Feature Badges
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _FeatureBadge(icon: '🎤', text: 'Voice Q&A', textUrdu: 'آواز'),
                              _FeatureBadge(icon: '🌾', text: 'AI Detection', textUrdu: 'تشخیص'),
                              _FeatureBadge(icon: '📊', text: 'Mandi Rates', textUrdu: 'منڈی'),
                              _FeatureBadge(icon: '🌦️', text: 'Weather', textUrdu: 'موسم'),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // CTA Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF28a745),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(vertical: 18),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    elevation: 10,
                                    shadowColor: const Color(0xFF28a745).withOpacity(0.5),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => const VoiceQAScreen(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('🚀', style: TextStyle(fontSize: 22)),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Explore Features',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // About Us Button - More Prominent
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                side: const BorderSide(color: Colors.white, width: 2.5),
                                backgroundColor: Colors.white.withOpacity(0.15),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/about');
                              },
                              icon: const Icon(Icons.info_outline, size: 24),
                              label: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'About Us',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'ہمارے بارے میں',
                                    style: GoogleFonts.notoNastaliqUrdu(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 36),
                          // Stats Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              _StatCard(number: '10K+', label: 'Active Farmers', labelUrdu: 'فعال کسان'),
                              _StatCard(number: '50K+', label: 'Queries', labelUrdu: 'سوالات'),
                              _StatCard(number: '95%', label: 'Accuracy', labelUrdu: 'درستگی'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ===== FEATURES SECTION - Website Style =====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 48),
              child: Column(
                children: [
                  Text(
                    'Our Powerful Features',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF28a745),
                      shadows: [
                        Shadow(
                          color: const Color(0xFF28a745).withOpacity(0.3),
                          offset: const Offset(0, 2),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'ہماری زبردست خصوصیات',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoNastaliqUrdu(
                      fontSize: 24,
                      color: const Color(0xFF1b5e20),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _WebsiteStyleFeatureCard(
                    title: 'Voice Q&A in Urdu',
                    titleUrdu: 'اردو میں آواز سے سوالات',
                    desc: 'Ask about crops, fertilizers, pests, weather — get instant answers in Urdu',
                    descUrdu: 'فصل، کھاد، کیڑے، موسم کے بارے میں پوچھیں — فوراً جواب سنیں',
                    icon: Icons.mic,
                    imagePath: 'assets/images/Voice Q&A in Urdu.jpg',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VoiceQAScreen()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _WebsiteStyleFeatureCard(
                    title: 'AI Crop Disease Detection',
                    titleUrdu: 'فصل کی بیماری کی AI تشخیص',
                    desc: 'Take photo of leaf — instantly identify diseases in cotton, rice, wheat, sugarcane',
                    descUrdu: 'پتے کی تصویر لیں — کپاس، چاول، گندم، گنے کی بیماری فوراً پتہ چلے',
                    icon: Icons.agriculture,
                    imagePath: 'assets/images/AI Crop Disease Detection.jpg',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DiseaseDetectionScreen()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _WebsiteStyleFeatureCard(
                    title: 'Real-Time Mandi Rates',
                    titleUrdu: 'منڈی کے تازہ ریٹ',
                    desc: 'Latest prices from Lahore, Faisalabad, Multan mandis — updated daily',
                    descUrdu: 'لاہور، فیصل آباد، ملتان کی منڈیوں کے تازہ ترین ریٹ',
                    icon: Icons.show_chart,
                    imagePath: 'assets/images/Real-Time Mandi Rates.png',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MandiRatesScreen()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _WebsiteStyleFeatureCard(
                    title: 'Digital Farmer Marketplace',
                    titleUrdu: 'کسانوں کی ڈیجیٹل منڈی',
                    desc: 'Direct buyer-seller connection — no middlemen',
                    descUrdu: 'خریدار اور بیچنے والے کا براہ راست رابطہ — کوئی دلال نہیں',
                    icon: Icons.store,
                    imagePath: 'assets/images/Digital Farmer Marketplace.jpg',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MarketplaceScreenEnhanced()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _WebsiteStyleFeatureCard(
                    title: 'Accurate Weather Forecast',
                    titleUrdu: 'درست موسم کی پیشگوئی',
                    desc: 'Rain, temperature, humidity alerts for your area',
                    descUrdu: 'بارش، درجہ حرارت، نمی کی الرٹس',
                    icon: Icons.wb_sunny,
                    imagePath: 'assets/images/Accurate Weather Forecast.jpg',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const WeatherScreen()),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _WebsiteStyleFeatureCard(
                    title: 'Works Offline',
                    titleUrdu: 'انٹرنیٹ کے بغیر بھی کام کرتا ہے',
                    desc: 'Disease detection & basic advice available without internet',
                    descUrdu: 'بیماری کی تشخیص اور بنیادی مشورے آف لائن دستیاب',
                    icon: Icons.smartphone,
                    imagePath: 'assets/images/Works Offline.webp',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const DiseaseDetectionScreen()),
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
}

// Website-style feature badge
class _FeatureBadge extends StatelessWidget {
  final String icon;
  final String text;
  final String textUrdu;

  const _FeatureBadge({required this.icon, required this.text, required this.textUrdu});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF28a745).withOpacity(0.2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              Text(
                textUrdu,
                style: GoogleFonts.notoNastaliqUrdu(
                  fontSize: 9,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Website-style stat card
class _StatCard extends StatelessWidget {
  final String number;
  final String label;
  final String labelUrdu;

  const _StatCard({required this.number, required this.label, required this.labelUrdu});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF28a745).withOpacity(0.3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            number,
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 9,
              color: Colors.white,
            ),
          ),
          Text(
            labelUrdu,
            style: GoogleFonts.notoNastaliqUrdu(
              fontSize: 9,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }
}

// Website-style feature card with image
class _WebsiteStyleFeatureCard extends StatelessWidget {
  final String title;
  final String titleUrdu;
  final String desc;
  final String descUrdu;
  final IconData icon;
  final String imagePath;
  final VoidCallback onTap;

  const _WebsiteStyleFeatureCard({
    required this.title,
    required this.titleUrdu,
    required this.desc,
    required this.descUrdu,
    required this.icon,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                imagePath,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    size: 50,
                    color: const Color(0xFF28a745),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1b5e20),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    titleUrdu,
                    style: GoogleFonts.notoNastaliqUrdu(
                      fontSize: 18,
                      color: const Color(0xFF28a745),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    desc,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    descUrdu,
                    style: GoogleFonts.notoNastaliqUrdu(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.8),
                      height: 1.5,
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
}
