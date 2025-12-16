import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  static const routeName = '/account';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _ProfileHeader(user: user),
          const SizedBox(height: 16),
          const _SettingsSection(),
          const SizedBox(height: 16),
          const _SecuritySection(),
          const SizedBox(height: 16),
          const _LinkedServicesSection(),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) Navigator.pop(context);
            },
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final User? user;
  const _ProfileHeader({required this.user});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(radius: 28, child: Icon(Icons.person)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user?.displayName ?? 'Guest',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text(user?.phoneNumber ?? 'Not linked',
                      style: const TextStyle(color: Colors.grey)),
                  Text(user?.email ?? 'Email not linked',
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: const [
          ListTile(leading: Icon(Icons.language), title: Text('Language'), subtitle: Text('English')), 
          Divider(height: 1),
          ListTile(leading: Icon(Icons.color_lens), title: Text('Theme'), subtitle: Text('System Default')),
          Divider(height: 1),
          ListTile(leading: Icon(Icons.notifications), title: Text('Notifications'), subtitle: Text('All enabled')),
        ],
      ),
    );
  }
}

class _SecuritySection extends StatelessWidget {
  const _SecuritySection();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: const [
          ListTile(leading: Icon(Icons.lock), title: Text('Two-Factor Auth')), 
          Divider(height: 1),
          ListTile(leading: Icon(Icons.key), title: Text('Change Password')),
          Divider(height: 1),
          ListTile(leading: Icon(Icons.history), title: Text('Login Activity')),
        ],
      ),
    );
  }
}

class _LinkedServicesSection extends StatelessWidget {
  const _LinkedServicesSection();
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: const [
          ListTile(leading: Icon(Icons.alternate_email), title: Text('Link Email')), 
          Divider(height: 1),
          ListTile(leading: Icon(Icons.phone_android), title: Text('Link Phone')),
          Divider(height: 1),
          ListTile(leading: Icon(Icons.account_balance_wallet), title: Text('Wallet & Payments')),
        ],
      ),
    );
  }
}
