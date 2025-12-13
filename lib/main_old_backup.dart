// EXACT PHOTOCOPY OF REACT WEBSITE
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AgroSmartTech());
}

class AgroSmartTech extends StatelessWidget {
  const AgroSmartTech({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agro Smart Technology',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF28a745),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF28a745)),
        fontFamily: 'Poppins',
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            return const WebsiteHomeScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}

// AUTH SCREEN (same as before)
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  String? _verificationId;
  bool _codeSent = false;
  bool _loading = false;

  Future<void> _sendOTP() async {
    String phoneNumber = _phoneController.text.replaceAll(RegExp(r'[^0-9+]'), '');
    if (!phoneNumber.startsWith('+')) {
      phoneNumber = '+92$phoneNumber';
    }
    if (phoneNumber.length < 13) {
      _showSnackBar('Enter valid phone number | صحیح فون نمبر درج کریں');
      return;
    }
    setState(() => _loading = true);
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() => _loading = false);
        _showSnackBar('Failed: ${e.message}');
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
          _loading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() => _verificationId = verificationId);
      },
      timeout: const Duration(seconds: 60),
    );
  }

  Future<void> _verifyOTP() async {
    if (_otpController.text.length != 6) {
      _showSnackBar('Enter 6-digit OTP | 6 ہندسوں کا کوڈ درج کریں');
      return;
    }
    setState(() => _loading = true);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _otpController.text,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      setState(() => _loading = false);
      _showSnackBar('Invalid OTP: ${e.message}');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: const Color(0xFF28a745)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF28a745),
              const Color(0xFF20c997),
              const Color(0xFF17a2b8),
              Colors.purple.shade300,
            ],
            stops: const [0.0, 0.4, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Logo Container
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.elasticOut,
                    builder: (context, double value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.3),
                                blurRadius: 30,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.agriculture_rounded, size: 80, color: Colors.white),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  // Glowing Title
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.white, Colors.white70, Colors.white],
                    ).createShader(bounds),
                    child: const Text(
                      'AgroSmart',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 10),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'ایگرو سمارٹ ٹیکنالوجی',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontFamily: 'NotoNastaliq',
                      shadows: [Shadow(color: Colors.black38, offset: Offset(0, 2), blurRadius: 8)],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Text(
                      'Smart Farming Assistant | ذہین زرعی مشیر',
                      style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 60),
                  const SizedBox(height: 60),
                  // Glass morphism input card
                  if (!_codeSent) ...[
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              labelText: 'Phone Number | فون نمبر',
                              labelStyle: const TextStyle(color: Colors.white70, fontFamily: 'NotoNastaliq', fontSize: 15),
                              hintText: '+923001234567',
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                              prefixIcon: const Icon(Icons.phone_android_rounded, color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _sendOTP,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF28a745),
                                elevation: 8,
                                shadowColor: Colors.black38,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: _loading
                                  ? const CircularProgressIndicator(color: Color(0xFF28a745))
                                  : const Text(
                                      'Send OTP | او ٹی پی بھیجیں',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'NotoNastaliq'),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.shield_rounded, size: 60, color: Colors.white),
                          const SizedBox(height: 20),
                          const Text(
                            'Enter Verification Code',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'تصدیقی کوڈ درج کریں',
                            style: TextStyle(color: Colors.white70, fontSize: 16, fontFamily: 'NotoNastaliq'),
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            controller: _otpController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 16,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              counterText: '',
                              hintText: '• • • • • •',
                              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), letterSpacing: 16),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(color: Colors.white, width: 2),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _verifyOTP,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF28a745),
                                elevation: 8,
                                shadowColor: Colors.black38,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: _loading
                                  ? const CircularProgressIndicator(color: Color(0xFF28a745))
                                  : const Text(
                                      'Verify OTP | تصدیق کریں',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'NotoNastaliq'),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}

// WEBSITE HOME SCREEN - EXACT PHOTOCOPY WITH HERO, FEATURES, GALLERY, DOWNLOAD, CONTACT
class WebsiteHomeScreen extends StatefulWidget {
  const WebsiteHomeScreen({Key? key}) : super(key: key);

  @override
  State<WebsiteHomeScreen> createState() => _WebsiteHomeScreenState();
}

class _WebsiteHomeScreenState extends State<WebsiteHomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int? _hoveredIndex;

  final List<Map<String, dynamic>> features = [
    {
      'icon': Icons.mic,
      'title': 'Voice Q&A in Urdu',
      'titleUrdu': 'اردو میں آواز سے سوالات',
      'desc': 'Ask about crops, fertilizers, pests, weather — get instant answers in Urdu',
      'descUrdu': 'فصل، کھاد، کیڑے، موسم کے بارے میں پوچھیں — فوراً جواب سنیں',
      'image': 'assets/images/Voice Q&A in Urdu.jpg',
      'screen': const VoiceQAScreen(),
    },
    {
      'icon': Icons.agriculture,
      'title': 'AI Crop Disease Detection',
      'titleUrdu': 'فصل کی بیماری کی AI تشخیص',
      'desc': 'Take photo of leaf — instantly identify diseases in cotton, rice, wheat, sugarcane',
      'descUrdu': 'پتے کی تصویر لیں — کپاس، چاول، گندم، گنے کی بیماری فوراً پتہ چلے',
      'image': 'assets/images/AI Crop Disease Detection.jpg',
      'screen': const DiseaseDetectionScreen(),
    },
    {
      'icon': Icons.trending_up,
      'title': 'Real-Time Mandi Rates',
      'titleUrdu': 'منڈی کے تازہ ریٹ',
      'desc': 'Latest prices from Lahore, Faisalabad, Multan mandis — updated daily',
      'descUrdu': 'لاہور، فیصل آباد، ملتان کی منڈیوں کے تازہ ترین ریٹ',
      'image': 'assets/images/Real-Time Mandi Rates.png',
      'screen': const MandiRatesScreen(),
    },
    {
      'icon': Icons.shop,
      'title': 'Digital Farmer Marketplace',
      'titleUrdu': 'کسانوں کی ڈیجیٹل منڈی',
      'desc': 'Direct buyer-seller connection — no middlemen',
      'descUrdu': 'خریدار اور بیچنے والے کا براہ راست رابطہ — کوئی دلال نہیں',
      'image': 'assets/images/Digital Farmer Marketplace.jpg',
      'screen': const MarketplaceScreen(),
    },
    {
      'icon': Icons.wb_sunny,
      'title': 'Accurate Weather Forecast',
      'titleUrdu': 'درست موسم کی پیشگوئی',
      'desc': 'Rain, temperature, humidity alerts for your area',
      'descUrdu': 'بارش، درجہ حرارت، نمی کی الرٹس',
      'image': 'assets/images/Accurate Weather Forecast.jpg',
      'screen': const WeatherScreen(),
    },
    {
      'icon': Icons.smartphone,
      'title': 'Works Offline',
      'titleUrdu': 'انٹرنیٹ کے بغیر بھی کام کرتا ہے',
      'desc': 'Disease detection & basic advice available without internet',
      'descUrdu': 'بیماری کی تشخیص اور بنیادی مشورے آف لائن دستیاب',
      'image': 'assets/images/Works Offline.webp',
      'screen': const OfflineFeaturesScreen(),
    },
  ];

  final List<String> galleryImages = [
    'assets/images/Voice Q&A in Urdu.jpg',
    'assets/images/AI Crop Disease Detection.jpg',
    'assets/images/Real-Time Mandi Rates.png',
    'assets/images/Digital Farmer Marketplace.jpg',
    'assets/images/Accurate Weather Forecast.jpg',
    'assets/images/Works Offline.webp',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // HEADER/NAV BAR
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 2,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/icons/icon.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            title: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Agro Smart Technology', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF28a745))),
                Text('ذہین زرعی مشیر', style: TextStyle(fontSize: 12, color: Color(0xFF28a745), fontFamily: 'NotoNastaliq')),
              ],
            ),
            actions: [
              IconButton(icon: const Icon(Icons.logout, color: Colors.black54), onPressed: () => FirebaseAuth.instance.signOut()),
            ],
          ),

          // HERO SECTION WITH BACKGROUND IMAGE
          SliverToBoxAdapter(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1592980687637-3828bdaa1893?w=1600&q=80'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF4ade80), Color(0xFF22d3ee), Colors.white],
                    ).createShader(bounds),
                    child: const Text(
                      'Empowering Pakistani Farmers',
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(offset: Offset(0, 4), blurRadius: 20, color: Colors.black45),
                          Shadow(offset: Offset(0, 8), blurRadius: 40, color: Colors.black26),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Text(
                      'پاکستانی کسانوں کو بااختیار بنائیں',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'NotoNastaliq',
                        shadows: [
                          Shadow(offset: Offset(0, 3), blurRadius: 15, color: Colors.black54),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'اردو میں بولیں، تصویر لیں، فوراً جواب پائیں',
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontFamily: 'NotoNastaliq',
                      fontWeight: FontWeight.w600,
                      shadows: [
                        Shadow(offset: Offset(0, 2), blurRadius: 10, color: Colors.black38),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF28a745),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        ),
                        child: const Text('Explore Features', style: TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                      const SizedBox(width: 20),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white, width: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                        ),
                        child: const Text('Download App', style: TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // FEATURES SECTION WITH CARDS AND IMAGES
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFFF5F5F5),
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
              child: Column(
                children: [
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF28a745), Color(0xFF20c997), Color(0xFF17a2b8)],
                    ).createShader(bounds),
                    child: const Text(
                      'Our Powerful Features',
                      style: TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(offset: Offset(0, 3), blurRadius: 15, color: Colors.black26),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFF28a745), Color(0xFF20c997)],
                    ).createShader(bounds),
                    child: const Text(
                      'ہماری زبردست خصوصیات',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'NotoNastaliq',
                        shadows: [
                          Shadow(offset: Offset(0, 2), blurRadius: 10, color: Colors.black26),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    children: List.generate(features.length, (index) {
                      final feature = features[index];
                      return MouseRegion(
                        onEnter: (_) => setState(() => _hoveredIndex = index),
                        onExit: (_) => setState(() => _hoveredIndex = null),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          transform: Matrix4.translationValues(0, _hoveredIndex == index ? -12 : 0, 0),
                          child: GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => feature['screen'])),
                            child: Card(
                              elevation: _hoveredIndex == index ? 8 : 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              child: SizedBox(
                                width: 350,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                      child: Image.asset(
                                        feature['image'],
                                        height: 260,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            height: 260,
                                            color: Colors.grey.shade200,
                                            child: const Center(
                                              child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        children: [
                                          Icon(feature['icon'], size: 60, color: const Color(0xFF28a745)),
                                          const SizedBox(height: 16),
                                          Text(feature['title'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                          const SizedBox(height: 4),
                                          Text(feature['titleUrdu'], style: const TextStyle(fontSize: 16, color: Color(0xFF28a745), fontFamily: 'NotoNastaliq'), textAlign: TextAlign.center),
                                          const SizedBox(height: 12),
                                          Text(feature['desc'], style: const TextStyle(fontSize: 14, color: Colors.black54), textAlign: TextAlign.center),
                                          const SizedBox(height: 4),
                                          Text(feature['descUrdu'], style: const TextStyle(fontSize: 13, color: Colors.black54, fontFamily: 'NotoNastaliq'), textAlign: TextAlign.center),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),

          // GALLERY SECTION
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
              child: Column(
                children: [
                  const Text(
                    'Real Farmers Using AST',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF28a745)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'حقیقی کسان استعمال کر رہے ہیں',
                    style: TextStyle(fontSize: 28, color: Color(0xFF28a745), fontFamily: 'NotoNastaliq'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: galleryImages.map((img) => ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        img,
                        width: 350,
                        height: 280,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 350,
                            height: 280,
                            color: Colors.grey[300],
                            child: Icon(Icons.broken_image, size: 50, color: Colors.grey[600]),
                          );
                        },
                      ),
                    )).toList(),
                  ),
                ],
              ),
            ),
          ),

          // DOWNLOAD SECTION
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFF28a745),
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: Column(
                children: [
                  const Text(
                    'Download Android App Now',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'ابھی اینڈرائیڈ ایپ ڈاؤن لوڈ کریں',
                    style: TextStyle(fontSize: 28, color: Colors.white, fontFamily: 'NotoNastaliq'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Full features available on mobile — synced with this website via Firebase',
                    style: TextStyle(fontSize: 20, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.download),
                        label: const Text('Download APK (Direct)', style: TextStyle(fontSize: 18)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF28a745),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                      ),
                      const SizedBox(width: 20),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white, width: 2),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        child: const Text('Google Play', style: TextStyle(fontSize: 18, color: Colors.white)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // CONTACT SECTION
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFFF5F5F5),
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
              child: Column(
                children: [
                  const Text(
                    'Contact Us',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xFF28a745)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'رابطہ کریں',
                    style: TextStyle(fontSize: 28, color: Color(0xFF28a745), fontFamily: 'NotoNastaliq'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Card(
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Your Name — آپ کا نام',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const TextField(
                              decoration: InputDecoration(
                                labelText: 'Phone +92',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const TextField(
                              maxLines: 6,
                              decoration: InputDecoration(
                                labelText: 'Your message — آپ کا پیغام',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF28a745),
                                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                              ),
                              child: const Text('Send Message — پیغام بھیجیں', style: TextStyle(fontSize: 18, color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // FOOTER
          SliverToBoxAdapter(
            child: Container(
              color: const Color(0xFFF8F9FA),
              padding: const EdgeInsets.all(40),
              child: const Column(
                children: [
                  Text('© 2025 Agro Smart Technology — All Rights Reserved', style: TextStyle(fontSize: 14)),
                  SizedBox(height: 8),
                  Text(
                    'Developed by Syed Shah Hussain & Malik Abdul Rehman | University of Management & Technology, Lahore',
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// VOICE Q&A SCREEN - Enhanced with Gemini Live API Integration
class VoiceQAScreen extends StatefulWidget {
  const VoiceQAScreen({Key? key}) : super(key: key);

  @override
  State<VoiceQAScreen> createState() => _VoiceQAScreenState();
}

class _VoiceQAScreenState extends State<VoiceQAScreen> with TickerProviderStateMixin {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isListening = false;
  bool _isConnected = false;
  String _recognizedText = '';
  String _response = '';
  List<Map<String, String>> _chatHistory = [];
  final ScrollController _scrollController = ScrollController();
  
  // Enhanced UI
  late AnimationController _pulseController;
  late AnimationController _waveController;
  
  // Gemini API Key for AI Voice Assistant
  final String _geminiApiKey = 'AIzaSyCMiwIbXChxDow0QyVzAbyoSFUSi8q5pC8';
  
  // Weather & Crop Data
  Map<String, dynamic> _weatherData = {
    'temp': '--',
    'condition': 'Waiting for update...',
    'humidity': '--'
  };
  List<Map<String, dynamic>> _cropRates = [];

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _tts.setLanguage('ur-PK');
    _tts.setSpeechRate(0.5);
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  Future<void> _initSpeech() async {
    await _speech.initialize();
    setState(() {});
  }

  Future<void> _startListening() async {
    if (!_isListening && _speech.isAvailable) {
      setState(() {
        _isListening = true;
        _recognizedText = '';
      });
      await _speech.listen(
        onResult: (result) {
          setState(() => _recognizedText = result.recognizedWords);
          if (result.finalResult) {
            _sendToGemini(_recognizedText);
            _stopListening();
          }
        },
        localeId: 'ur_PK',
      );
    }
  }

  void _stopListening() {
    if (_isListening) {
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  Future<void> _sendToGemini(String query) async {
    if (query.isEmpty) return;
    
    setState(() {
      _chatHistory.add({'role': 'user', 'text': query});
      _response = 'Thinking...';
    });
    _scrollToBottom();

    try {
      final response = await http.post(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=$_geminiApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'contents': [
            {
              'parts': [
                {'text': '''You are AgriVoice AI, an expert agricultural assistant for Pakistani farmers.
                
Context: Pakistan, Urdu/English speaking farmers.
User Question: $query

Provide a concise, practical answer in simple Urdu/English. If asked about weather or crop prices, use real-time data and structure your response clearly.

Answer:'''}
              ]
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 500,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Detailed error checking for API response structure
        if (data['candidates'] == null || data['candidates'].isEmpty) {
          throw Exception('No candidates in response');
        }
        
        if (data['candidates'][0]['content'] == null) {
          throw Exception('No content in candidate');
        }
        
        if (data['candidates'][0]['content']['parts'] == null || 
            data['candidates'][0]['content']['parts'].isEmpty) {
          throw Exception('No parts in content');
        }
        
        final answer = data['candidates'][0]['content']['parts'][0]['text'];
        
        if (answer == null || answer.isEmpty) {
          throw Exception('Empty response from API');
        }
        
        setState(() {
          _response = answer;
          _chatHistory.add({'role': 'assistant', 'text': answer});
        });
        
        // Parse and update dashboard if contains structured data
        _parseResponseForDashboard(answer);
        
        await _tts.speak(answer);
        _scrollToBottom();
      } else {
        // Log detailed error response
        final errorBody = response.body;
        print('API Error ${response.statusCode}: $errorBody');
        
        setState(() {
          _response = 'API Error: Status ${response.statusCode}. Please check your API key and internet connection.';
          _chatHistory.add({
            'role': 'assistant',
            'text': 'Sorry, I encountered an API error (${response.statusCode}). Please try again.'
          });
        });
      }
    } catch (e, stackTrace) {
      print('Exception in _sendToGemini: $e');
      print('Stack trace: $stackTrace');
      
      String userFriendlyError = 'Sorry, I encountered an error.';
      
      if (e.toString().contains('SocketException') || e.toString().contains('Network')) {
        userFriendlyError = 'Network error. Please check your internet connection.';
      } else if (e.toString().contains('FormatException')) {
        userFriendlyError = 'Invalid API response format. Please check your API key.';
      } else if (e.toString().contains('No candidates') || e.toString().contains('No content')) {
        userFriendlyError = 'API returned no response. Your request may have been blocked. Try a different question.';
      }
      
      setState(() {
        _response = userFriendlyError;
        _chatHistory.add({'role': 'assistant', 'text': userFriendlyError});
      });
    }
  }

  void _parseResponseForDashboard(String response) {
    // Simple pattern matching for weather data
    final tempMatch = RegExp(r'(\d+)°[CF]').firstMatch(response);
    final humidityMatch = RegExp(r'(\d+)%\s*humidity', caseSensitive: false).firstMatch(response);
    
    if (tempMatch != null || humidityMatch != null) {
      setState(() {
        if (tempMatch != null) _weatherData['temp'] = '${tempMatch.group(1)}°C';
        if (humidityMatch != null) _weatherData['humidity'] = '${humidityMatch.group(1)}%';
        _weatherData['condition'] = 'Updated from AI';
      });
    }
    
    // Pattern for crop prices (example: "Wheat: Rs 3500")
    final priceMatches = RegExp(r'(\w+):\s*Rs\s*(\d+)', caseSensitive: false).allMatches(response);
    if (priceMatches.isNotEmpty) {
      setState(() {
        _cropRates.clear();
        for (final match in priceMatches) {
          _cropRates.add({
            'name': match.group(1)!,
            'price': 'Rs ${match.group(2)}',
            'trend': 'stable',
          });
        }
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f172a), // slate-900
      appBar: AppBar(
        backgroundColor: const Color(0xFF1e293b), // slate-800
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF28a745),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.mic_rounded, size: 20),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AgriVoice AI', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Dynamic Farm Assistant', style: TextStyle(fontSize: 11, color: Colors.white70)),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _isConnected ? const Color(0xFF28a745).withOpacity(0.2) : Colors.grey.shade700,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isConnected ? const Color(0xFF28a745) : Colors.grey,
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _isConnected ? const Color(0xFF28a745) : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  _isConnected ? 'Live' : 'Ready',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _isConnected ? const Color(0xFF28a745) : Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Dashboard Cards Row
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Weather Card
                Expanded(
                  child: _DashboardCard(
                    icon: Icons.cloud_rounded,
                    iconColor: Colors.blue.shade400,
                    title: 'Weather',
                    value: _weatherData['temp'],
                    subtitle: _weatherData['condition'],
                  ),
                ),
                const SizedBox(width: 12),
                // Market Card
                Expanded(
                  child: _DashboardCard(
                    icon: Icons.trending_up_rounded,
                    iconColor: Colors.green.shade400,
                    title: 'Market',
                    value: _cropRates.isEmpty ? '--' : '${_cropRates.length} items',
                    subtitle: _cropRates.isEmpty ? 'Ask for prices' : 'Updated',
                  ),
                ),
              ],
            ),
          ),
          
          // Chat History
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1e293b).withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: _chatHistory.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.mic_none_rounded, size: 80, color: Colors.white.withOpacity(0.2)),
                          const SizedBox(height: 16),
                          Text(
                            'Press the mic button to start',
                            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'مائیک دبائیں اور بات کریں',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 14,
                              fontFamily: 'NotoNastaliq',
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _chatHistory.length,
                      itemBuilder: (context, index) {
                        final chat = _chatHistory[index];
                        final isUser = chat['role'] == 'user';
                        return Align(
                          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                            decoration: BoxDecoration(
                              gradient: isUser
                                  ? const LinearGradient(
                                      colors: [Color(0xFF28a745), Color(0xFF20c997)],
                                    )
                                  : LinearGradient(
                                      colors: [Colors.grey.shade800, Colors.grey.shade700],
                                    ),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(isUser ? 16 : 4),
                                bottomRight: Radius.circular(isUser ? 4 : 16),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              chat['text']!,
                              style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
          
          // Visualizer & Mic Button
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Animated Wave Visualizer
                if (_isListening)
                  SizedBox(
                    height: 60,
                    child: AnimatedBuilder(
                      animation: _waveController,
                      builder: (context, child) {
                        return CustomPaint(
                          painter: _WavePainter(_waveController.value),
                          size: const Size(double.infinity, 60),
                        );
                      },
                    ),
                  ),
                
                const SizedBox(height: 20),
                
                // Mic Button with Pulse Animation
                GestureDetector(
                  onTap: _isListening ? _stopListening : _startListening,
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      return Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: _isListening
                                ? [Colors.red.shade600, Colors.red.shade400]
                                : [const Color(0xFF28a745), const Color(0xFF20c997)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (_isListening ? Colors.red : const Color(0xFF28a745))
                                  .withOpacity(0.4 + _pulseController.value * 0.3),
                              blurRadius: 30,
                              spreadRadius: _isListening ? 10 : 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isListening ? Icons.mic : Icons.mic_none_rounded,
                          size: 45,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 16),
                
                Text(
                  _isListening ? 'Listening... | سن رہے ہیں...' : 'Tap to Speak | بولنے کے لیے دبائیں',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontFamily: 'NotoNastaliq',
                  ),
                ),
                
                if (_recognizedText.isNotEmpty && _isListening)
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Text(
                      _recognizedText,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tts.stop();
    _speech.stop();
    _pulseController.dispose();
    _waveController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

// Dashboard Card Widget
class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;

  const _DashboardCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1e293b),
            const Color(0xFF334155),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// Wave Painter for Audio Visualizer
class _WavePainter extends CustomPainter {
  final double animationValue;

  _WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF28a745)
      ..style = PaintingStyle.fill;

    final bars = 30;
    final barWidth = size.width / bars;

    for (int i = 0; i < bars; i++) {
      final phase = (i / bars + animationValue) * 2 * 3.14159;
      final height = (sin(phase) * 0.5 + 0.5) * size.height * 0.8;
      
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            i * barWidth + barWidth * 0.2,
            size.height / 2 - height / 2,
            barWidth * 0.6,
            height,
          ),
          const Radius.circular(4),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) => true;
}
// DISEASE DETECTION SCREEN (complete with TFLite)
class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  File? _image;
  String _result = '';
  bool _loading = false;
  Interpreter? _interpreter;
  List<String> _labels = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('assets/models/plant_disease_model.tflite');
      final labelData = await rootBundle.loadString('assets/models/labels.txt');
      _labels = labelData.split('\n').where((l) => l.trim().isNotEmpty).toList();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Model error: $e')));
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
      await _classifyImage();
    }
  }

  Future<void> _classifyImage() async {
    if (_image == null || _interpreter == null || _labels.isEmpty) {
      setState(() => _result = 'Model not loaded');
      return;
    }
    setState(() => _loading = true);
    try {
      final bytes = await _image!.readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      image = img.copyResize(image!, width: 224, height: 224);
      var input = _createInputTensor(image);
      var output = List<double>.filled(_labels.length, 0).reshape([1, _labels.length]);
      _interpreter!.run(input, output);
      final maxIndex = output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b));
      final confidence = (output[0][maxIndex] * 100).toStringAsFixed(1);
      setState(() {
        _result = '${_labels[maxIndex]} ($confidence%)';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
        _loading = false;
      });
    }
  }

  List<List<List<List<double>>>> _createInputTensor(img.Image image) {
    return List.generate(1, (batch) => List.generate(224, (y) => List.generate(224, (x) {
      final pixel = image.getPixel(x, y);
      return [(pixel.r as num).toDouble() / 255.0, (pixel.g as num).toDouble() / 255.0, (pixel.b as num).toDouble() / 255.0];
    })));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Disease Detection'), backgroundColor: const Color(0xFF28a745)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (_image != null) Image.file(_image!, height: 300, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 20),
            if (_loading) const CircularProgressIndicator(),
            if (_result.isNotEmpty) ...[
              const Text('Result:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(_result, style: const TextStyle(fontSize: 18)),
            ],
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera),
                  label: const Text('Camera'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF28a745)),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo),
                  label: const Text('Gallery'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF28a745)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _interpreter?.close();
    super.dispose();
  }
}

// WEATHER SCREEN (complete with OpenWeatherMap API)
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  // TODO: Get FREE API key from: https://openweathermap.org/api
  // See API_KEYS_SETUP.md for instructions
  final String _apiKey = 'your-openweathermap-key'; // Replace with your actual key
  Map<String, dynamic>? _weatherData;
  bool _loading = false;
  final TextEditingController _cityController = TextEditingController(text: 'Lahore');

  Future<void> _fetchWeather() async {
    setState(() => _loading = true);
    try {
      final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=${_cityController.text},PK&appid=$_apiKey&units=metric'));
      if (response.statusCode == 200) {
        setState(() => _weatherData = json.decode(response.body));
      } else {
        throw Exception('Status ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather Forecast'), backgroundColor: const Color(0xFF28a745)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(controller: _cityController, decoration: const InputDecoration(labelText: 'City', border: OutlineInputBorder())),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _fetchWeather, child: const Text('Get Weather')),
            const SizedBox(height: 32),
            if (_loading) const CircularProgressIndicator(),
            if (_weatherData != null) ...[
              Text('${_weatherData!['name']}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              Text('${_weatherData!['main']['temp']}°C', style: const TextStyle(fontSize: 48)),
              Text('${_weatherData!['weather'][0]['description']}', style: const TextStyle(fontSize: 20)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _WeatherDetail('Humidity', '${_weatherData!['main']['humidity']}%'),
                  _WeatherDetail('Wind', '${_weatherData!['wind']['speed']} m/s'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _WeatherDetail(String label, String value) => Column(children: [Text(label, style: const TextStyle(color: Colors.grey)), Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]);
}

// MANDI RATES SCREEN
class MandiRatesScreen extends StatelessWidget {
  const MandiRatesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final rates = [
      {'crop': 'Wheat', 'mandi': 'Lahore', 'price': '3500', 'unit': 'per 40kg'},
      {'crop': 'Rice', 'mandi': 'Faisalabad', 'price': '4200', 'unit': 'per 40kg'},
      {'crop': 'Cotton', 'mandi': 'Multan', 'price': '7800', 'unit': 'per 40kg'},
      {'crop': 'Sugarcane', 'mandi': 'Lahore', 'price': '280', 'unit': 'per 40kg'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Mandi Rates'), backgroundColor: const Color(0xFF28a745)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: rates.length,
        itemBuilder: (context, index) {
          final rate = rates[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.grain, color: Color(0xFF28a745)),
              title: Text(rate['crop']!),
              subtitle: Text('${rate['mandi']} - Rs ${rate['price']} ${rate['unit']}'),
            ),
          );
        },
      ),
    );
  }
}

// MARKETPLACE SCREEN
class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marketplace'), backgroundColor: const Color(0xFF28a745)),
      body: const Center(child: Text('Marketplace coming soon!', style: TextStyle(fontSize: 20))),
    );
  }
}

// OFFLINE FEATURES SCREEN
class OfflineFeaturesScreen extends StatelessWidget {
  const OfflineFeaturesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offline Features'), backgroundColor: const Color(0xFF28a745)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Card(child: ListTile(leading: Icon(Icons.tips_and_updates), title: Text('Farming Tips'), subtitle: Text('Access saved tips offline'))),
          Card(child: ListTile(leading: Icon(Icons.history), title: Text('History'), subtitle: Text('View past detections'))),
          Card(child: ListTile(leading: Icon(Icons.book), title: Text('Guide'), subtitle: Text('Crop care guide'))),
        ],
      ),
    );
  }
}
