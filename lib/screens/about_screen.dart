import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.agriculture, size: 50, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Agro Smart Technology',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Smart Farming for Pakistan',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 24),
          
          _buildSection(
            context,
            'Our Mission',
            'To empower Pakistani farmers with AI-powered tools and real-time information for better crop management, increased productivity, and sustainable farming practices.',
          ),
          
          SizedBox(height: 16),
          
          _buildSection(
            context,
            'Our Vision',
            'To revolutionize agriculture in Pakistan through technology, making farming more efficient, profitable, and sustainable for every farmer.',
          ),
          
          SizedBox(height: 24),
          
          Text(
            'Key Features',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          
          _buildFeatureItem(context, 'Voice Q&A in Urdu & English'),
          _buildFeatureItem(context, 'AI-Powered Disease Detection'),
          _buildFeatureItem(context, 'Real-Time Mandi Rates'),
          _buildFeatureItem(context, 'Digital Marketplace'),
          _buildFeatureItem(context, 'Accurate Weather Forecasts'),
          _buildFeatureItem(context, 'Offline Access'),
          
          SizedBox(height: 24),
          
          _buildSection(
            context,
            'Why Choose AST?',
            '• Expert AI guidance for farming decisions\n• Real-time market and weather information\n• Easy-to-use interface in Urdu\n• Offline capabilities\n• Trusted by 10,000+ farmers\n• Available 24/7',
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
            ),
            SizedBox(height: 12),
            Text(
              content,
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }
}
