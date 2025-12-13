import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'about_screen.dart';
import 'contact_screen.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const ProfileScreen({Key? key, required this.toggleTheme, required this.isDarkMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
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
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  SizedBox(height: 16),
                  Text(
                    user?.phoneNumber ?? 'User',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Farmer',
                      style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 24),
          
          Text(
            'Account',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[600]),
          ),
          SizedBox(height: 12),
          
          _buildListTile(
            context,
            Icons.info_outline,
            'About Us',
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen())),
          ),
          
          _buildListTile(
            context,
            Icons.contact_mail,
            'Contact Support',
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => ContactScreen())),
          ),
          
          SizedBox(height: 24),
          
          Text(
            'Preferences',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[600]),
          ),
          SizedBox(height: 12),
          
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Theme.of(context).colorScheme.primary),
              ),
              title: Text('Dark Mode'),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) => toggleTheme(),
              ),
            ),
          ),
          
          SizedBox(height: 12),
          
          _buildListTile(
            context,
            Icons.notifications_outlined,
            'Notifications',
            () {},
          ),
          
          _buildListTile(
            context,
            Icons.language,
            'Language',
            () {},
          ),
          
          _buildListTile(
            context,
            Icons.help_outline,
            'Help & Support',
            () {},
          ),
          
          SizedBox(height: 24),
          
          ElevatedButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
            label: Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
            ),
          ),
          
          SizedBox(height: 16),
          
          Center(
            child: Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }
}
