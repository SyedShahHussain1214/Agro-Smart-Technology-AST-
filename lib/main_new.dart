// Agro Smart Technology - Mobile App
// Exact match to website design with professional mobile UI

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

// API Keys (same as website)
const String OPENAI_API_KEY = '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';
const String GEMINI_API_KEY = 'AIzaSyD97jvMjFON3nDE3E0JcZzC8Wgkqg0HGKA';
const String OPENWEATHER_API_KEY = 'bd0a7106c8a51f1eb7d128794e741c7f';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const AgroSmartApp());
}

class AgroSmartApp extends StatefulWidget {
  const AgroSmartApp({Key? key}) : super(key: key);

  @override
  State<AgroSmartApp> createState() => _AgroSmartAppState();
}

class _AgroSmartAppState extends State<AgroSmartApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agro Smart Technology',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: Color(0xFF2E7D32), // Green
          secondary: Color(0xFF4CAF50),
          surface: Colors.white,
          background: Color(0xFFF5F5F5),
        ),
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Color(0xFF66BB6A),
          secondary: Color(0xFF81C784),
          surface: Color(0xFF1E1E1E),
          background: Color(0xFF121212),
        ),
        fontFamily: 'Roboto',
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) {
            return MainScreen(toggleTheme: toggleTheme, isDarkMode: isDarkMode);
          }
          return const PhoneAuthScreen();
        },
      ),
    );
  }
}

// ============ PHONE AUTHENTICATION SCREEN ============
class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '+92');
  final TextEditingController _otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  String _verificationId = '';
  bool _codeSent = false;
  bool _loading = false;
  String _errorMessage = '';

  Future<void> _verifyPhoneNumber() async {
    setState(() {
      _loading = true;
      _errorMessage = '';
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: _phoneController.text.trim(),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          _loading = false;
          _errorMessage = e.message ?? 'Verification failed';
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _codeSent = true;
          _loading = false;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
      timeout: const Duration(seconds: 60),
    );
  }

  Future<void> _signInWithOTP() async {
    setState(() {
      _loading = true;
      _errorMessage = '';
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _otpController.text.trim(),
      );
      await _auth.signInWithCredential(credential);
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMessage = 'Invalid OTP';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Color(0xFF2E7D32),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.agriculture,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      // Title
                      Text(
                        'Agro Smart Technology',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Smart Farming for Pakistan',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 32),
                      
                      // Phone Input
                      if (!_codeSent) ...[
                        TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            hintText: '+923001234567',
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _verifyPhoneNumber,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2E7D32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _loading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    'Send OTP',
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                          ),
                        ),
                      ],
                      
                      // OTP Input
                      if (_codeSent) ...[
                        Text(
                          'Enter the 6-digit code sent to',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        SizedBox(height: 4),
                        Text(
                          _phoneController.text,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        SizedBox(height: 24),
                        TextField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 6,
                          decoration: InputDecoration(
                            labelText: 'OTP Code',
                            hintText: '123456',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            counterText: '',
                          ),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _signInWithOTP,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2E7D32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _loading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    'Verify & Login',
                                    style: TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _codeSent = false;
                              _otpController.clear();
                            });
                          },
                          child: Text('Change Phone Number'),
                        ),
                      ],
                      
                      // Error Message
                      if (_errorMessage.isNotEmpty) ...[
                        SizedBox(height: 16),
                        Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
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

// ============ MAIN SCREEN WITH BOTTOM NAVIGATION ============
class MainScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const MainScreen({
    Key? key,
    required this.toggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode),
      const FeaturesScreen(),
      const MandiRatesScreen(),
      const MarketplaceScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Features'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Mandi'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Market'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ============ HOME SCREEN (Hero Section) ============
class HomeScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const HomeScreen({
    Key? key,
    required this.toggleTheme,
    required this.isDarkMode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 200,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('AST'),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.agriculture, size: 60, color: Colors.white),
                    SizedBox(height: 8),
                    Text(
                      'Agro Smart Technology',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: toggleTheme,
            ),
          ],
        ),
        
        // Hero Content
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tagline
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          'Smart Farming for Pakistan',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'AI-Powered Agricultural Assistant',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                
                // Quick Stats
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        context,
                        '10K+',
                        'Users',
                        Icons.people,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        '50K+',
                        'Queries',
                        Icons.chat,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        context,
                        '24/7',
                        'Support',
                        Icons.support_agent,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                
                // Featured Section
                Text(
                  'Featured Services',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                
                // Voice QA Card
                _buildFeatureCard(
                  context,
                  'Voice Q&A in Urdu',
                  'Ask farming questions in Urdu/English',
                  Icons.mic,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VoiceQAScreen()),
                    );
                  },
                ),
                SizedBox(height: 12),
                
                // Disease Detection Card
                _buildFeatureCard(
                  context,
                  'AI Disease Detection',
                  'Scan crop diseases instantly',
                  Icons.camera_alt,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DiseaseDetectionScreen()),
                    );
                  },
                ),
                SizedBox(height: 12),
                
                // Weather Card
                _buildFeatureCard(
                  context,
                  'Weather Forecast',
                  'Accurate weather for Pakistani cities',
                  Icons.wb_sunny,
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WeatherScreen()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(BuildContext context, String value, String label, IconData icon) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: Theme.of(context).colorScheme.primary),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Card(
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

// Placeholder screens - will implement next
class FeaturesScreen extends StatelessWidget {
  const FeaturesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('All Features')),
      body: Center(child: Text('Features Screen - Coming Next')),
    );
  }
}

class MandiRatesScreen extends StatelessWidget {
  const MandiRatesScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mandi Rates')),
      body: Center(child: Text('Mandi Rates Screen - Coming Next')),
    );
  }
}

class MarketplaceScreen extends StatelessWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Marketplace')),
      body: Center(child: Text('Marketplace Screen - Coming Next')),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('Profile Screen - Coming Next')),
    );
  }
}

class VoiceQAScreen extends StatelessWidget {
  const VoiceQAScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Voice Q&A')),
      body: Center(child: Text('Voice Q&A Screen - Coming Next')),
    );
  }
}

class DiseaseDetectionScreen extends StatelessWidget {
  const DiseaseDetectionScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Disease Detection')),
      body: Center(child: Text('Disease Detection Screen - Coming Next')),
    );
  }
}

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather Forecast')),
      body: Center(child: Text('Weather Screen - Coming Next')),
    );
  }
}
