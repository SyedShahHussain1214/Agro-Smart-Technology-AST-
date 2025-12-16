import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const routeName = '/about';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF141E30).withOpacity(0.95),
                    const Color(0xFF243B55).withOpacity(0.90),
                  ]
                : [
                    const Color(0xFFf8f9fa),
                    const Color(0xFFe9ecef),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About Us',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                          ),
                        ),
                        Text(
                          'ہمارے بارے میں',
                          style: GoogleFonts.notoNastaliqUrdu(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _HeroSection(isDark: isDark),
                    const SizedBox(height: 24),
                    _MissionSection(isDark: isDark),
                    const SizedBox(height: 24),
                    _TeamSection(isDark: isDark),
                    const SizedBox(height: 24),
                    _ContactSection(isDark: isDark),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final bool isDark;
  const _HeroSection({required this.isDark});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Image.asset(
              'assets/images/Real pakistani farmers using AST/Farmer-Empowered-with-mobile-tech-1536x643.jpg',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Agro Smart Technology',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'زرعی سمارٹ ٹیکنالوجی',
                    style: GoogleFonts.notoNastaliqUrdu(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF4ade80),
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

class _MissionSection extends StatelessWidget {
  final bool isDark;
  const _MissionSection({required this.isDark});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1f35).withOpacity(0.6) : Colors.white,
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
          Row(
            children: [
              Icon(
                Icons.flag,
                color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Our Mission',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'ہمارا مقصد',
            style: GoogleFonts.notoNastaliqUrdu(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Agro Smart Technology (AST) is a multilingual voice-assisted platform designed specifically for Pakistani smallholder farmers. We provide voice-based guidance on modern farming techniques, pest identification and control, weather updates, market prices, and direct buyer-seller connections through our digital marketplace. By using speech-to-text, text-to-speech, and offline-capable AI models in Urdu and regional languages, AST aims to bridge the digital and knowledge divide, reduce unnecessary pesticide use, increase yield, and improve farmers\' income.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'ایگرو سمارٹ ٹیکنالوجی (AST) ایک کثیر لسانی آواز سے چلنے والا پلیٹ فارم ہے جو خاص طور پر پاکستانی چھوٹے کسانوں کے لیے ڈیزائن کیا گیا ہے۔ ہم جدید زرعی تکنیکوں، کیڑوں کی شناخت اور کنٹرول، موسم کی تازہ ترین معلومات، مارکیٹ کی قیمتوں، اور ڈیجیٹل بازار کے ذریعے براہ راست خریدار اور فروخت کنندہ کے رابطے پر آواز پر مبنی رہنمائی فراہم کرتے ہیں۔',
            style: GoogleFonts.notoNastaliqUrdu(
              fontSize: 13,
              color: isDark ? Colors.white.withOpacity(0.85) : Colors.black87,
              height: 1.8,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}

class _TeamSection extends StatelessWidget {
  final bool isDark;
  const _TeamSection({required this.isDark});
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Our Team',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
          ),
        ),
        Text(
          'ہماری ٹیم',
          style: GoogleFonts.notoNastaliqUrdu(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          childAspectRatio: 3 / 4,
          shrinkWrap: true,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _TeamCard(
              name: 'Syed Shah Hussain',
              nameUrdu: 'سید شاہ حسین',
              role: 'Co-Developer',
              roleUrdu: 'شریک ڈویلپر',
              rollNo: 'S2024387008',
              asset: 'assets/images/syed shah hussain.jpeg',
              isDark: isDark,
            ),
            _TeamCard(
              name: 'Malik Abdul Rehman',
              nameUrdu: 'ملک عبدالرحمٰن',
              role: 'Co-Developer',
              roleUrdu: 'شریک ڈویلپر',
              rollNo: 'S2024387002',
              asset: 'assets/images/malik abdul rehman.jpeg',
              isDark: isDark,
            ),
          ],
        ),
      ],
    );
  }
}

class _TeamCard extends StatelessWidget {
  final String name;
  final String nameUrdu;
  final String role;
  final String roleUrdu;
  final String rollNo;
  final String asset;
  final bool isDark;
  const _TeamCard({
    super.key,
    required this.name,
    required this.nameUrdu,
    required this.role,
    required this.roleUrdu,
    required this.rollNo,
    required this.asset,
    required this.isDark,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1f35).withOpacity(0.6) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Image.asset(asset, height: 100, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                const SizedBox(height: 2),
                Text(
                  nameUrdu,
                  style: GoogleFonts.notoNastaliqUrdu(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: isDark ? Colors.white70 : Colors.grey,
                  ),
                ),
                Text(
                  roleUrdu,
                  style: GoogleFonts.notoNastaliqUrdu(
                    fontSize: 9,
                    color: isDark ? Colors.white60 : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  rollNo,
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    color: isDark ? Colors.white60 : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}


class _LogoTile extends StatelessWidget {
  final String asset;
  final bool isDark;
  const _LogoTile({super.key, required this.asset, required this.isDark});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1f35).withOpacity(0.4) : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF4ade80).withOpacity(0.3) : Colors.grey.shade300,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Image.asset(asset, fit: BoxFit.contain),
    );
  }
}

class _ContactSection extends StatelessWidget {
  final bool isDark;
  const _ContactSection({required this.isDark});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1f35).withOpacity(0.6) : Colors.white,
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
          Row(
            children: [
              Icon(
                Icons.contact_mail,
                color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'Contact',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'رابطہ',
            style: GoogleFonts.notoNastaliqUrdu(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
            ),
          ),
          const SizedBox(height: 16),
          _ContactItem(
            icon: Icons.email,
            text: 'hello@agrosmart.tech',
            isDark: isDark,
          ),
          _ContactItem(
            icon: Icons.phone,
            text: '+92 300 1234567',
            isDark: isDark,
          ),
          _ContactItem(
            icon: Icons.location_on,
            text: 'Lahore, Pakistan',
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;
  
  const _ContactItem({
    required this.icon,
    required this.text,
    required this.isDark,
  });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: isDark ? Colors.white.withOpacity(0.9) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
