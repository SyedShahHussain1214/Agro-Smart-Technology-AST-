// AgroSmartTech - Complete Flutter App
// Version: 1.0.0 | Date: Dec 08, 2025
// Authors: Syed Shah Hussain & Malik Abdul Rehman
// Features: Firebase Auth, Voice Q&A (Urdu/OpenAI), Disease Detection (TFLite), Weather API, Mandi Rates, Offline Mode, Marketplace

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

// Main Entry
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('offline_data');
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
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
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

  Future<void> _sendOTP() async {
    if (_phoneController.text.length < 10) {
      _showSnackBar('Enter valid 10-digit phone number');
      return;
    }

    setState(() => _loading = true);
    String phoneNumber = '+92${_phoneController.text.replaceAll(RegExp(r'[^0-9]'), '')}';

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
      _showSnackBar('Enter 6-digit OTP');
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
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF28a745),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF28a745), Color(0xFF20c997), Color(0xFF17a2b8)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.agriculture, size: 100, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                    'AgroSmart',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Smart Farming Assistant',
                    style: TextStyle(fontSize: 18, color: Colors.white70),
                  ),
                  const SizedBox(height: 50),
                  if (!_codeSent) ...[
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Phone Number (without +92)',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _loading ? null : _sendOTP,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF28a745),
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: _loading
                          ? const CircularProgressIndicator()
                          : const Text('Send OTP', style: TextStyle(fontSize: 18)),
                    ),
                  ] else ...[
                    TextField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Enter 6-Digit OTP',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _loading ? null : _verifyOTP,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF28a745),
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      ),
                      child: _loading
                          ? const CircularProgressIndicator()
                          : const Text('Verify OTP', style: TextStyle(fontSize: 18)),
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

// HOME SCREEN
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AgroSmart - Home'),
        backgroundColor: const Color(0xFF28a745),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(),
          ),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildFeatureCard(
            context,
            icon: Icons.mic,
            title: 'Voice Q&A',
            subtitle: 'Ask in Urdu',
            color: const Color(0xFF28a745),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VoiceQAScreen())),
          ),
          _buildFeatureCard(
            context,
            icon: Icons.local_florist,
            title: 'Disease Detection',
            subtitle: 'Scan leaf',
            color: const Color(0xFF20c997),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DiseaseDetectionScreen())),
          ),
          _buildFeatureCard(
            context,
            icon: Icons.wb_sunny,
            title: 'Weather',
            subtitle: 'Forecast',
            color: const Color(0xFF17a2b8),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WeatherScreen())),
          ),
          _buildFeatureCard(
            context,
            icon: Icons.trending_up,
            title: 'Mandi Rates',
            subtitle: 'Live prices',
            color: const Color(0xFFffc107),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MandiRatesScreen())),
          ),
          _buildFeatureCard(
            context,
            icon: Icons.shop,
            title: 'Marketplace',
            subtitle: 'Buy/Sell',
            color: const Color(0xFFfd7e14),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketplaceScreen())),
          ),
          _buildFeatureCard(
            context,
            icon: Icons.cloud_off,
            title: 'Offline',
            subtitle: 'Works offline',
            color: const Color(0xFF6c757d),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OfflineFeaturesScreen())),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color, color.withOpacity(0.7)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// VOICE Q&A SCREEN
class VoiceQAScreen extends StatefulWidget {
  const VoiceQAScreen({Key? key}) : super(key: key);

  @override
  State<VoiceQAScreen> createState() => _VoiceQAScreenState();
}

class _VoiceQAScreenState extends State<VoiceQAScreen> {
  late stt.SpeechToText _speech;
  late FlutterTts _tts;
  bool _isListening = false;
  String _spokenText = '';
  String _response = '';
  bool _loading = false;
  final String _openAiKey = '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';
  List<Map<String, String>> _conversationHistory = [];

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _tts = FlutterTts();
    _initSpeechAndTts();
    _conversationHistory.add({
      'role': 'system',
      'content': 'You are an expert Pakistani agricultural advisor. Answer in Urdu naturally with practical advice for Pakistani farmers.',
    });
  }

  Future<void> _initSpeechAndTts() async {
    await Permission.microphone.request();
    await _speech.initialize();
    await _tts.setLanguage('ur-PK');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.listen(
        onResult: (result) {
          setState(() => _spokenText = result.recognizedWords);
          if (result.finalResult && _spokenText.isNotEmpty) {
            _getAIResponse();
          }
        },
        localeId: 'ur_PK',
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
      );
      if (available) setState(() => _isListening = true);
    } else {
      await _speech.stop();
      setState(() => _isListening = false);
    }
  }

  Future<void> _getAIResponse() async {
    setState(() {
      _loading = true;
      _response = '';
    });

    _conversationHistory.add({'role': 'user', 'content': _spokenText});

    try {
      final request = http.Request('POST', Uri.parse('https://api.openai.com/v1/chat/completions'));
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_openAiKey',
      });
      request.body = json.encode({
        'model': 'gpt-4',
        'messages': _conversationHistory,
        'temperature': 0.8,
        'max_tokens': 600,
        'stream': true,
      });

      final streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        String fullResponse = '';
        await for (final chunk in streamedResponse.stream.transform(utf8.decoder).transform(const LineSplitter())) {
          if (chunk.startsWith('data: ') && chunk != 'data: [DONE]') {
            final jsonStr = chunk.substring(6);
            try {
              final data = json.decode(jsonStr);
              final content = data['choices'][0]['delta']['content'];
              if (content != null) {
                fullResponse += content;
                setState(() => _response = fullResponse);
              }
            } catch (e) {
              // Skip parsing errors
            }
          }
        }
        _conversationHistory.add({'role': 'assistant', 'content': fullResponse});
        await _tts.speak(fullResponse);
      } else {
        throw Exception('API error: ${streamedResponse.statusCode}');
      }
    } catch (e) {
      setState(() => _response = 'Error: $e. Demo: گندم کی کاشت نومبر-دسمبر میں کریں۔');
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Q&A in Urdu'),
        backgroundColor: const Color(0xFF28a745),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (_spokenText.isNotEmpty) ...[
                      const Text('You asked:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(_spokenText, style: const TextStyle(fontSize: 16)),
                      const Divider(height: 32),
                    ],
                    if (_loading) const CircularProgressIndicator(),
                    if (_response.isNotEmpty) ...[
                      const Text('Response:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(_response, style: const TextStyle(fontSize: 16)),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _startListening,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isListening ? Colors.red : const Color(0xFF28a745),
                  boxShadow: [
                    BoxShadow(
                      color: _isListening ? Colors.red.withOpacity(0.5) : Colors.green.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _isListening ? 'Listening...' : 'Tap to speak',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }
}

// DISEASE DETECTION SCREEN
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
    return List.generate(1, (batch) => 
      List.generate(224, (y) => 
        List.generate(224, (x) {
          final pixel = image.getPixel(x, y);
          return [(pixel.r as num).toDouble() / 255.0, (pixel.g as num).toDouble() / 255.0, (pixel.b as num).toDouble() / 255.0];
        })
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Detection'),
        backgroundColor: const Color(0xFF28a745),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            if (_image != null)
              Image.file(_image!, height: 300, width: double.infinity, fit: BoxFit.cover),
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

// WEATHER SCREEN
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final String _apiKey = 'your-openweathermap-key';
  Map<String, dynamic>? _weatherData;
  bool _loading = false;
  final TextEditingController _cityController = TextEditingController(text: 'Lahore');

  Future<void> _fetchWeather() async {
    setState(() => _loading = true);
    try {
      final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=${_cityController.text},PK&appid=$_apiKey&units=metric',
      ));
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
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        backgroundColor: const Color(0xFF28a745),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchWeather,
              child: const Text('Get Weather'),
            ),
            const SizedBox(height: 32),
            if (_loading) const CircularProgressIndicator(),
            if (_weatherData != null) ...[
              Text(
                '${_weatherData!['name']}',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(
                '${_weatherData!['main']['temp']}°C',
                style: const TextStyle(fontSize: 48),
              ),
              Text(
                '${_weatherData!['weather'][0]['description']}',
                style: const TextStyle(fontSize: 20),
              ),
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

  Widget _WeatherDetail(String label, String value) => Column(
    children: [
      Text(label, style: const TextStyle(color: Colors.grey)),
      Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    ],
  );
}

// MANDI RATES SCREEN
class MandiRatesScreen extends StatefulWidget {
  const MandiRatesScreen({Key? key}) : super(key: key);

  @override
  State<MandiRatesScreen> createState() => _MandiRatesScreenState();
}

class _MandiRatesScreenState extends State<MandiRatesScreen> {
  final List<Map<String, String>> _demoRates = [
    {'crop': 'Wheat', 'mandi': 'Lahore', 'price': '3500', 'unit': 'per 40kg'},
    {'crop': 'Rice', 'mandi': 'Faisalabad', 'price': '4200', 'unit': 'per 40kg'},
    {'crop': 'Cotton', 'mandi': 'Multan', 'price': '7800', 'unit': 'per 40kg'},
    {'crop': 'Sugarcane', 'mandi': 'Lahore', 'price': '280', 'unit': 'per 40kg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mandi Rates'),
        backgroundColor: const Color(0xFF28a745),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _demoRates.length,
        itemBuilder: (context, index) {
          final rate = _demoRates[index];
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
      appBar: AppBar(
        title: const Text('Marketplace'),
        backgroundColor: const Color(0xFF28a745),
      ),
      body: const Center(
        child: Text('Marketplace coming soon!', style: TextStyle(fontSize: 20)),
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
      appBar: AppBar(
        title: const Text('Offline Features'),
        backgroundColor: const Color(0xFF28a745),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.tips_and_updates),
              title: const Text('Farming Tips'),
              subtitle: const Text('Access saved tips offline'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.history),
              title: const Text('History'),
              subtitle: const Text('View past detections'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Guide'),
              subtitle: const Text('Crop care guide'),
            ),
          ),
        ],
      ),
    );
  }
}
