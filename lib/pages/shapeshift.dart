import 'package:flutter/material.dart';
import 'marketrate.dart';

class ShapeShiftPAge extends StatefulWidget {
  const ShapeShiftPAge({super.key});

  @override
  State<ShapeShiftPAge> createState() => _CropPricePageState();
}

class _CropPricePageState extends State<ShapeShiftPAge> {
  final List<Map<String, String>> _crops = [
    {'name': 'Corn', 'price': '81', 'image': 'assets/images/corn.jpg'},
    {'name': 'Onions', 'price': '33.5', 'image': 'assets/images/onion.jpg'},
    {'name': 'Okra', 'price': '53', 'image': 'assets/images/okra.jpg'},
    {'name': 'Peppers', 'price': '120', 'image': 'assets/images/pepper.jpg'},
    {'name': 'Cauliflower', 'price': '48', 'image': 'assets/images/cauliflower.jpg'},
    {'name': 'Potato', 'price': '34', 'image': 'assets/images/potato.jpg'},
  ];

  String _selectedCrop = '';
  String _babyPrice = '';
  String _regularPrice = '';
  String _selectedImage = '';
  bool _showViewRatesButton = false;

  void _calculateBabyPrice(String cropName, String regularPrice, String image) {
    setState(() {
      _selectedCrop = cropName;
      _selectedImage = image;
      _regularPrice = regularPrice;
      final double cost = double.parse(regularPrice);
      final double calculatedPrice = (cost * 2) + 12;
      _babyPrice = calculatedPrice.toStringAsFixed(2);
      _showViewRatesButton = true;
    });
  }

  void _navigateToCropHistory(BuildContext context) {
    if (_selectedCrop.isEmpty) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CropHistoryScreen(
          
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crop Price Checker')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // Crops Grid - now with limited height
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: _crops.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 45,
                          childAspectRatio: 3 / 2,
                        ),
                        itemBuilder: (context, index) {
                          var crop = _crops[index];
                          return Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              onTap: () => _calculateBabyPrice(
                                  crop['name']!, crop['price']!, crop['image']!),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12)),
                                    child: SizedBox(
                                      height: 100,
                                      width: double.infinity,
                                      child: Image.asset(
                                        crop['image']!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          crop['name']!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Regular: ₹${crop['price']}',
                                          style: TextStyle(
                                            color: Colors.green[700],
                                            fontSize: 14,
                                          ),
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Selected Crop Info Card - now more compact
                    Container(
                      constraints: BoxConstraints(
                        minHeight: 200,
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: Card(
                        color: Colors.grey[200],
                        margin: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _selectedCrop.isNotEmpty
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      _selectedCrop,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 10),
                                    ClipRRect(
                                      
                                      child: Image.asset(
                                        _selectedImage,
                                        height: 60,
                                        width: 60,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Regular: ₹$_regularPrice',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      'Baby: ₹$_babyPrice',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        color: Color.fromARGB(255, 51, 201, 13),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (_showViewRatesButton) ...[
                                      const SizedBox(height: 12),
                                      ElevatedButton(
                                        onPressed: () => _navigateToCropHistory(context),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 18),
                                        ),
                                        child: const Text(
                                          'View Market Rates',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                )
                              : Center(
                                  child: Text(
                                    "Tap on a crop to see baby version price",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}