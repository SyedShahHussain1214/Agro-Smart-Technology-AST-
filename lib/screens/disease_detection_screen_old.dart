import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import '../services/gemini_service.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  final GeminiService _geminiService = GeminiService();
  final ImagePicker _imagePicker = ImagePicker();
  
  File? _selectedImage;
  bool _isAnalyzing = false;
  String? _analysisResult;
  String _selectedLanguage = 'ur';
  bool _showConfidence = false;

  final Map<String, String> _diseaseUrdu = {
    'Leaf Spot': 'پتی کا دھبہ',
    'Powdery Mildew': 'سفید داغ',
    'Blight': 'لگن',
    'Rust': 'زنگ',
    'Wilt': 'سڑن',
    'Yellow Mosaic': 'پیلا داغ',
    'Anthracnose': 'کوयلہ',
  };

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _analysisResult = null;
          _showConfidence = false;
        });
      }
    } catch (e) {
      _showError('تصویر نہیں لی جا سکی');
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) {
      _showError('براہ کرم تصویر منتخب کریں');
      return;
    }

    setState(() => _isAnalyzing = true);

    try {
      final imageBytes = await _selectedImage!.readAsBytes();
      final result = await _geminiService.analyzeImage(
        imageBytes,
        'image/jpeg',
      );

      setState(() {
        _analysisResult = result['analysis'];
        _isAnalyzing = false;
        _showConfidence = true;
      });
    } catch (e) {
      setState(() => _isAnalyzing = false);
      _showError('تصویر کا تجزیہ نہیں ہو سکا');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                _selectedLanguage == 'ur'
                    ? 'تصویر کا ذریعہ منتخب کریں'
                    : 'Select Image Source',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF28a745)),
              title: Text(_selectedLanguage == 'ur' ? 'کیمرہ' : 'Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF28a745)),
              title: Text(_selectedLanguage == 'ur' ? 'گیلری' : 'Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedLanguage == 'ur'
            ? 'بیماری کی شناخت'
            : 'Disease Detection'),
        backgroundColor: const Color(0xFF28a745),
        actions: [
          IconButton(
            icon: Text(
              _selectedLanguage == 'ur' ? 'EN' : 'اردو',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            onPressed: () {
              setState(() {
                _selectedLanguage = _selectedLanguage == 'ur' ? 'en' : 'ur';
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instructions
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF28a745).withOpacity(0.1),
                        const Color(0xFF20c997).withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.info,
                            color: Color(0xFF28a745),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _selectedLanguage == 'ur'
                                ? 'کیسے استعمال کریں'
                                : 'How to Use',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _instructionPoint(
                        1,
                        _selectedLanguage == 'ur'
                            ? 'اپنی فصل کی متاثرہ پتی کی تصویر لیں'
                            : 'Take a clear photo of affected leaf',
                      ),
                      _instructionPoint(
                        2,
                        _selectedLanguage == 'ur'
                            ? 'AI تجزیہ کے لیے تصویر بھیجیں'
                            : 'Send for AI analysis',
                      ),
                      _instructionPoint(
                        3,
                        _selectedLanguage == 'ur'
                            ? 'بیماری اور علاج کی معلومات حاصل کریں'
                            : 'Get disease & treatment info',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Image Preview/Placeholder
              Center(
                child: GestureDetector(
                  onTap: _showImageSourceBottomSheet,
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF28a745),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[50],
                    ),
                    child: _selectedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _selectedLanguage == 'ur'
                                    ? 'تصویر شامل کریں'
                                    : 'Add Image',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _selectedLanguage == 'ur'
                                    ? 'کیمرہ یا گیلری سے'
                                    : 'From camera or gallery',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 300,
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedImage = null;
                                      _analysisResult = null;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Analyze Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isAnalyzing ? null : _analyzeImage,
                  icon: _isAnalyzing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.analytics),
                  label: Text(
                    _isAnalyzing
                        ? (_selectedLanguage == 'ur'
                            ? 'تجزیہ جاری ہے...'
                            : 'Analyzing...')
                        : (_selectedLanguage == 'ur'
                            ? 'AI سے تجزیہ کریں'
                            : 'Analyze with AI'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF28a745),
                    disabledBackgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Analysis Result
              if (_analysisResult != null) ...[
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue[50]!,
                          Colors.green[50]!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.search_rounded,
                              color: Color(0xFF28a745),
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _selectedLanguage == 'ur'
                                  ? 'تجزیہ کے نتائج'
                                  : 'Analysis Results',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _analysisResult ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.8,
                            color: Colors.grey[800],
                          ),
                        ),
                        if (_showConfidence) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.verified,
                                  color: Color(0xFF28a745),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _selectedLanguage == 'ur'
                                        ? 'یہ تجزیہ Gemini Vision AI کے ذریعے کیا گیا ہے۔'
                                        : 'This analysis is powered by Gemini Vision AI.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green[900],
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
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _selectedImage = null;
                        _analysisResult = null;
                        _showConfidence = false;
                      });
                    },
                    icon: const Icon(Icons.add_photo_alternate),
                    label: Text(_selectedLanguage == 'ur'
                        ? 'دوسری تصویر'
                        : 'Another Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF28a745),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _instructionPoint(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF28a745),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
