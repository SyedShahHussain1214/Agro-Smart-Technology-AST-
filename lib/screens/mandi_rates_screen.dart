import 'package:flutter/material.dart';

class MandiRatesScreen extends StatefulWidget {
  const MandiRatesScreen({Key? key}) : super(key: key);

  @override
  State<MandiRatesScreen> createState() => _MandiRatesScreenState();
}

class _MandiRatesScreenState extends State<MandiRatesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _mandiRates = [
    {'crop': 'Wheat', 'price': 'Rs. 3,200/40kg', 'change': '+5%', 'location': 'Lahore', 'trend': 'up'},
    {'crop': 'Rice (Basmati)', 'price': 'Rs. 8,500/40kg', 'change': '+3%', 'location': 'Gujranwala', 'trend': 'up'},
    {'crop': 'Cotton', 'price': 'Rs. 14,500/40kg', 'change': '-2%', 'location': 'Multan', 'trend': 'down'},
    {'crop': 'Sugarcane', 'price': 'Rs. 350/40kg', 'change': '0%', 'location': 'Faisalabad', 'trend': 'stable'},
    {'crop': 'Maize', 'price': 'Rs. 2,800/40kg', 'change': '+4%', 'location': 'Sahiwal', 'trend': 'up'},
    {'crop': 'Potato', 'price': 'Rs. 1,200/40kg', 'change': '-8%', 'location': 'Okara', 'trend': 'down'},
    {'crop': 'Tomato', 'price': 'Rs. 800/crate', 'change': '+12%', 'location': 'Karachi', 'trend': 'up'},
    {'crop': 'Onion', 'price': 'Rs. 1,500/40kg', 'change': '-5%', 'location': 'Lahore', 'trend': 'down'},
    {'crop': 'Mango', 'price': 'Rs. 2,500/crate', 'change': '+8%', 'location': 'Multan', 'trend': 'up'},
    {'crop': 'Banana', 'price': 'Rs. 1,800/dozen', 'change': '+2%', 'location': 'Karachi', 'trend': 'up'},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredRates = _mandiRates.where((rate) {
      return rate['crop'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          rate['location'].toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Mandi Rates'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search crops or locations...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredRates.length,
              itemBuilder: (context, index) {
                final rate = filteredRates[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: rate['trend'] == 'up'
                            ? Colors.green.withOpacity(0.1)
                            : rate['trend'] == 'down'
                                ? Colors.red.withOpacity(0.1)
                                : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        rate['trend'] == 'up'
                            ? Icons.trending_up
                            : rate['trend'] == 'down'
                                ? Icons.trending_down
                                : Icons.trending_flat,
                        color: rate['trend'] == 'up'
                            ? Colors.green
                            : rate['trend'] == 'down'
                                ? Colors.red
                                : Colors.grey,
                        size: 28,
                      ),
                    ),
                    title: Text(
                      rate['crop'],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                          SizedBox(width: 4),
                          Text(rate['location'], style: TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          rate['price'],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: rate['trend'] == 'up'
                                ? Colors.green.withOpacity(0.1)
                                : rate['trend'] == 'down'
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            rate['change'],
                            style: TextStyle(
                              color: rate['trend'] == 'up'
                                  ? Colors.green
                                  : rate['trend'] == 'down'
                                      ? Colors.red
                                      : Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
