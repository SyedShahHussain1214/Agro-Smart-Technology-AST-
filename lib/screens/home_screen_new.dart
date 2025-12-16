import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/voice_qa_screen.dart';
import '../screens/disease_detection_screen.dart';
import '../screens/marketplace_screen.dart';
import '../screens/weather_screen.dart';
import '../screens/mandi_rates_screen.dart';

class HomeScreenNew extends StatelessWidget {
  const HomeScreenNew({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===== HERO SECTION - Website Style =====
            Container(
              height: size.height * 0.70,
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
                  // Animated gradient overlay
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
                              fontSize: 36,
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
                          const SizedBox(height: 12),
                          // Urdu Headline
                          Text(
                            'پاکستانی کسانوں کو بااختیار بنائیں',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoNastaliqUrdu(
                              fontSize: 24,
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
                              fontSize: 16,
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
                          const SizedBox(height: 28),
                          // Feature Badges
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _FeatureBadge(icon: '🎤', text: 'Voice Q&A'),
                              _FeatureBadge(icon: '🌾', text: 'AI Detection'),
                              _FeatureBadge(icon: '📊', text: 'Mandi Rates'),
                              _FeatureBadge(icon: '🌦️', text: 'Weather'),
                            ],
                          ),
                          const SizedBox(height: 28),
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
                                      const Text('🚀', style: TextStyle(fontSize: 20)),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Start Now',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // Stats Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              _StatCard(number: '10K+', label: 'Farmers'),
                              _StatCard(number: '50K+', label: 'Queries'),
                              _StatCard(number: '95%', label: 'Accuracy'),
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                children: [
                  Text(
                    'Our Powerful Features',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF28a745),
                      shadows: [
                        Shadow(
                          color: const Color(0xFF28a745).withOpacity(0.3),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ہماری زبردست خصوصیات',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoNastaliqUrdu(
                      fontSize: 22,
                      color: isDark ? Colors.white.withOpacity(0.95) : const Color(0xFF1b5e20),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _WebsiteStyleFeatureCard(
                        title: 'Voice Q&A in Urdu',
                        titleUrdu: 'اردو میں آواز سے سوالات',
                        desc: 'Ask about crops, fertilizers, pests, weather — get instant answers in Urdu',
                        descUrdu: 'فصل، کھاد، کیڑے، موسم کے بارے میں پوچھیں — فوراً جواب سنیں',
                        icon: Icons.mic,
                        imagePath: 'assets/images/Voice Q&A in Urdu.jpg',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const VoiceQAScreen(),
                          ),
                        ),
                      ),
                      FeatureCard(
                        icon: Icons.agriculture,
                        title: 'Disease\nDetection',
                        subtitle: 'AI تشخیص',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DiseaseDetectionScreen(),
                          ),
                        ),
                      ),
                      FeatureCard(
                        icon: Icons.show_chart,
                        title: 'Mandi Rates',
                        subtitle: 'منڈی کے ریٹ',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MandiRatesScreen(),
                          ),
                        ),
                      ),
                      FeatureCard(
                        icon: Icons.store,
                        title: 'Marketplace',
                        subtitle: 'منڈی برائے کسان',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MarketplaceScreen(),
                          ),
                        ),
                      ),
                      FeatureCard(
                        icon: Icons.cloud,
                        title: 'Weather',
                        subtitle: 'موسم کی پیشگوئی',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const WeatherScreen(),
                          ),
                        ),
                      ),
                      FeatureCard(
                        icon: Icons.wifi_off,
                        title: 'Offline',
                        subtitle: 'انٹرنیٹ کے بغیر',
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ===== WHY CHOOSE US SECTION =====
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Why AST?',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  WhyChooseCard(
                    title: 'No More Guesswork',
                    description: 'AI-powered insights tailored to your crops and local conditions',
                    icon: Icons.lightbulb,
                  ),
                  const SizedBox(height: 16),
                  WhyChooseCard(
                    title: 'Fair Market Prices',
                    description: 'Connect directly with buyers, eliminate middlemen commission',
                    icon: Icons.trending_up,
                  ),
                  const SizedBox(height: 16),
                  WhyChooseCard(
                    title: 'Voice in Your Language',
                    description: 'Speak in Urdu, get guidance instantly—no reading needed',
                    icon: Icons.mic,
                  ),
                  const SizedBox(height: 16),
                  WhyChooseCard(
                    title: 'Works Offline',
                    description: 'Crop disease detection and tips work even without internet',
                    icon: Icons.cloud_off,
                  ),
                ],
              ),
            ),

            // ===== STATISTICS SECTION =====
            Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StatBox(
                    number: '10K+',
                    label: 'Farmers',
                    textColor: Colors.white,
                  ),
                  StatBox(
                    number: '₨50M+',
                    label: 'Earnings Gained',
                    textColor: Colors.white,
                  ),
                  StatBox(
                    number: '95%',
                    label: 'Yield Increase',
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),

            // ===== ABOUT SECTION =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withOpacity(0.15),
                      Theme.of(context).colorScheme.primary.withOpacity(0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.25 : 0.07),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About Agro Smart Technology',
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'AST is Pakistan\'s Urdu-first AI farm copilot. We combine voice, computer vision, mandi analytics, and climate intelligence so smallholders can make confident, profitable decisions every day.',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        height: 1.6,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: const [
                        _AboutPill(label: 'Urdu voice-first guidance'),
                        _AboutPill(label: 'AI crop disease detection in seconds'),
                        _AboutPill(label: 'Real-time mandi intelligence'),
                        _AboutPill(label: 'Weather + climate risk alerts'),
                        _AboutPill(label: 'Farmer-to-buyer marketplace'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: const [
                        Expanded(
                          child: _AboutCard(
                            title: 'Our Mission',
                            description: 'Empower every Pakistani farmer to earn more with data-backed, AI-powered decisions and zero language barriers.',
                            icon: Icons.flag,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _AboutCard(
                            title: 'Impact Focus',
                            description: 'Higher yields, fairer prices, and sustainable practices across cotton, rice, wheat, sugarcane, and horticulture.',
                            icon: Icons.eco,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: const [
                        Expanded(
                          child: _AboutCard(
                            title: 'Backed by R&D',
                            description: 'Models trained on local crop imagery, Urdu datasets, and mandi histories to stay relevant to every district.',
                            icon: Icons.science,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _AboutCard(
                            title: 'Community First',
                            description: 'Built with farmers, agronomists, and mandi partners to keep advice practical, safe, and trustworthy.',
                            icon: Icons.groups,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.notoNastaliqUrdu(
                  fontSize: 12,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WhyChooseCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const WhyChooseCard({
    required this.title,
    required this.description,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatBox extends StatelessWidget {
  final String number;
  final String label;
  final Color textColor;

  const StatBox({
    required this.number,
    required this.label,
    required this.textColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: textColor.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class _AboutPill extends StatelessWidget {
  final String label;
  const _AboutPill({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 16, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const _AboutCard({required this.title, required this.description, required this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
            ),
            child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    height: 1.5,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
