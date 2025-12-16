import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  static const routeName = '/settings';
  
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _locationServices = true;
  String _language = 'English';
  String _region = 'Punjab';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF141E30).withOpacity(0.95),
                    const Color(0xFF243B55).withOpacity(0.90),
                  ]
                : [
                    const Color(0xFFf8f9fa),
                    const Color(0xFFe9ecef),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Settings',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                          ),
                        ),
                        Text(
                          'ترتیبات',
                          style: GoogleFonts.notoNastaliqUrdu(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Settings List
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Account Section
                    _buildSectionHeader('Account', 'اکاؤنٹ', isDark),
                    _buildSettingsCard(
                      context,
                      icon: Icons.person,
                      title: 'Profile',
                      subtitle: 'Edit your profile information',
                      isDark: isDark,
                      onTap: () {},
                    ),
                    _buildSettingsCard(
                      context,
                      icon: Icons.info_outline,
                      title: 'About Us',
                      subtitle: 'Learn more about Agro Smart',
                      isDark: isDark,
                      onTap: () {
                        Navigator.pushNamed(context, '/about');
                      },
                    ),

                    const SizedBox(height: 24),

                    // Preferences Section
                    _buildSectionHeader('Preferences', 'ترجیحات', isDark),
                    _buildSettingsCard(
                      context,
                      icon: Icons.notifications,
                      title: 'Notifications',
                      subtitle: 'Manage notification settings',
                      isDark: isDark,
                      trailing: Switch(
                        value: _notifications,
                        onChanged: (value) {
                          setState(() => _notifications = value);
                        },
                        activeColor: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                      ),
                    ),
                    _buildSettingsCard(
                      context,
                      icon: Icons.location_on,
                      title: 'Location Services',
                      subtitle: 'Enable for weather updates',
                      isDark: isDark,
                      trailing: Switch(
                        value: _locationServices,
                        onChanged: (value) {
                          setState(() => _locationServices = value);
                        },
                        activeColor: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                      ),
                    ),
                    _buildSettingsCard(
                      context,
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: _language,
                      isDark: isDark,
                      onTap: () {
                        _showLanguageDialog(context, isDark);
                      },
                    ),
                    _buildSettingsCard(
                      context,
                      icon: Icons.map,
                      title: 'Region',
                      subtitle: _region,
                      isDark: isDark,
                      onTap: () {
                        _showRegionDialog(context, isDark);
                      },
                    ),

                    const SizedBox(height: 24),

                    // Support Section
                    _buildSectionHeader('Support', 'معاونت', isDark),
                    _buildSettingsCard(
                      context,
                      icon: Icons.help_outline,
                      title: 'Help & FAQ',
                      subtitle: 'Get answers to common questions',
                      isDark: isDark,
                      onTap: () {},
                    ),
                    _buildSettingsCard(
                      context,
                      icon: Icons.contact_support,
                      title: 'Contact Us',
                      subtitle: 'Reach out for support',
                      isDark: isDark,
                      onTap: () {},
                    ),
                    _buildSettingsCard(
                      context,
                      icon: Icons.privacy_tip,
                      title: 'Privacy Policy',
                      subtitle: 'Read our privacy policy',
                      isDark: isDark,
                      onTap: () {},
                    ),

                    const SizedBox(height: 32),

                    // Version
                    Center(
                      child: Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          color: isDark ? Colors.white54 : Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String titleUrdu, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 12, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
            ),
          ),
          Text(
            titleUrdu,
            style: GoogleFonts.notoNastaliqUrdu(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFF4ade80).withOpacity(0.8) : const Color(0xFF28a745).withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isDark,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1a1f35).withOpacity(0.6) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        trailing: trailing ?? Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: isDark ? Colors.white54 : Colors.black54,
        ),
        onTap: onTap,
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1a1f35) : Colors.white,
        title: Text(
          'Select Language',
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('English', isDark),
            _buildLanguageOption('اردو', isDark),
            _buildLanguageOption('پنجابی', isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language, bool isDark) {
    return RadioListTile<String>(
      value: language,
      groupValue: _language,
      onChanged: (value) {
        setState(() => _language = value!);
        Navigator.pop(context);
      },
      title: Text(
        language,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      ),
      activeColor: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
    );
  }

  void _showRegionDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1a1f35) : Colors.white,
        title: Text(
          'Select Region',
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildRegionOption('Punjab', isDark),
            _buildRegionOption('Sindh', isDark),
            _buildRegionOption('KPK', isDark),
            _buildRegionOption('Balochistan', isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildRegionOption(String region, bool isDark) {
    return RadioListTile<String>(
      value: region,
      groupValue: _region,
      onChanged: (value) {
        setState(() => _region = value!);
        Navigator.pop(context);
      },
      title: Text(
        region,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      ),
      activeColor: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
    );
  }
}
