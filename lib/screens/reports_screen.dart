import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final List<String> _crops = ['Wheat', 'Rice', 'Cotton', 'Maize', 'Sugarcane'];
  String _selectedCrop = 'Wheat';
  String _selectedRange = 'Last 7 days';

  final List<Map<String, String>> _insights = [
    {'title': 'Yield Potential', 'value': 'Good', 'detail': 'Moisture and temperature are optimal.'},
    {'title': 'Disease Risk', 'value': 'Moderate', 'detail': 'Monitor for fungal symptoms after rain.'},
    {'title': 'Market Trend', 'value': 'Up', 'detail': 'Prices increased 3% this week.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Reports'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(child: _dropdown('Crop', _selectedCrop, _crops, (v) => setState(() => _selectedCrop = v))),
              const SizedBox(width: 10),
              Expanded(child: _dropdown('Range', _selectedRange, const ['Last 7 days', 'Last 30 days', 'Season'], (v) => setState(() => _selectedRange = v))),
            ],
          ),
          const SizedBox(height: 16),
          _summaryCards(),
          const SizedBox(height: 16),
          _sectionTitle('Insights'),
          ..._insights.map(_insightCard).toList(),
          const SizedBox(height: 16),
          _sectionTitle('Actions'),
          ElevatedButton.icon(
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text('Generate PDF report'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report generation placeholder')),
              );
            },
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            icon: const Icon(Icons.share),
            label: const Text('Share snapshot'),
            onPressed: () {},
            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
          ),
        ],
      ),
    );
  }

  Widget _dropdown(String label, String value, List<String> items, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
          ),
          child: DropdownButton<String>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (v) {
              if (v != null) onChanged(v);
            },
          ),
        ),
      ],
    );
  }

  Widget _summaryCards() {
    return Row(
      children: [
        _metric('Soil Moisture', 'Adequate'),
        const SizedBox(width: 10),
        _metric('Irrigation', 'Tomorrow AM'),
        const SizedBox(width: 10),
        _metric('Fertilizer', 'Due in 5d'),
      ],
    );
  }

  Widget _metric(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Widget _insightCard(Map<String, String> insight) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF2E7D32).withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.analytics, color: Color(0xFF2E7D32)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(insight['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(insight['detail'] ?? '', style: const TextStyle(color: Colors.black54, fontSize: 12)),
                ],
              ),
            ),
            Text(insight['value'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
