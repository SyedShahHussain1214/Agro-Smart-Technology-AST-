import 'package:flutter/material.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _products = [
    {'name': 'Wheat Seeds (Premium)', 'category': 'Seeds', 'price': 'Rs. 2,500', 'unit': '/bag', 'seller': 'AgriSupply Ltd', 'rating': 4.5},
    {'name': 'DAP Fertilizer', 'category': 'Fertilizers', 'price': 'Rs. 4,200', 'unit': '/bag', 'seller': 'FarmCare', 'rating': 4.8},
    {'name': 'Tractor Rotavator', 'category': 'Equipment', 'price': 'Rs. 85,000', 'unit': '', 'seller': 'MachineHub', 'rating': 4.3},
    {'name': 'Rice Seeds (Basmati)', 'category': 'Seeds', 'price': 'Rs. 3,800', 'unit': '/bag', 'seller': 'SeedCo', 'rating': 4.7},
    {'name': 'Urea Fertilizer', 'category': 'Fertilizers', 'price': 'Rs. 1,950', 'unit': '/bag', 'seller': 'AgriSupply Ltd', 'rating': 4.6},
    {'name': 'Water Pump', 'category': 'Equipment', 'price': 'Rs. 25,000', 'unit': '', 'seller': 'PumpMaster', 'rating': 4.4},
    {'name': 'Pesticide Spray', 'category': 'Pesticides', 'price': 'Rs. 800', 'unit': '/bottle', 'seller': 'CropCare', 'rating': 4.2},
    {'name': 'Cotton Seeds', 'category': 'Seeds', 'price': 'Rs. 2,200', 'unit': '/bag', 'seller': 'SeedCo', 'rating': 4.5},
    {'name': 'NPK Fertilizer', 'category': 'Fertilizers', 'price': 'Rs. 3,500', 'unit': '/bag', 'seller': 'FarmCare', 'rating': 4.7},
    {'name': 'Drip Irrigation Kit', 'category': 'Equipment', 'price': 'Rs. 15,000', 'unit': '', 'seller': 'IrriTech', 'rating': 4.6},
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _selectedCategory == 'All'
        ? _products
        : _products.where((p) => p['category'] == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Marketplace'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: ['All', 'Seeds', 'Fertilizers', 'Equipment', 'Pesticides'].map((category) {
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = category);
                    },
                    selectedColor: Theme.of(context).colorScheme.primary,
                    checkmarkColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return Card(
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 140,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(
                            _getCategoryIcon(product['category']),
                            size: 60,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Spacer(),
                              Text(
                                '${product['price']}${product['unit']}',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.star, size: 14, color: Colors.amber),
                                  SizedBox(width: 4),
                                  Text('${product['rating']}', style: TextStyle(fontSize: 12)),
                                  Spacer(),
                                  Icon(Icons.store, size: 12, color: Colors.grey[600]),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Seeds':
        return Icons.eco;
      case 'Fertilizers':
        return Icons.science;
      case 'Equipment':
        return Icons.build;
      case 'Pesticides':
        return Icons.pest_control;
      default:
        return Icons.shopping_bag;
    }
  }
}
