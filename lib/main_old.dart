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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF28a745), Color(0xFF1e7e34)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'AST',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF28a745),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Agro Smart Technology',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'ذہین زرعی مشیر',
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'NotoNastaliq',
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          if (!_codeSent) ...[
                            TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Phone Number',
                                hintText: '3001234567',
                                prefixText: '+92 ',
                                prefixIcon: const Icon(Icons.phone, color: Color(0xFF28a745)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFF28a745), width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _loading ? null : _sendOTP,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF28a745),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: _loading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text('Send OTP', style: TextStyle(fontSize: 16, color: Colors.white)),
                              ),
                            ),
                          ] else ...[
                            TextField(
                              controller: _otpController,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              decoration: InputDecoration(
                                labelText: 'Enter OTP',
                                prefixIcon: const Icon(Icons.lock, color: Color(0xFF28a745)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color(0xFF28a745), width: 2),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _loading ? null : _verifyOTP,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF28a745),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: _loading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text('Verify OTP', style: TextStyle(fontSize: 16, color: Colors.white)),
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
                                style: const TextStyle(color: Color(0xFF28a745)),
                              ),
                            ),
                          ],
                        ],
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'AST - Agro Smart Technology',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF28a745), Color(0xFF1e7e34)],
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.agriculture, size: 80, color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        'Empowering Pakistani Farmers',
                        style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'پاکستانی کسانوں کو بااختیار بنائیں',
                        style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'NotoNastaliq'),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => FirebaseAuth.instance.signOut(),
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
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              child: Image.asset(
                                feature['image'] as String,
                                fit: BoxFit.cover,
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
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    feature['titleUrdu'] as String,
                                    style: const TextStyle(fontSize: 11, fontFamily: 'NotoNastaliq', color: Color(0xFF28a745)),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Spacer(),
                                  Text(
                                    feature['desc'] as String,
                                    style: const TextStyle(fontSize: 10, color: Colors.grey),
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
                  );
                },
                childCount: features.length,
              ),
            ),
          ),
        ],
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

  // OpenWeatherMap API - Get free key from: https://openweathermap.org/api
  // From your old project: OPENWEATHER_KEY in .env file
  final String apiKey = 'YOUR_OPENWEATHERMAP_API_KEY';  // TODO: Add your key from .env file

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
    if (apiKey != 'YOUR_OPENWEATHERMAP_API_KEY') {
      fetchWeather();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Forecast'),
        backgroundColor: const Color(0xFF28a745),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter City',
                hintText: 'Lahore, Faisalabad, Multan',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: fetchWeather,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (value) => city = value,
              onSubmitted: (_) => fetchWeather(),
            ),
            const SizedBox(height: 24),
            if (apiKey == 'YOUR_OPENWEATHERMAP_API_KEY')
              const Card(
                color: Colors.orange,
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '⚠️ API Key Required: Get free key from openweathermap.org/api',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            if (loading)
              const Center(child: CircularProgressIndicator())
            else if (weatherData != null)
              Expanded(
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          weatherData!['name'],
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '${weatherData!['main']['temp'].toStringAsFixed(1)}°C',
                          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF28a745)),
                        ),
                        Text(
                          weatherData!['weather'][0]['description'].toUpperCase(),
                          style: const TextStyle(fontSize: 20),
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
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherDetail(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
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
      appBar: AppBar(
        title: const Text('Mandi Rates'),
        backgroundColor: const Color(0xFF28a745),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: fetchMandiRates),
        ],
      ),
      body: Column(
        children: [
          const Card(
            margin: EdgeInsets.all(16),
            color: Colors.orange,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '⚠️ API Required: Integrate with Pakistan Mandi API or create custom backend with web scraping',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          if (loading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: rates.length,
                itemBuilder: (context, index) {
                  final rate = rates[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: const Color(0xFF28a745),
                        child: Text(rate['crop']![0], style: const TextStyle(color: Colors.white)),
                      ),
                      title: Text(rate['crop']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${rate['mandi']} Mandi'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Rs ${rate['price']}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF28a745)),
                          ),
                          Text('per ${rate['unit']}', style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
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
  Interpreter? interpreter;
  List<String>? labels;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset('assets/models/plant_disease_model.tflite');
      final labelsData = await DefaultAssetBundle.of(context).loadString('assets/models/labels.txt');
      labels = labelsData.split('\n');
    } catch (e) {
      print('Error loading model: $e');
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        result = '';
      });
      await classifyImage();
    }
  }

  Future<void> classifyImage() async {
    if (selectedImage == null || interpreter == null || labels == null) return;

    setState(() => loading = true);

    try {
      final imageBytes = await selectedImage!.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) return;

      img.Image resizedImage = img.copyResize(image, width: 224, height: 224);
      
      var input = List.generate(
        1,
        (i) => List.generate(
          224,
          (j) => List.generate(
            224,
            (k) {
              final pixel = resizedImage.getPixel(k, j);
              return [
                pixel.r / 255.0,
                pixel.g / 255.0,
                pixel.b / 255.0,
              ];
            },
          ),
        ),
      );

      var output = List.filled(1 * labels!.length, 0.0).reshape([1, labels!.length]);
      interpreter!.run(input, output);

      double maxScore = 0;
      int maxIndex = 0;
      for (int i = 0; i < labels!.length; i++) {
        if (output[0][i] > maxScore) {
          maxScore = output[0][i];
          maxIndex = i;
        }
      }

      setState(() {
        result = labels![maxIndex];
        loading = false;
      });
    } catch (e) {
      setState(() {
        result = 'Error: $e';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disease Detection'),
        backgroundColor: const Color(0xFF28a745),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(selectedImage!, height: 300, width: double.infinity, fit: BoxFit.cover),
              )
            else
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(Icons.image, size: 100, color: Colors.grey),
                ),
              ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF28a745),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF28a745),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (loading)
              const CircularProgressIndicator()
            else if (result.isNotEmpty)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text('Detection Result:', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      const SizedBox(height: 8),
                      Text(
                        result,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF28a745)),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    interpreter?.close();
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

  // OpenAI API - Get key from: https://platform.openai.com/api-keys
  // From your old project: OPENAI_KEY=sk-proj-... in .env file
  final String openAiKey = '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';
  
  List<Map<String, String>> _conversationHistory = [];

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
    tts = FlutterTts();
    initSpeech();
    
    // Initialize conversation with system prompt for better responses
    _conversationHistory.add({
      'role': 'system',
      'content': '''تم ایک ماہر پاکستانی زراعی مشیر ہو۔
- ہر جواب طبیعی، گفتگو کی انداز میں ہو
- تفصیل سے جواب دو، صرف سادہ جواب نہ دو
- مختلف پہلوؤں کو بیان کرو: وجہ، حل، فوائد، احتیاطات
- ہر بار نیا اور متنوع جواب دو - کبھی ایک جیسے جواب نہ دو
- پاکستانی کسانوں کے لیے عملی مشورے دو'''
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
      // Check if API key is configured
      if (openAiKey == 'YOUR_OPENAI_API_KEY' || openAiKey.isEmpty) {
        // DEMO FALLBACK - Remove this when you add your API key
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          response = 'گندم کی کاشت کے لیے نومبر سے دسمبر کا وقت بہترین ہے۔ زمین اچھی طرح تیار کریں اور بیج کی مقدار 50 کلو فی ایکڑ رکھیں۔\n\nFor wheat cultivation, November to December is the best time. Prepare the land well and use 50kg seed per acre.';
          loading = false;
        });
        await tts.speak(response);
        return;
      }

      // Add user question to conversation history
      _conversationHistory.add({
        'role': 'user',
        'content': spokenText,
      });

      // Call OpenAI API with streaming
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
        'temperature': 0.8,
        'top_p': 0.95,
        'max_tokens': 600,
        'stream': true,
      });

      final streamResponse = await request.send();

      if (streamResponse.statusCode == 200) {
        String fullResponse = '';
        final completer = Completer<void>();

        // Process stream chunks in real-time
        streamResponse.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen(
          (line) {
            if (line.isEmpty || line == '[DONE]') return;

            if (line.startsWith('data: ')) {
              try {
                final jsonData = jsonDecode(line.substring(6));
                final delta = jsonData["choices"]?[0]?["delta"]?["content"];

                if (delta != null && delta is String) {
                  fullResponse += delta;
                  // Update UI in real-time (streaming effect)
                  setState(() {
                    response = fullResponse;
                  });
                }
              } catch (e) {
                // Ignore JSON parsing errors for incomplete chunks
              }
            }
          },
          onDone: () {
            // Add complete response to conversation history
            _conversationHistory.add({
              'role': 'assistant',
              'content': fullResponse,
            });

            // Speak the complete response
            tts.stop().then((_) => tts.speak(fullResponse));
            
            setState(() => loading = false);
            completer.complete();
          },
          onError: (error) {
            setState(() {
              response = 'Error: ${error.toString()}';
              loading = false;
            });
            completer.completeError(error);
          },
        );

        await completer.future;
      } else {
        setState(() {
          response = 'API Error: ${streamResponse.statusCode}';
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
      appBar: AppBar(
        title: const Text('Voice Q&A'),
        backgroundColor: const Color(0xFF28a745),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Card(
              color: Colors.orange,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '⚠️ API Required: Integrate with Google Gemini API or OpenAI GPT API for AI responses',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (spokenText.isNotEmpty)
                      Card(
                        color: Colors.blue[50],
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('You asked:', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(spokenText, style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    if (loading)
                      const CircularProgressIndicator()
                    else if (response.isNotEmpty)
                      Card(
                        color: Colors.green[50],
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('AI Response:', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(response, style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            FloatingActionButton.extended(
              onPressed: startListening,
              backgroundColor: isListening ? Colors.red : const Color(0xFF28a745),
              icon: Icon(isListening ? Icons.mic : Icons.mic_none),
              label: Text(isListening ? 'Stop' : 'Speak in Urdu'),
            ),
          ],
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
      appBar: AppBar(
        title: const Text('Digital Marketplace'),
        backgroundColor: const Color(0xFF28a745),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.store, size: 80, color: Color(0xFF28a745)),
                  SizedBox(height: 16),
                  Text(
                    'Digital Marketplace',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'This feature requires:\n\n• Custom backend with Node.js/Firebase\n• Database (Firestore/MongoDB)\n• User profiles (buyers & sellers)\n• Product listings with images\n• Chat/messaging system\n• Payment gateway integration',
                    textAlign: TextAlign.center,
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
              leading: const Icon(Icons.camera_alt, color: Color(0xFF28a745)),
              title: const Text('Disease Detection'),
              subtitle: const Text('Works without internet using on-device AI model'),
              trailing: const Icon(Icons.check_circle, color: Colors.green),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DiseaseDetectionScreen()),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              leading: Icon(Icons.book, color: Color(0xFF28a745)),
              title: Text('Cached Farming Tips'),
              subtitle: Text('Pre-loaded advice available offline (requires Hive implementation)'),
              trailing: Icon(Icons.info_outline),
            ),
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              leading: Icon(Icons.storage, color: Color(0xFF28a745)),
              title: Text('Saved Data'),
              subtitle: Text('Previously viewed mandi rates and weather data'),
              trailing: Icon(Icons.info_outline),
            ),
          ),
        ],
      ),
    );
  }
}
