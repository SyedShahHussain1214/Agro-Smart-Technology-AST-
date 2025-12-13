import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF28a745),
          primary: const Color(0xFF28a745),
        ),
        fontFamily: 'Poppins',
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF28a745),
                      Color(0xFF20c997),
                      Color(0xFF17a2b8),
                    ],
                  ),
                ),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              ),
            );
          }
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}

// AUTH SCREEN
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
  int _resendToken = 60;

  void _sendOTP() async {
    if (_phoneController.text.isEmpty) return;
    setState(() => _loading = true);

    String phone = '+92${_phoneController.text.replaceAll(RegExp(r'[^0-9]'), '')}';

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
          _loading = false;
        });
        _startResendTimer();
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (mounted) {
          setState(() => _verificationId = verificationId);
        }
      },
    );
  }

  void _startResendTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_resendToken > 0 && mounted) {
        setState(() => _resendToken--);
        _startResendTimer();
      }
    });
  }

  void _verifyOTP() async {
    if (_otpController.text.isEmpty || _verificationId == null) return;
    setState(() => _loading = true);

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: _otpController.text,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid OTP: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF141e30),
              Color(0xFF243b55),
              Color(0xFF28a745),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4ade80), Color(0xFF22d3ee), Colors.white],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF28a745).withOpacity(0.6),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.agriculture, size: 60, color: Color(0xFF28a745)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Colors.white, Color(0xFF4ade80)],
                    ).createShader(bounds),
                    child: const Text(
                      'Agro Smart Technology',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ذہین زرعی مشیر',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'NotoNastaliq',
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              if (!_codeSent) ...[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.3),
                                        ),
                                      ),
                                      child: TextField(
                                        controller: _phoneController,
                                        keyboardType: TextInputType.phone,
                                        style: const TextStyle(color: Colors.white, fontSize: 16),
                                        decoration: InputDecoration(
                                          labelText: 'Phone Number',
                                          labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                          hintText: '3001234567',
                                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                                          prefixText: '+92 ',
                                          prefixStyle: const TextStyle(color: Colors.white),
                                          prefixIcon: Icon(Icons.phone, color: Colors.white.withOpacity(0.8)),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.all(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: _loading ? null : _sendOTP,
                                      borderRadius: BorderRadius.circular(50),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFF28a745), Color(0xFF20c997)],
                                          ),
                                          borderRadius: BorderRadius.circular(50),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF28a745).withOpacity(0.5),
                                              blurRadius: 20,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: _loading
                                              ? const SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child: CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                                )
                                              : const Text(
                                                  'Send Code • کوڈ بھیجیں',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ] else ...[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.3),
                                        ),
                                      ),
                                      child: TextField(
                                        controller: _otpController,
                                        keyboardType: TextInputType.number,
                                        maxLength: 6,
                                        style: const TextStyle(color: Colors.white, fontSize: 16),
                                        decoration: InputDecoration(
                                          labelText: 'Enter OTP',
                                          labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                          counterText: '',
                                          prefixIcon: Icon(Icons.lock, color: Colors.white.withOpacity(0.8)),
                                          border: InputBorder.none,
                                          contentPadding: const EdgeInsets.all(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 56,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: _loading ? null : _verifyOTP,
                                      borderRadius: BorderRadius.circular(50),
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [Color(0xFF28a745), Color(0xFF20c997)],
                                          ),
                                          borderRadius: BorderRadius.circular(50),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF28a745).withOpacity(0.5),
                                              blurRadius: 20,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: _loading
                                              ? const SizedBox(
                                                  width: 24,
                                                  height: 24,
                                                  child: CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                                )
                                              : const Text(
                                                  'Verify • تصدیق کریں',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                TextButton(
                                  onPressed: _resendToken == 0 ? () {
                                    setState(() => _resendToken = 60);
                                    _sendOTP();
                                  } : null,
                                  child: Text(
                                    _resendToken > 0 ? 'Resend in $_resendToken s' : 'Resend OTP',
                                    style: TextStyle(color: Colors.white.withOpacity(0.9)),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// HOME SCREEN - Main Feature Cards
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final features = [
      {
        'title': 'Voice Q&A in Urdu',
        'titleUrdu': 'اردو میں آواز سے سوالات',
        'desc': 'Ask about crops, fertilizers, pests',
        'descUrdu': 'فصل، کھاد، کیڑے کے بارے میں پوچھیں',
        'image': 'assets/images/Voice Q&A in Urdu.jpg',
        'screen': const VoiceQAScreen(),
      },
      {
        'title': 'AI Crop Disease Detection',
        'titleUrdu': 'فصل کی بیماری کی AI تشخیص',
        'desc': 'Take photo to identify diseases',
        'descUrdu': 'تصویر لیں اور بیماری کی تشخیص کریں',
        'image': 'assets/images/AI Crop Disease Detection.jpg',
        'screen': const DiseaseDetectionScreen(),
      },
      {
        'title': 'Real-Time Mandi Rates',
        'titleUrdu': 'منڈی کے تازہ ریٹ',
        'desc': 'Latest prices from major mandis',
        'descUrdu': 'بڑی منڈیوں کے تازہ ترین ریٹ',
        'image': 'assets/images/Real-Time Mandi Rates.png',
        'screen': const MandiRatesScreen(),
      },
      {
        'title': 'Digital Farmer Marketplace',
        'titleUrdu': 'کسانوں کی ڈیجیٹل منڈی',
        'desc': 'Direct buyer-seller connection',
        'descUrdu': 'براہ راست خریدار اور بیچنے والے کا رابطہ',
        'image': 'assets/images/Digital Farmer Marketplace.jpg',
        'screen': const MarketplaceScreen(),
      },
      {
        'title': 'Accurate Weather Forecast',
        'titleUrdu': 'درست موسم کی پیشگوئی',
        'desc': 'Rain, temperature, humidity alerts',
        'descUrdu': 'بارش، درجہ حرارت، نمی کی الرٹس',
        'image': 'assets/images/Accurate Weather Forecast.jpg',
        'screen': const WeatherScreen(),
      },
      {
        'title': 'Works Offline',
        'titleUrdu': 'انٹرنیٹ کے بغیر بھی کام کرتا ہے',
        'desc': 'Disease detection without internet',
        'descUrdu': 'بیماری کی تشخیص آف لائن دستیاب',
        'image': 'assets/images/Works Offline.webp',
        'screen': const OfflineFeaturesScreen(),
      },
    ];

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF141e30),
              Color(0xFF243b55),
              Color(0xFF28a745),
            ],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                title: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.white, Color(0xFF4ade80)],
                  ).createShader(bounds),
                  child: const Text(
                    'AST - Agro Smart Technology',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF141e30),
                        Color(0xFF243b55),
                        Color(0xFF28a745),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4ade80), Color(0xFF22d3ee), Colors.white],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF28a745).withOpacity(0.6),
                                blurRadius: 40,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(Icons.agriculture, size: 60, color: Color(0xFF28a745)),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Colors.white, Color(0xFF4ade80)],
                          ).createShader(bounds),
                          child: const Text(
                            'Empowering Pakistani Farmers',
                            style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'پاکستانی کسانوں کو بااختیار بنائیں',
                          style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(0.9), fontFamily: 'NotoNastaliq'),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.logout, color: Colors.white),
                          onPressed: () => FirebaseAuth.instance.signOut(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final feature = features[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => feature['screen'] as Widget),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.asset(
                                          feature['image'] as String,
                                          fit: BoxFit.cover,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.3),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          feature['title'] as String,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Colors.white,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          feature['titleUrdu'] as String,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: 'NotoNastaliq',
                                            color: const Color(0xFF4ade80).withOpacity(0.9),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Spacer(),
                                        Text(
                                          feature['desc'] as String,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white.withOpacity(0.7),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: features.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// WEATHER SCREEN
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Map<String, dynamic>? weatherData;
  bool loading = false;
  String city = 'Lahore';

  // OpenWeatherMap API - Get from environment variable
  final String apiKey = const String.fromEnvironment('OPENWEATHER_API_KEY', defaultValue: '');

  Future<void> fetchWeather() async {
    setState(() => loading = true);
    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city,pk&appid=$apiKey&units=metric'));
      if (response.statusCode == 200) {
        setState(() => weatherData = json.decode(response.body));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
    setState(() => loading = false);
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Color(0xFF4ade80)],
          ).createShader(bounds),
          child: const Text('Weather Forecast', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF141e30), Color(0xFF243b55), Color(0xFF28a745)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: TextField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Enter City',
                          labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                          hintText: 'Lahore, Faisalabad, Multan',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search, color: Colors.white),
                            onPressed: fetchWeather,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(20),
                        ),
                        onChanged: (value) => city = value,
                        onSubmitted: (_) => fetchWeather(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (loading)
                  const Expanded(child: Center(child: CircularProgressIndicator(color: Colors.white)))
                else if (weatherData != null)
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  weatherData!['name'],
                                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 16),
                                ShaderMask(
                                  shaderCallback: (bounds) => const LinearGradient(
                                    colors: [Color(0xFF4ade80), Color(0xFF22d3ee)],
                                  ).createShader(bounds),
                                  child: Text(
                                    '${weatherData!['main']['temp'].toStringAsFixed(1)}°C',
                                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                                Text(
                                  weatherData!['weather'][0]['description'].toUpperCase(),
                                  style: TextStyle(fontSize: 20, color: Colors.white.withOpacity(0.9)),
                                ),
                                const SizedBox(height: 32),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildWeatherDetail('Humidity', '${weatherData!['main']['humidity']}%'),
                                    _buildWeatherDetail('Wind', '${weatherData!['wind']['speed']} m/s'),
                                    _buildWeatherDetail('Pressure', '${weatherData!['main']['pressure']} hPa'),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Divider(color: Colors.white.withOpacity(0.3)),
                                const SizedBox(height: 16),
                                Text(
                                  '🌾 Farming Tips',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ...getFarmingTips().map((tip) => Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: Text(
                                    tip,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7))),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  // Get farming tips based on weather conditions (same as website)
  List<String> getFarmingTips() {
    if (weatherData == null) return [];
    
    List<String> tips = [];
    final temp = weatherData!['main']['temp'];
    final humidity = weatherData!['main']['humidity'];
    final weather = weatherData!['weather'][0]['main'].toString().toLowerCase();
    final windSpeed = weatherData!['wind']['speed'];
    
    // Temperature-based tips
    if (temp > 35) {
      tips.add('🌡️ High temperature detected. Ensure adequate irrigation for crops.');
    } else if (temp < 10) {
      tips.add('❄️ Low temperature. Protect sensitive crops from frost damage.');
    }
    
    // Humidity-based tips
    if (humidity > 70) {
      tips.add('💧 High humidity. Monitor crops for fungal diseases.');
    }
    
    // Weather condition tips
    if (weather.contains('rain')) {
      tips.add('🌧️ Rain expected. Delay pesticide application and check drainage systems.');
    } else if (weather.contains('clear')) {
      tips.add('☀️ Clear skies. Perfect for spraying pesticides or harvesting.');
    } else if (weather.contains('cloud')) {
      tips.add('☁️ Cloudy weather. Good time for transplanting seedlings.');
    }
    
    // Wind-based tips
    if (windSpeed > 10) {
      tips.add('💨 High winds. Avoid spraying and secure tall crops.');
    }
    
    // Default tip
    if (tips.isEmpty) {
      tips.add('✅ Weather conditions are favorable for normal farming activities.');
    }
    
    return tips;
  }
}

// MANDI RATES SCREEN
class MandiRatesScreen extends StatefulWidget {
  const MandiRatesScreen({Key? key}) : super(key: key);

  @override
  State<MandiRatesScreen> createState() => _MandiRatesScreenState();
}

class _MandiRatesScreenState extends State<MandiRatesScreen> {
  bool loading = false;
  List<Map<String, String>> rates = [];

  // You'll need a custom backend API or web scraping service for Pakistan mandi prices
  // Example API endpoint: https://your-backend.com/api/mandi-rates
  Future<void> fetchMandiRates() async {
    setState(() => loading = true);
    
    // DEMO DATA - Replace with real API call
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      rates = [
        {'crop': 'Wheat', 'mandi': 'Lahore', 'price': '2800', 'unit': '40kg'},
        {'crop': 'Rice (Basmati)', 'mandi': 'Faisalabad', 'price': '5500', 'unit': '40kg'},
        {'crop': 'Cotton', 'mandi': 'Multan', 'price': '7200', 'unit': '40kg'},
        {'crop': 'Sugarcane', 'mandi': 'Lahore', 'price': '300', 'unit': '40kg'},
        {'crop': 'Corn', 'mandi': 'Faisalabad', 'price': '2200', 'unit': '40kg'},
      ];
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMandiRates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Color(0xFF4ade80)],
          ).createShader(bounds),
          child: const Text('Mandi Rates', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: fetchMandiRates,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF141e30), Color(0xFF243b55), Color(0xFF28a745)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.orange.withOpacity(0.5)),
                    ),
                    child: const Text(
                      '⚠️ API Required: Integrate with Pakistan Mandi API or create custom backend',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              if (loading)
                const Expanded(child: Center(child: CircularProgressIndicator(color: Colors.white)))
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: rates.length,
                    itemBuilder: (context, index) {
                      final rate = rates[index];
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.3)),
                            ),
                            child: ListTile(
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF4ade80), Color(0xFF22d3ee)],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    rate['crop']![0],
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              title: Text(
                                rate['crop']!,
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              subtitle: Text(
                                '${rate['mandi']} Mandi',
                                style: TextStyle(color: Colors.white.withOpacity(0.7)),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) => const LinearGradient(
                                      colors: [Color(0xFF4ade80), Color(0xFF22d3ee)],
                                    ).createShader(bounds),
                                    child: Text(
                                      'Rs ${rate['price']}',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                  Text(
                                    'per ${rate['unit']}',
                                    style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// DISEASE DETECTION SCREEN
class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  File? selectedImage;
  String result = '';
  bool loading = false;
  
  // Gemini API key from environment variable
  final String geminiApiKey = const String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        result = '';
      });
      await analyzeImageWithGemini();
    }
  }

  Future<void> analyzeImageWithGemini() async {
    if (selectedImage == null) return;

    setState(() => loading = true);

    try {
      final bytes = await selectedImage!.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$geminiApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{
            'parts': [
              {'text': 'Analyze this plant image. Identify the crop type and any diseases. Provide: 1) Crop name, 2) Disease name (if any) in English and Urdu, 3) Severity (Low/Medium/High), 4) Brief treatment recommendation. Format: Crop: X | Disease: Y (Urdu: Z) | Severity: W | Treatment: T'},
              {'inline_data': {'mime_type': 'image/jpeg', 'data': base64Image}}
            ]
          }]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        setState(() {
          result = text;
          loading = false;
        });
      } else {
        setState(() {
          result = 'Error analyzing image. Status: ${response.statusCode}';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        result = 'Error: ${e.toString()}';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Color(0xFF4ade80)],
          ).createShader(bounds),
          child: const Text('Disease Detection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF141e30), Color(0xFF243b55), Color(0xFF28a745)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                      ),
                      child: selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.file(selectedImage!, fit: BoxFit.cover),
                            )
                          : Center(
                              child: Icon(Icons.image, size: 100, color: Colors.white.withOpacity(0.3)),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => pickImage(ImageSource.camera),
                          borderRadius: BorderRadius.circular(16),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF28a745), Color(0xFF20c997)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF28a745).withOpacity(0.5),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.camera_alt, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text('Camera', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => pickImage(ImageSource.gallery),
                          borderRadius: BorderRadius.circular(16),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF28a745), Color(0xFF20c997)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF28a745).withOpacity(0.5),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.photo_library, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text('Gallery', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (loading)
                  const CircularProgressIndicator(color: Colors.white)
                else if (result.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Text(
                                'Detection Result:',
                                style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.7)),
                              ),
                              const SizedBox(height: 8),
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [Color(0xFF4ade80), Color(0xFF22d3ee)],
                                ).createShader(bounds),
                                child: Text(
                                  result,
                                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// VOICE Q&A SCREEN
class VoiceQAScreen extends StatefulWidget {
  const VoiceQAScreen({Key? key}) : super(key: key);

  @override
  State<VoiceQAScreen> createState() => _VoiceQAScreenState();
}

class _VoiceQAScreenState extends State<VoiceQAScreen> {
  late stt.SpeechToText speech;
  late FlutterTts tts;
  bool isListening = false;
  String spokenText = '';
  String response = '';
  bool loading = false;

  // OpenAI API - Get from environment variable
  final String openAiKey = const String.fromEnvironment('OPENAI_API_KEY', defaultValue: '');
  
  List<Map<String, String>> _conversationHistory = [];

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
    tts = FlutterTts();
    initSpeech();
    
    // Initialize conversation with system prompt (same as website)
    _conversationHistory.add({
      'role': 'system',
      'content': '''You are an expert agricultural AI assistant for Pakistani farmers. You provide practical, actionable advice about:
- Crop cultivation (Cotton, Rice, Wheat, Sugarcane, Maize)
- Pest and disease management
- Fertilizer recommendations
- Irrigation practices
- Market trends
- Weather-based farming decisions

Respond in a mix of English and Urdu as appropriate. Be concise but thorough. Include practical tips that farmers can immediately apply.'''
    });
  }

  Future<void> initSpeech() async {
    await Permission.microphone.request();
    await speech.initialize();
    await tts.setLanguage('ur-PK');
  }

  Future<void> startListening() async {
    if (!isListening) {
      bool available = await speech.initialize();
      if (available) {
        setState(() => isListening = true);
        speech.listen(
          onResult: (result) {
            setState(() {
              spokenText = result.recognizedWords;
              if (result.finalResult) {
                isListening = false;
                getAIResponse();
              }
            });
          },
          localeId: 'ur_PK',
        );
      }
    } else {
      setState(() => isListening = false);
      speech.stop();
    }
  }

  Future<void> getAIResponse() async {
    if (spokenText.isEmpty) return;
    setState(() => loading = true);

    try {
      // Add user question to conversation history
      _conversationHistory.add({
        'role': 'user',
        'content': spokenText,
      });

      // Call OpenAI API (same as website)
      final request = http.Request(
        'POST',
        Uri.parse('https://api.openai.com/v1/chat/completions'),
      );

      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $openAiKey',
      });

      request.body = jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': _conversationHistory,
        'temperature': 0.7,
        'max_tokens': 500,
        'stream': false, // Non-streaming for simpler mobile implementation
      });

      final streamResponse = await request.send();
      
      if (streamResponse.statusCode == 200) {
        final responseBody = await streamResponse.stream.bytesToString();
        final jsonResponse = jsonDecode(responseBody);
        final fullResponse = jsonResponse['choices'][0]['message']['content'];

        // Add complete response to conversation history
        _conversationHistory.add({
          'role': 'assistant',
          'content': fullResponse,
        });

        // Keep only last 20 messages to avoid token limits (same as website)
        if (_conversationHistory.length > 20) {
          // Keep system message + last 19 messages
          _conversationHistory = [
            _conversationHistory[0],
            ..._conversationHistory.sublist(_conversationHistory.length - 19)
          ];
        }

        setState(() {
          response = fullResponse;
          loading = false;
        });

        // Speak the complete response in Urdu
        await tts.stop();
        await tts.setLanguage('ur-PK');
        await tts.speak(fullResponse);
      } else {
        setState(() {
          response = 'API Error: ${streamResponse.statusCode}. Please check your internet connection.';
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        response = 'Error: ${e.toString()}';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Color(0xFF4ade80)],
          ).createShader(bounds),
          child: const Text('Voice Q&A', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF141e30), Color(0xFF243b55), Color(0xFF28a745)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.orange.withOpacity(0.5)),
                      ),
                      child: const Text(
                        '⚠️ API Required: Integrate with Google Gemini or OpenAI GPT API',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (spokenText.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: Colors.blue.withOpacity(0.4)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'You asked:',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        spokenText,
                                        style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 16),
                        if (loading)
                          const CircularProgressIndicator(color: Colors.white)
                        else if (response.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'AI Response:',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        response,
                                        style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: startListening,
                    borderRadius: BorderRadius.circular(50),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isListening
                              ? [Colors.red, Colors.red.shade700]
                              : [const Color(0xFF28a745), const Color(0xFF20c997)],
                        ),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: (isListening ? Colors.red : const Color(0xFF28a745)).withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(isListening ? Icons.mic : Icons.mic_none, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              isListening ? 'Stop' : 'Speak in Urdu',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
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

// MARKETPLACE SCREEN
class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Color(0xFF4ade80)],
          ).createShader(bounds),
          child: const Text('Digital Marketplace', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF141e30), Color(0xFF243b55), Color(0xFF28a745)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4ade80), Color(0xFF22d3ee)],
                              ),
                            ),
                            child: const Icon(Icons.store, size: 60, color: Colors.white),
                          ),
                          const SizedBox(height: 16),
                          ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [Colors.white, Color(0xFF4ade80)],
                            ).createShader(bounds),
                            child: const Text(
                              'Digital Marketplace',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'This feature requires:\n\n• Custom backend with Node.js/Firebase\n• Database (Firestore/MongoDB)\n• User profiles (buyers & sellers)\n• Product listings with images\n• Chat/messaging system\n• Payment gateway integration',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white.withOpacity(0.9)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// OFFLINE FEATURES SCREEN
class OfflineFeaturesScreen extends StatelessWidget {
  const OfflineFeaturesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Color(0xFF4ade80)],
          ).createShader(bounds),
          child: const Text('Offline Features', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF141e30), Color(0xFF243b55), Color(0xFF28a745)],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4ade80), Color(0xFF22d3ee)],
                          ),
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white),
                      ),
                      title: const Text('Disease Detection', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        'Works without internet using on-device AI model',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      trailing: const Icon(Icons.check_circle, color: Color(0xFF4ade80)),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DiseaseDetectionScreen()),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4ade80), Color(0xFF22d3ee)],
                          ),
                        ),
                        child: const Icon(Icons.book, color: Colors.white),
                      ),
                      title: const Text('Cached Farming Tips', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        'Pre-loaded advice available offline (requires Hive implementation)',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      trailing: Icon(Icons.info_outline, color: Colors.white.withOpacity(0.7)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4ade80), Color(0xFF22d3ee)],
                          ),
                        ),
                        child: const Icon(Icons.storage, color: Colors.white),
                      ),
                      title: const Text('Saved Data', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                        'Previously viewed mandi rates and weather data',
                        style: TextStyle(color: Colors.white.withOpacity(0.7)),
                      ),
                      trailing: Icon(Icons.info_outline, color: Colors.white.withOpacity(0.7)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
