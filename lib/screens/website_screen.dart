import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class WebsiteScreen extends StatefulWidget {
  const WebsiteScreen({super.key});

  @override
  State<WebsiteScreen> createState() => _WebsiteScreenState();
}

class _WebsiteScreenState extends State<WebsiteScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String _pageTitle = 'Agro Smart Technology';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    // Get the absolute path to the website HTML file
    final String htmlPath = Platform.isAndroid
        ? 'file:///android_asset/flutter_assets/assets/website/index.html'
        : 'assets/website/index.html';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar
            if (progress == 100) {
              setState(() => _isLoading = false);
            }
          },
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
            // Get page title
            _controller.getTitle().then((title) {
              if (title != null && title.isNotEmpty) {
                setState(() => _pageTitle = title);
              }
            });
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('WebView error: ${error.description}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('ویب سائٹ لوڈ کرنے میں مسئلہ: ${error.description}')),
            );
          },
        ),
      )
      ..loadFlutterAsset('assets/website/index.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF28a745),
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _pageTitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'ذہین زرعی مشیر',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontFamily: 'NotoNastaliq',
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => _controller.reload(),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'home') {
                _controller.loadFlutterAsset('assets/website/index.html');
              } else if (value == 'forward') {
                _controller.goForward();
              } else if (value == 'back') {
                _controller.goBack();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'home', child: Text('🏠 Home')),
              const PopupMenuItem(value: 'back', child: Text('⬅️ Back')),
              const PopupMenuItem(value: 'forward', child: Text('➡️ Forward')),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Container(
              color: Colors.white,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Color(0xFF28a745),
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'ویب سائٹ لوڈ ہو رہی ہے...',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'NotoNastaliq',
                        color: Colors.black54,
                      ),
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
