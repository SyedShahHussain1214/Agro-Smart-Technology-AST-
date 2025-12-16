import 'package:flutter/material.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({Key? key}) : super(key: key);

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String _selectedCategory = 'All';
  String _sortBy = 'rating';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Wheat Seeds (Premium)',
      'category': 'Seeds',
      'price': 'Rs. 2,500',
      'unit': '/bag',
      'seller': 'AgriSupply Ltd',
      'rating': 4.5,
      'image': 'assets/images/marketplace/wheat_seeds.jpg'
    },
    {
      'name': 'DAP Fertilizer',
      'category': 'Fertilizers',
      'price': 'Rs. 4,200',
      'unit': '/bag',
      'seller': 'FarmCare',
      'rating': 4.8,
      'image': 'assets/images/marketplace/dap_fertilizer.jpg'
    },
    {
      'name': 'Tractor Rotavator',
      'category': 'Equipment',
      'price': 'Rs. 85,000',
      'unit': '',
      'seller': 'MachineHub',
      'rating': 4.3,
      'image': 'assets/images/marketplace/rotavator.jpg'
    },
    {
      'name': 'Rice Seeds (Basmati)',
      'category': 'Seeds',
      'price': 'Rs. 3,800',
      'unit': '/bag',
      'seller': 'SeedCo',
      'rating': 4.7,
      'image': 'assets/images/marketplace/rice_seeds.jpg'
    },
    {
      'name': 'Urea Fertilizer',
      'category': 'Fertilizers',
      'price': 'Rs. 1,950',
      'unit': '/bag',
      'seller': 'AgriSupply Ltd',
      'rating': 4.6,
      'image': 'assets/images/marketplace/urea.jpg'
    },
    {
      'name': 'Water Pump',
      'category': 'Equipment',
      'price': 'Rs. 25,000',
      'unit': '',
      'seller': 'PumpMaster',
      'rating': 4.4,
      'image': 'assets/images/marketplace/water_pump.jpg'
    },
    {
      'name': 'Pesticide Spray',
      'category': 'Pesticides',
      'price': 'Rs. 800',
      'unit': '/bottle',
      'seller': 'CropCare',
      'rating': 4.2,
      'image': 'assets/images/marketplace/pesticide_spray.jpg'
    },
    {
      'name': 'Cotton Seeds',
      'category': 'Seeds',
      'price': 'Rs. 2,200',
      'unit': '/bag',
      'seller': 'SeedCo',
      'rating': 4.5,
      'image': 'assets/images/marketplace/cotton_seeds.jpg'
    },
    {
      'name': 'NPK Fertilizer',
      'category': 'Fertilizers',
      'price': 'Rs. 3,500',
      'unit': '/bag',
      'seller': 'FarmCare',
      'rating': 4.7,
      'image': 'assets/images/marketplace/npk.jpg'
    },
    {
      'name': 'Drip Irrigation Kit',
      'category': 'Equipment',
      'price': 'Rs. 15,000',
      'unit': '',
      'seller': 'IrriTech',
      'rating': 4.6,
      'image': 'assets/images/marketplace/drip_kit.jpg'
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredProducts = _selectedCategory == 'All'
        ? List.from(_products)
        : _products.where((p) => p['category'] == _selectedCategory).toList();

    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      filteredProducts = filteredProducts
          .where((p) => p['name'].toString().toLowerCase().contains(query))
          .toList();
    }

    if (_sortBy == 'price') {
      filteredProducts.sort((a, b) =>
          double.parse(a['price'].toString().replaceAll(RegExp(r'[^0-9.]'), ''))
              .compareTo(double.parse(b['price'].toString().replaceAll(RegExp(r'[^0-9.]'), ''))));
    } else {
      filteredProducts.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Marketplace'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(
                        hintText: 'Search products...',
                        icon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
                  ),
                  child: DropdownButton<String>(
                    value: _sortBy,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: 'rating', child: Text('Top rated')),
                      DropdownMenuItem(value: 'price', child: Text('Lowest price')),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _sortBy = v);
                    },
                  ),
                ),
              ],
            ),
          ),
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
                      SizedBox(
                        height: 140,
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            if ((product['image'] ?? '').toString().isNotEmpty)
                              Image.asset(
                                product['image'],
                                fit: BoxFit.cover,
                              )
                            else
                              Container(color: Colors.grey[200]),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.45),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  product['name'],
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
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
                                  const SizedBox(width: 6),
                                  Text(product['seller'], style: const TextStyle(fontSize: 11, color: Colors.black54)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${product['name']} added to cart (placeholder)')),
                            );
                          },
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text('Add to cart'),
                          style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(36)),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
