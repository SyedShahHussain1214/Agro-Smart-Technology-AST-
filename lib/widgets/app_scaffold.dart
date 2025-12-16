import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme_provider.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final String? titleUrdu;
  final bool showBackButton;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  const AppScaffold({
    Key? key,
    required this.body,
    required this.title,
    this.titleUrdu,
    this.showBackButton = true,
    this.actions,
    this.floatingActionButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
              ),
            ),
            if (titleUrdu != null)
              Text(
                titleUrdu!,
                style: TextStyle(
                  fontFamily: 'Noto Nastaliq Urdu',
                  fontSize: 14,
                  color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                ),
              ),
          ],
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: showBackButton,
        iconTheme: IconThemeData(
          color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
        ),
        actions: [
          ...?actions,
          PopupMenuButton<String>(
            icon: Icon(
              themeProvider.themeMode == ThemeMode.light
                  ? Icons.light_mode
                  : themeProvider.themeMode == ThemeMode.dark
                      ? Icons.dark_mode
                      : Icons.brightness_auto,
              color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
            ),
            onSelected: (value) {
              if (value == 'light') {
                themeProvider.setThemeMode(ThemeMode.light);
              } else if (value == 'dark') {
                themeProvider.setThemeMode(ThemeMode.dark);
              } else {
                themeProvider.setThemeMode(ThemeMode.system);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'light',
                child: Row(
                  children: [
                    Icon(Icons.light_mode),
                    SizedBox(width: 8),
                    Text('Light Mode'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'dark',
                child: Row(
                  children: [
                    Icon(Icons.dark_mode),
                    SizedBox(width: 8),
                    Text('Dark Mode'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'system',
                child: Row(
                  children: [
                    Icon(Icons.brightness_auto),
                    SizedBox(width: 8),
                    Text('System Default'),
                  ],
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
