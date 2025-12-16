import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool mandiAlerts = true;
  bool weatherAlerts = true;
  bool diseaseReminders = false;
  bool marketplaceDeals = true;

  final List<Map<String, String>> _recent = [
    {
      'title': 'Wheat price up 3% in Lahore',
      'time': '5 min ago',
      'type': 'Mandi',
    },
    {
      'title': 'Rain expected tomorrow in Multan',
      'time': '1 hr ago',
      'type': 'Weather',
    },
    {
      'title': 'New fertilizer offer: 10% off',
      'time': 'Yesterday',
      'type': 'Marketplace',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts & Notifications'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('Smart Alerts'),
          _toggleTile(
            icon: Icons.trending_up_rounded,
            color: const Color(0xFFFFA726),
            title: 'Mandi price alerts',
            subtitle: 'Notify when prices change by more than 2%',
            value: mandiAlerts,
            onChanged: (v) => setState(() => mandiAlerts = v),
          ),
          _toggleTile(
            icon: Icons.cloud_done_rounded,
            color: const Color(0xFF42A5F5),
            title: 'Weather warnings',
            subtitle: 'Rain, heatwave, and wind alerts for your city',
            value: weatherAlerts,
            onChanged: (v) => setState(() => weatherAlerts = v),
          ),
          _toggleTile(
            icon: Icons.healing_rounded,
            color: const Color(0xFFEF5350),
            title: 'Disease reminders',
            subtitle: 'Follow-up checks after treatment advice',
            value: diseaseReminders,
            onChanged: (v) => setState(() => diseaseReminders = v),
          ),
          _toggleTile(
            icon: Icons.local_offer_rounded,
            color: const Color(0xFF66BB6A),
            title: 'Marketplace deals',
            subtitle: 'Promotions on seeds, fertilizers, and tools',
            value: marketplaceDeals,
            onChanged: (v) => setState(() => marketplaceDeals = v),
          ),
          const SizedBox(height: 16),
          _sectionTitle('Recent alerts'),
          ..._recent.map((item) => _alertCard(item)).toList(),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  Widget _toggleTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: SwitchListTile.adaptive(
        value: value,
        onChanged: onChanged,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _alertCard(Map<String, String> item) {
    Color tagColor;
    switch (item['type']) {
      case 'Weather':
        tagColor = const Color(0xFF42A5F5);
        break;
      case 'Marketplace':
        tagColor = const Color(0xFF66BB6A);
        break;
      default:
        tagColor = const Color(0xFFFFA726);
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: tagColor.withOpacity(0.15),
          child: Icon(Icons.notifications, color: tagColor),
        ),
        title: Text(item['title'] ?? ''),
        subtitle: Text(item['time'] ?? ''),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: tagColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(item['type'] ?? '', style: TextStyle(color: tagColor, fontSize: 12)),
        ),
      ),
    );
  }
}
