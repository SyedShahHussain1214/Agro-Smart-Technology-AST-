import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

const String GEMINI_API_KEY = 'AIzaSyD97jvMjFON3nDE3E0JcZzC8Wgkqg0HGKA';

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({Key? key}) : super(key: key);

  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String _result = '';
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source, imageQuality: 85);
    if (image != null) {
      setState(() {
        _image = File(image.path);
        _result = '';
      });
      await _analyzeImage();
    }
  }

  Future<void> _analyzeImage() async {
    if (_image == null) return;

    setState(() => _isLoading = true);

    try {
      final bytes = await _image!.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=$GEMINI_API_KEY'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{
            'parts': [
              {'text': 'Analyze this plant image and identify any diseases. Provide: 1) Disease name 2) Severity (Low/Medium/High) 3) Treatment recommendations for Pakistani farmers. Be specific and practical.'},
              {'inline_data': {'mime_type': 'image/jpeg', 'data': base64Image}}
            ]
          }]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = data['candidates'][0]['content']['parts'][0]['text'];
        setState(() {
          _result = result;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to analyze image');
      }
    } catch (e) {
      setState(() {
        _result = 'Error analyzing image. Please try again.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disease Detection'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            if (_image == null)
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[400]!, width: 2),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, size: 80, color: Colors.grey[400]),
                    SizedBox(height: 16),
                    Text(
                      'Take or upload a photo',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'of your crop or plant',
                      style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                    ),
                  ],
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  _image!,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            
            SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: Icon(Icons.camera_alt),
                    label: Text('Camera'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: Icon(Icons.photo_library),
                    label: Text('Gallery'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 24),
            
            if (_isLoading)
              Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Analyzing image...', style: TextStyle(color: Colors.grey[600])),
                ],
              )
            else if (_result.isNotEmpty)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.analytics, color: Theme.of(context).colorScheme.primary),
                          SizedBox(width: 8),
                          Text(
                            'Analysis Result',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Divider(height: 24),
                      Text(_result, style: TextStyle(fontSize: 14, height: 1.5)),
                      SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _image = null;
                              _result = '';
                            });
                          },
                          icon: Icon(Icons.refresh),
                          label: Text('Scan Another'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
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
}
