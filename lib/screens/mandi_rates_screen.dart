import 'package:flutter/material.dart';
import '../services/mandi_service.dart';

class MandiRatesScreen extends StatefulWidget {
  const MandiRatesScreen({super.key});

  @override
  State<MandiRatesScreen> createState() => _MandiRatesScreenState();
}

class _MandiRatesScreenState extends State<MandiRatesScreen> {
  final MandiService _mandiService = MandiService();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _rates = [];
  List<Map<String, dynamic>> _filteredRates = [];
  Set<String> _favorites = {};
  Set<String> _alerts = {};
  List<String> _cities = ['All'];
  bool _showFavoritesOnly = false;

  bool _isLoading = true;
  String _selectedCity = 'All';
  String _selectedLanguage = 'en';
  String _sortBy = 'price_desc';
  bool _showAnalytics = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final cityList = await _mandiService.getAvailableCities();
    final response = await _mandiService.getMandiRates();

    if (!mounted) return;

    if (response['success'] == true) {
      final data = List<Map<String, dynamic>>.from(response['data'] as List);
      setState(() {
        _cities = ['All', ...cityList];
        _rates = data;
        _filteredRates = data;
        _isLoading = false;
      });
      _filterRates();
    } else {
      setState(() => _isLoading = false);
      _showError(response['error']?.toString() ?? 'Failed to load rates');
    }
  }

  void _filterRates() {
    List<Map<String, dynamic>> list = List.from(_rates);

    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      list = list
          .where((item) =>
              item['name'].toString().toLowerCase().contains(query) ||
              (item['nameUrdu']?.toString().toLowerCase() ?? '')
                  .contains(query))
          .toList();
    }

    if (_selectedCity != 'All') {
      list = list
          .where((item) =>
              item['city'].toString().toLowerCase() ==
              _selectedCity.toLowerCase())
          .toList();
    }

    if (_showFavoritesOnly && _favorites.isNotEmpty) {
      list = list.where((item) => _favorites.contains(item['name'])).toList();
    }

    list = _applySort(list);

    setState(() {
      _filteredRates = list;
    });
  }

  List<Map<String, dynamic>> _applySort(List<Map<String, dynamic>> list) {
    switch (_sortBy) {
      case 'price_asc':
        list.sort((a, b) => (a['price'] as int).compareTo(b['price'] as int));
        break;
      case 'trend_up':
        list.sort((a, b) {
          final aVal = a['trend'] == 'up' ? 1 : 0;
          final bVal = b['trend'] == 'up' ? 1 : 0;
          return bVal.compareTo(aVal); // Up trends first
        });
        break;
      case 'price_desc':
      default:
        list.sort((a, b) => (b['price'] as int).compareTo(a['price'] as int));
    }
    return list;
  }

  void _toggleFavorite(String cropName) {
    setState(() {
      if (_favorites.contains(cropName)) {
        _favorites.remove(cropName);
      } else {
        _favorites.add(cropName);
      }
    });
  }

  void _toggleAlert(String cropName) {
    setState(() {
      if (_alerts.contains(cropName)) {
        _alerts.remove(cropName);
      } else {
        _alerts.add(cropName);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_alerts.contains(cropName)
            ? 'Alerts enabled for $cropName'
            : 'Alerts disabled for $cropName'),
      ),
    );
  }

  Color _getTrendColor(String? trend) {
    switch (trend) {
      case 'up':
        return Colors.green;
      case 'down':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  String _getTrendIcon(String? trend) {
    switch (trend) {
      case 'up':
        return '↑';
      case 'down':
        return '↓';
      default:
        return '→';
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showRateDetails(Map<String, dynamic> crop) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green[50],
                  child: Text(
                    crop['name'][0].toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF28a745),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedLanguage == 'ur'
                            ? (crop['nameUrdu'] ?? crop['name'])
                            : crop['name'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${crop['city']} • ${crop['unit']}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(
                  crop['trend'] == 'up'
                      ? Icons.trending_up
                      : crop['trend'] == 'down'
                          ? Icons.trending_down
                          : Icons.trending_flat,
                  color: _getTrendColor(crop['trend']),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _detailRow(
              _selectedLanguage == 'ur' ? 'قیمت' : 'Price',
              'Rs ${crop['price']} ${crop['unit']}',
            ),
            _detailRow(
              _selectedLanguage == 'ur' ? 'بازار' : 'Market',
              crop['marketName'],
            ),
            _detailRow(
              _selectedLanguage == 'ur' ? 'معیار' : 'Quality',
              crop['quality'],
            ),
            _detailRow(
              _selectedLanguage == 'ur' ? 'تازہ ترین' : 'Updated',
              crop['lastUpdated'].toString().split('.')[0],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showPriceHistory(crop['name']),
                    icon: const Icon(Icons.show_chart),
                    label: Text(_selectedLanguage == 'ur' ? 'قیمت کی تاریخ' : 'Price history'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF28a745),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: Icon(
                    _alerts.contains(crop['name'])
                        ? Icons.notifications_active
                        : Icons.notifications_outlined,
                    color: const Color(0xFF28a745),
                  ),
                  onPressed: () => _toggleAlert(crop['name']),
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF28a745),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  _selectedLanguage == 'ur' ? 'بند کریں' : 'Close',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPriceHistory(String cropName) async {
    Navigator.pop(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FutureBuilder<Map<String, dynamic>>(
          future: _mandiService.getPriceHistory(cropName),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            final data = snapshot.data!;
            if (data['success'] != true) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Center(child: Text(data['error'] ?? 'No history available')),
              );
            }

            final history = List<Map<String, dynamic>>.from(data['data']['history'] as List);
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${data['data']['name']} price history',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: history.map((item) {
                        final price = item['price'] as int;
                        final maxPrice = history.fold<int>(0, (p, e) => p > e['price'] ? p : e['price']);
                        final barHeight = maxPrice == 0 ? 0.0 : (price / maxPrice) * 120;
                        return Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: barHeight,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF28a745),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(item['date'], style: const TextStyle(fontSize: 11)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Latest: Rs ${history.isNotEmpty ? history.last['price'] : '-'}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _selectedLanguage == 'ur' ? 'منڈی ریٹس' : 'Mandi Rates',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'Analytics',
            onPressed: () => setState(() => _showAnalytics = !_showAnalytics),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (value) {
              setState(() => _selectedLanguage = value);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'en',
                child: Row(
                  children: const [Icon(Icons.language), SizedBox(width: 8), Text('English')],
                ),
              ),
              PopupMenuItem(
                value: 'ur',
                child: Row(
                  children: const [Icon(Icons.translate), SizedBox(width: 8), Text('اردو')],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF28a745)),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          textAlign:
                              _selectedLanguage == 'ur' ? TextAlign.right : TextAlign.left,
                          onChanged: (_) => _filterRates(),
                          decoration: InputDecoration(
                            hintText:
                                _selectedLanguage == 'ur' ? 'فصل تلاش کریں...' : 'Search crop...',
                            prefixIcon: const Icon(Icons.search),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _cities.length,
                                itemBuilder: (context, index) {
                                  final city = _cities[index];
                                  final isSelected = _selectedCity == city;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: FilterChip(
                                      selected: isSelected,
                                      label: Text(
                                        _selectedLanguage == 'ur'
                                            ? (city == 'All' ? 'تمام' : city)
                                            : city,
                                      ),
                                      onSelected: (_) {
                                        setState(() => _selectedCity = city);
                                        _filterRates();
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: DropdownButton<String>(
                              value: _sortBy,
                              underline: const SizedBox(),
                              items: const [
                                DropdownMenuItem(value: 'price_desc', child: Text('Price ↓')),
                                DropdownMenuItem(value: 'price_asc', child: Text('Price ↑')),
                                DropdownMenuItem(value: 'trend_up', child: Text('Trending ↑')),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _sortBy = val);
                                  _filterRates();
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          FilterChip(
                            selected: _showFavoritesOnly,
                            label: const Text('Favorites'),
                            onSelected: (_) {
                              setState(() => _showFavoritesOnly = !_showFavoritesOnly);
                              _filterRates();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (_showAnalytics) _MandiAnalytics(rates: _filteredRates),
                    ],
                  ),
                ),
                Expanded(
                  child: _filteredRates.isEmpty
                      ? Center(
                          child: Text(
                            _selectedLanguage == 'ur' ? 'کوئی شرح دستیاب نہیں' : 'No rates available',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: _filteredRates.length,
                          itemBuilder: (context, index) {
                            final rate = _filteredRates[index];
                            final isFav = _favorites.contains(rate['name']);
                            final trend = rate['trend'] ?? 'stable';
                            final change = rate['change']?.toString() ?? '0';
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () => _showRateDetails(rate),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 54,
                                        height: 54,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF28a745).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Icon(Icons.agriculture, color: Color(0xFF28a745)),
                                      ),
                                      const SizedBox(width: 14),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _selectedLanguage == 'ur'
                                                  ? (rate['nameUrdu'] ?? rate['name'])
                                                  : rate['name'],
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${rate['city']} • ${rate['unit']}',
                                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              _selectedLanguage == 'ur'
                                                  ? 'تازہ ترین: ${rate['lastUpdated'].toString().split('.')[0]}'
                                                  : 'Updated: ${rate['lastUpdated'].toString().split('.')[0]}',
                                              style: TextStyle(color: Colors.grey[500], fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Rs ${rate['price']}',
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w800,
                                              color: Color(0xFF28a745),
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              Text(
                                                _getTrendIcon(trend),
                                                style: TextStyle(
                                                  color: _getTrendColor(trend),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                change,
                                                style: TextStyle(
                                                  color: _getTrendColor(trend),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          SizedBox(
                                            height: 32,
                                            child: OutlinedButton.icon(
                                              onPressed: () => _showPriceHistory(rate['name']),
                                              icon: const Icon(Icons.show_chart, size: 16),
                                              label: const Text('History', style: TextStyle(fontSize: 12)),
                                              style: OutlinedButton.styleFrom(
                                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                                side: const BorderSide(color: Color(0xFF28a745)),
                                                foregroundColor: const Color(0xFF28a745),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              _alerts.contains(rate['name'])
                                                  ? Icons.notifications_active
                                                  : Icons.notifications_none,
                                              color: _alerts.contains(rate['name'])
                                                  ? Colors.orange
                                                  : Colors.grey,
                                            ),
                                            onPressed: () => _toggleAlert(rate['name']),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              isFav ? Icons.favorite : Icons.favorite_border,
                                              color: isFav ? Colors.red : Colors.grey,
                                            ),
                                            onPressed: () => _toggleFavorite(rate['name']),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
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

class _MandiAnalytics extends StatelessWidget {
  final List<Map<String, dynamic>> rates;
  const _MandiAnalytics({required this.rates});

  @override
  Widget build(BuildContext context) {
    if (rates.isEmpty) return const SizedBox.shrink();

    final topGainers = List<Map<String, dynamic>>.from(rates)
      ..sort((a, b) => (b['change'] ?? 0).compareTo(a['change'] ?? 0));
    final topLosers = List<Map<String, dynamic>>.from(rates)
      ..sort((a, b) => (a['change'] ?? 0).compareTo(b['change'] ?? 0));

    final avgPrice = rates
        .map((e) => (e['price'] ?? 0) as num)
        .fold<num>(0, (p, e) => p + e) /
        (rates.isEmpty ? 1 : rates.length);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.analytics, color: Color(0xFF28a745)),
                SizedBox(width: 8),
                Text('Market Analytics',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Average price: Rs ${avgPrice.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: Row(
                children: [
                  Expanded(
                    child: _AnalyticsList(
                      title: 'Top Gainers',
                      items: topGainers.take(5).toList(),
                      positive: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _AnalyticsList(
                      title: 'Top Losers',
                      items: topLosers.take(5).toList(),
                      positive: false,
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
}

class _AnalyticsList extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final bool positive;
  const _AnalyticsList({
    required this.title,
    required this.items,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final change = (item['change'] ?? 0).toString();
              final color = positive ? Colors.green : Colors.red;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item['name'],
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(change, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
