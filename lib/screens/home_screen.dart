import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/voice_qa_screen.dart';
import '../screens/disease_detection_screen.dart';
import '../screens/marketplace_screen.dart';
import '../screens/weather_screen.dart';
import '../screens/notifications_screen.dart';
import '../screens/mandi_rates_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero Section matching website
          SliverAppBar(
            expandedHeight: 280,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.35),
                      Colors.black.withOpacity(0.55),
                    ],
                  ),
                  image: const DecorationImage(
                    image: AssetImage(
                      'assets/images/Real pakistani farmers using AST/Farmer-Empowered-with-mobile-tech-1536x643.jpg',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          'Empowering Pakistani Farmers',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'پاکستانی کسانوں کو بااختیار بنائیں',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoNastaliqUrdu(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'اردو میں بولیں، تصویر لیں، فوراً جواب پائیں',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.notoNastaliqUrdu(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const VoiceQAScreen()),
                              ),
                              icon: const Icon(Icons.mic),
                              label: Text(
                                'Start Voice Q&A',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                              ),
                            ),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(color: Colors.white.withOpacity(0.9)),
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const DiseaseDetectionScreen()),
                              ),
                              icon: const Icon(Icons.camera_alt),
                              label: Text(
                                'Detect Crop Disease',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              title: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'AST',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Agro Smart Tech',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        'ذہین زرعی مشیر',
                        style: GoogleFonts.notoNastaliqUrdu(
                          fontSize: 11,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Features Section
          SliverToBoxAdapter(
            child: Container(
              color: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Our Powerful Features',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ہماری زبردست خصوصیات',
                    style: GoogleFonts.notoNastaliqUrdu(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildFeatureCard(
                    context,
                    'Voice Q&A in Urdu',
                    'اردو میں آواز سے سوالات',
                    'Ask about crops, fertilizers, pests, weather — get instant answers in Urdu',
                    'فصل، کھاد، کیڑے، موسم کے بارے میں پوچھیں — فوراً جواب سنیں',
                    'assets/images/Voice Q&A in Urdu.jpg',
                    Icons.mic,
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    context,
                    'AI Crop Disease Detection',
                    'فصل کی بیماری کی AI تشخیص',
                    'Take photo of leaf — instantly identify diseases in cotton, rice, wheat, sugarcane',
                    'پتے کی تصویر لیں — کپاس، چاول، گندم، گنے کی بیماری فوراً پتہ چلے',
                    'assets/images/AI Crop Disease Detection.jpg',
                    Icons.camera_alt,
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    context,
                    'Real-Time Mandi Rates',
                    'منڈی کے تازہ ریٹ',
                    'Latest prices from Lahore, Faisalabad, Multan mandis — updated daily',
                    'لاہور، فیصل آباد، ملتان کی منڈیوں کے تازہ ترین ریٹ',
                    'assets/images/Real-Time Mandi Rates.png',
                    Icons.attach_money,
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    context,
                    'Digital Farmer Marketplace',
                    'کسانوں کی ڈیجیٹل منڈی',
                    'Direct buyer-seller connection — no middlemen',
                    'خریدار اور بیچنے والے کا براہ راست رابطہ — کوئی دلال نہیں',
                    'assets/images/Digital Farmer Marketplace.jpg',
                    Icons.store,
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    context,
                    'Accurate Weather Forecast',
                    'درست موسم کی پیشگوئی',
                    'Rain, temperature, humidity alerts for your area',
                    'بارش، درجہ حرارت، نمی کی الرٹس',
                    'assets/images/Accurate Weather Forecast.jpg',
                    Icons.cloud,
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    context,
                    'Works Offline',
                    'انٹرنیٹ کے بغیر بھی کام کرتا ہے',
                    'Disease detection & basic advice available without internet',
                    'بیماری کی تشخیص اور بنیادی مشورے آف لائن دستیاب',
                    'assets/images/Works Offline.webp',
                    Icons.wifi_off,
                  ),
                  const SizedBox(height: 30),
                  // Quick Services Grid
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.1,
                      children: [
                        _QuickTile(
                          icon: Icons.mic_rounded,
                          label: 'Voice Assistant',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const VoiceQAScreen()),
                          ),
                        ),
                        _QuickTile(
                          icon: Icons.camera_alt_rounded,
                          label: 'Disease Detection',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const DiseaseDetectionScreen()),
                          ),
                        ),
                        _QuickTile(
                          icon: Icons.storefront,
                          label: 'Marketplace',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const MarketplaceScreen()),
                          ),
                        ),
                        _QuickTile(
                          icon: Icons.trending_up_rounded,
                          label: 'Mandi Rates',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const MandiRatesScreen()),
                          ),
                        ),
                        _QuickTile(
                          icon: Icons.cloud_rounded,
                          label: 'Weather',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const WeatherScreen()),
                          ),
                        ),
                        _QuickTile(
                          icon: Icons.notifications,
                          label: 'Notifications',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                          ),
                        ),
                        _QuickTile(
                          icon: Icons.person,
                          label: 'Account',
                          onTap: () => Navigator.pushNamed(context, '/account'),
                        ),
                        _QuickTile(
                          icon: Icons.info_outline,
                          label: 'About Us',
                          onTap: () => Navigator.pushNamed(context, '/about'),
                        ),
                        _QuickTile(
                          icon: Icons.password,
                          label: 'OTP Verify',
                          onTap: () => Navigator.pushNamed(context, '/otp'),
                        ),
                        _QuickTile(
                          icon: Icons.analytics_outlined,
                          label: 'Mandi Analytics',
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const MandiRatesScreen()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String titleEn,
    String titleUrdu,
    String descEn,
    String descUrdu,
    String assetPath,
    IconData icon,
  ) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.asset(
              assetPath,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titleEn,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  titleUrdu,
                  style: GoogleFonts.notoNastaliqUrdu(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  descEn,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  descUrdu,
                  style: GoogleFonts.notoNastaliqUrdu(
                    fontSize: 14,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54,
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

class _QuickTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _QuickTile({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.06), blurRadius: 8, spreadRadius: 1),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary, size: 30),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
