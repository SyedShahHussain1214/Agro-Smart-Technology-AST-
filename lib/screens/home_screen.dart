import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            backgroundColor: const Color(0xFF28a745),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.55),
                      Colors.black.withOpacity(0.55),
                    ],
                  ),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://images.unsplash.com/photo-1592980687637-3828bdaa1893?w=1600&q=80',
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
                      color: const Color(0xFF28a745),
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
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'ذہین زرعی مشیر',
                        style: GoogleFonts.notoNastaliqUrdu(
                          fontSize: 11,
                          color: Colors.white70,
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
              color: Colors.grey[100],
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Our Powerful Features',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF28a745),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ہماری زبردست خصوصیات',
                    style: GoogleFonts.notoNastaliqUrdu(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF28a745),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildFeatureCard(
                    context,
                    'Voice Q&A in Urdu',
                    'اردو میں آواز سے سوالات',
                    'Ask about crops, fertilizers, pests, weather — get instant answers in Urdu',
                    'فصل، کھاد، کیڑے، موسم کے بارے میں پوچھیں — فوراً جواب سنیں',
                    'https://images.unsplash.com/photo-1625246337847-05f68f9d0f4b?w=800&q=80',
                    Icons.mic,
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    context,
                    'AI Crop Disease Detection',
                    'فصل کی بیماری کی AI تشخیص',
                    'Take photo of leaf — instantly identify diseases in cotton, rice, wheat, sugarcane',
                    'پتے کی تصویر لیں — کپاس، چاول، گندم، گنے کی بیماری فوراً پتہ چلے',
                    'https://images.unsplash.com/photo-1631631581568-24747044c16f?w=800&q=80',
                    Icons.camera_alt,
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    context,
                    'Real-Time Mandi Rates',
                    'منڈی کے تازہ ریٹ',
                    'Latest prices from Lahore, Faisalabad, Multan mandis — updated daily',
                    'لاہور، فیصل آباد، ملتان کی منڈیوں کے تازہ ترین ریٹ',
                    'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&q=80',
                    Icons.attach_money,
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    context,
                    'Digital Farmer Marketplace',
                    'کسانوں کی ڈیجیٹل منڈی',
                    'Direct buyer-seller connection — no middlemen',
                    'خریدار اور بیچنے والے کا براہ راست رابطہ — کوئی دلال نہیں',
                    'https://images.unsplash.com/photo-1593113598332-cd288d649433?w=800&q=80',
                    Icons.store,
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    context,
                    'Accurate Weather Forecast',
                    'درست موسم کی پیشگوئی',
                    'Rain, temperature, humidity alerts for your area',
                    'بارش، درجہ حرارت، نمی کی الرٹس',
                    'https://images.unsplash.com/photo-1504384764586-2f2a9a3d0c43?w=800&q=80',
                    Icons.cloud,
                  ),
                  const SizedBox(height: 20),
                  _buildFeatureCard(
                    context,
                    'Works Offline',
                    'انٹرنیٹ کے بغیر بھی کام کرتا ہے',
                    'Disease detection & basic advice available without internet',
                    'بیماری کی تشخیص اور بنیادی مشورے آف لائن دستیاب',
                    'https://images.unsplash.com/photo-1592980687637-3828bdaa1893?w=800&q=80',
                    Icons.wifi_off,
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
    String imageUrl,
    IconData icon,
  ) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: const Color(0xFF28a745).withOpacity(0.2),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 80,
                      color: const Color(0xFF28a745),
                    ),
                  ),
                );
              },
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
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  titleUrdu,
                  style: GoogleFonts.notoNastaliqUrdu(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF28a745),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  descEn,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  descUrdu,
                  style: GoogleFonts.notoNastaliqUrdu(
                    fontSize: 14,
                    color: Colors.black54,
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
