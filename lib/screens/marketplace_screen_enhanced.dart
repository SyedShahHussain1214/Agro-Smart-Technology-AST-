import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../config/theme_provider.dart';

class MarketplaceScreenEnhanced extends StatefulWidget {
  const MarketplaceScreenEnhanced({Key? key}) : super(key: key);

  @override
  State<MarketplaceScreenEnhanced> createState() => _MarketplaceScreenEnhancedState();
}

class _MarketplaceScreenEnhancedState extends State<MarketplaceScreenEnhanced> {
  String _selectedCategory = 'All';
  String _sortBy = 'rating';
  final TextEditingController _searchController = TextEditingController();
  final List<Map<String, dynamic>> _cart = [];

  final List<Map<String, dynamic>> _products = [
    {
      'name': 'Premium Wheat Seeds',
      'nameUrdu': 'پریمیم گندم کے بیج',
      'category': 'Seeds',
      'price': 2500,
      'unit': '/bag (50kg)',
      'seller': 'SeedCo Punjab',
      'rating': 4.8,
      'reviews': 234,
      'image': 'assets/images/marketplace/wheat seeds.jpg',
      'description': 'High-yield certified wheat seeds for Punjab region',
      'inStock': true,
    },
    {
      'name': 'Organic DAP Fertilizer',
      'nameUrdu': 'نامیاتی ڈی اے پی کھاد',
      'category': 'Fertilizers',
      'price': 4200,
      'unit': '/bag (50kg)',
      'seller': 'FarmCare Pakistan',
      'rating': 4.9,
      'reviews': 456,
      'image': 'assets/images/marketplace/DAP fertilizer.jpg',
      'description': 'Premium quality DAP for better crop yield',
      'inStock': true,
    },
    {
      'name': 'Heavy Duty Rotavator',
      'nameUrdu': 'بھاری روٹاویٹر',
      'category': 'Equipment',
      'price': 85000,
      'unit': '',
      'seller': 'MachineHub Lahore',
      'rating': 4.6,
      'reviews': 89,
      'image': 'assets/images/marketplace/heavy duty rotavator.jpeg',
      'description': '6ft rotavator for tractors, heavy-duty build',
      'inStock': true,
    },
    {
      'name': 'Basmati Rice Seeds',
      'nameUrdu': 'باسمتی چاول کے بیج',
      'category': 'Seeds',
      'price': 3800,
      'unit': '/bag (40kg)',
      'seller': 'SeedCo Punjab',
      'rating': 4.7,
      'reviews': 321,
      'image': 'assets/images/marketplace/basmati rice seeds.jpg',
      'description': 'Super kernel basmati variety',
      'inStock': true,
    },
    {
      'name': 'Urea Fertilizer (Imported)',
      'nameUrdu': 'یوریا کھاد',
      'category': 'Fertilizers',
      'price': 1950,
      'unit': '/bag (50kg)',
      'seller': 'AgriSupply Ltd',
      'rating': 4.5,
      'reviews': 567,
      'image': 'assets/images/marketplace/urea fertilizer.jpg',
      'description': 'High-purity urea for nitrogen boost',
      'inStock': true,
    },
    {
      'name': 'Submersible Water Pump',
      'nameUrdu': 'پانی کا پمپ',
      'category': 'Equipment',
      'price': 25000,
      'unit': '',
      'seller': 'PumpMaster',
      'rating': 4.4,
      'reviews': 178,
      'image': 'assets/images/marketplace/submersible water pump.jpg',
      'description': '1HP submersible pump with warranty',
      'inStock': false,
    },
    {
      'name': 'Bio Pesticide Spray',
      'nameUrdu': 'حیاتیاتی کیڑے مار',
      'category': 'Pesticides',
      'price': 800,
      'unit': '/bottle (1L)',
      'seller': 'CropCare Organic',
      'rating': 4.3,
      'reviews': 234,
      'image': 'assets/images/marketplace/bio pesticide spray.jpg',
      'description': 'Organic solution for pest control',
      'inStock': true,
    },
    {
      'name': 'Hybrid Cotton Seeds',
      'nameUrdu': 'ہائبرڈ کپاس کے بیج',
      'category': 'Seeds',
      'price': 2200,
      'unit': '/bag (20kg)',
      'seller': 'SeedCo Punjab',
      'rating': 4.8,
      'reviews': 412,
      'image': 'assets/images/marketplace/hybrid cotton seeds.jpg',
      'description': 'BT cotton variety high yield',
      'inStock': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    List<Map<String, dynamic>> filteredProducts = _selectedCategory == 'All'
        ? List.from(_products)
        : _products.where((p) => p['category'] == _selectedCategory).toList();

    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      filteredProducts = filteredProducts
          .where((p) =>
              p['name'].toString().toLowerCase().contains(query) ||
              p['nameUrdu'].toString().contains(query))
          .toList();
    }

    if (_sortBy == 'price_low') {
      filteredProducts.sort((a, b) => (a['price'] as int).compareTo(b['price'] as int));
    } else if (_sortBy == 'price_high') {
      filteredProducts.sort((a, b) => (b['price'] as int).compareTo(a['price'] as int));
    } else {
      filteredProducts.sort((a, b) => (b['rating'] as double).compareTo(a['rating'] as double));
    }

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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.shopping_bag,
                                  color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Marketplace',
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'کسانوں کی منڈی',
                              style: GoogleFonts.notoNastaliqUrdu(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                              ),
                            ),
                          ],
                        ),
                        // Cart Badge
                        Stack(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.shopping_cart),
                              iconSize: 28,
                              color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                              onPressed: () => _showCart(context, isDark),
                            ),
                            if (_cart.isNotEmpty)
                              Positioned(
                                right: 4,
                                top: 4,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${_cart.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1a1f35).withOpacity(0.6) : Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                        decoration: InputDecoration(
                          hintText: 'Search products... مصنوعات تلاش کریں',
                          hintStyle: TextStyle(
                            color: isDark ? Colors.white54 : Colors.black54,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {});
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Filters
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: ['All', 'Seeds', 'Fertilizers', 'Equipment', 'Pesticides']
                            .map((category) {
                          final isSelected = _selectedCategory == category;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(category),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() => _selectedCategory = category);
                              },
                              backgroundColor: isDark
                                  ? const Color(0xFF1a1f35).withOpacity(0.6)
                                  : Colors.white,
                              selectedColor: isDark
                                  ? const Color(0xFF4ade80)
                                  : const Color(0xFF28a745),
                              checkmarkColor: isDark ? Colors.black : Colors.white,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? (isDark ? Colors.black : Colors.white)
                                    : (isDark ? Colors.white : Colors.black87),
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.sort,
                        color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                      ),
                      onSelected: (value) => setState(() => _sortBy = value),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'rating', child: Text('Top Rated')),
                        const PopupMenuItem(value: 'price_low', child: Text('Price: Low to High')),
                        const PopupMenuItem(value: 'price_high', child: Text('Price: High to Low')),
                      ],
                    ),
                  ],
                ),
              ),
              // Products Grid
              Expanded(
                child: filteredProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 80,
                              color: isDark ? Colors.white24 : Colors.black26,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No products found',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                color: isDark ? Colors.white54 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return _buildProductCard(product, isDark);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(Map<String, dynamic> product, bool isDark) {
    final isInCart = _cart.any((item) => item['name'] == product['name']);
    
    return GestureDetector(
      onTap: () => _showProductDetails(product, isDark),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1a1f35).withOpacity(0.6) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: (product['image'] as String).startsWith('http')
                      ? Image.network(
                          product['image'],
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 140,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, size: 50),
                          ),
                        )
                      : Image.asset(
                          product['image'],
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 140,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, size: 50),
                          ),
                        ),
                ),
                if (!product['inStock'])
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      ),
                      child: Center(
                        child: Text(
                          'Out of Stock',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          '${product['rating']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        product['name'],
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        product['nameUrdu'],
                        style: GoogleFonts.notoNastaliqUrdu(
                          fontSize: 11,
                          color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          'Rs. ${product['price']}',
                          style: GoogleFonts.poppins(
                            color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      product['unit'],
                      style: TextStyle(
                        fontSize: 10,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: product['inStock']
                            ? () {
                                setState(() {
                                  if (isInCart) {
                                    _cart.removeWhere((item) => item['name'] == product['name']);
                                  } else {
                                    _cart.add(product);
                                  }
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      isInCart ? 'Removed from cart' : 'Added to cart',
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                );
                              }
                            : null,
                        icon: Icon(
                          isInCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart,
                          size: 16,
                        ),
                        label: Text(
                          isInCart ? 'Remove' : 'Add',
                          style: const TextStyle(fontSize: 12),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isInCart
                              ? Colors.red
                              : (isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745)),
                          foregroundColor: isDark && !isInCart ? Colors.black : Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetails(Map<String, dynamic> product, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1a1f35) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black26,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              child: (product['image'] as String).startsWith('http')
                  ? Image.network(
                      product['image'],
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 250,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, size: 50),
                      ),
                    )
                  : Image.asset(
                      product['image'],
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 250,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 50),
                      ),
                    ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['name'],
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              Text(
                                product['nameUrdu'],
                                style: GoogleFonts.notoNastaliqUrdu(
                                  fontSize: 18,
                                  color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Rs. ${product['price']}',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                              ),
                            ),
                            Text(
                              product['unit'],
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.white54 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${product['rating']} (${product['reviews']} reviews)',
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Description',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product['description'],
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.store,
                          size: 20,
                          color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          product['seller'],
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: product['inStock']
                            ? () {
                                setState(() => _cart.add(product));
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Added to cart!'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.add_shopping_cart),
                        label: Text(
                          product['inStock'] ? 'Add to Cart' : 'Out of Stock',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                          foregroundColor: isDark ? Colors.black : Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCart(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1a1f35) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black26,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Shopping Cart',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                    ),
                  ),
                  Text(
                    '${_cart.length} items',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            if (_cart.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 80,
                        color: isDark ? Colors.white24 : Colors.black26,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Your cart is empty',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _cart.length,
                  itemBuilder: (context, index) {
                    final item = _cart[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF243B55).withOpacity(0.3) : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: (item['image'] as String).startsWith('http')
                                ? Image.network(
                                    item['image'],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image, size: 30),
                                    ),
                                  )
                                : Image.asset(
                                    item['image'],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image, size: 30),
                                    ),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                                Text(
                                  'Rs. ${item['price']}',
                                  style: TextStyle(
                                    color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() => _cart.removeAt(index));
                              Navigator.pop(context);
                              _showCart(context, isDark);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            if (_cart.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF243B55) : Colors.grey[200],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        Text(
                          'Rs. ${_cart.fold<int>(0, (sum, item) => sum + (item['price'] as int))}',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Checkout feature coming soon!'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? const Color(0xFF4ade80) : const Color(0xFF28a745),
                          foregroundColor: isDark ? Colors.black : Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Proceed to Checkout',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
