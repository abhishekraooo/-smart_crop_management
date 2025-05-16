import 'package:flutter/material.dart';

class ShapeShiftPAge extends StatefulWidget {
  const ShapeShiftPAge({super.key});

  @override
  State<ShapeShiftPAge> createState() => _CropPricePageState();
}

class _CropPricePageState extends State<ShapeShiftPAge> {
  // Predefined list of crops with name, price, and image path
  final List<Map<String, String>> _crops = [
    {
      'name': 'Corn',
      'price': '81',
      'image': 'assets/images/corn.jpg'
    },
    {
      'name': 'Onions',
      'price': '33.5',
      'image': 'assets/images/onion.jpg'
    },
    {
      'name': 'Okra',
      'price': '53',
      'image': 'assets/images/okra.jpg'
    },
    {
      'name': 'Peppers',
      'price': '120',
      'image': 'assets/images/pepper.jpg'
    },
    {
      'name': 'Cauliflower',
      'price': '48',
      'image': 'assets/images/cauliflower.jpg'
    },
    {
      'name': 'Potato',
      'price': '34',
      'image': 'assets/images/potato.jpg'
    },
  ];

  String _selectedCrop = '';
  String _babyPrice = '';
  String _selectedImage = '';

  void _calculateBabyPrice(String cropName, String regularPrice, String image) {
    setState(() {
      _selectedCrop = cropName;
      _selectedImage = image;
      final double cost = double.parse(regularPrice);
      final double calculatedPrice = (cost * 2) + 12;
      _babyPrice = '₹${calculatedPrice.toStringAsFixed(2)}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crop Price Checker')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Crops Grid
            Expanded(
              flex: 2,
              child: GridView.builder(
                shrinkWrap: true,
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
                      onTap: () =>
                          _calculateBabyPrice(crop['name']!, crop['price']!, crop['image']!),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Image with constrained height
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
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
                                // Crop Name - limited and ellipsized
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
                                // Price text
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

            // Selected Crop Info Card
            Expanded(
              flex: 1,
              child: Card(
                color: Colors.grey[200],
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: _selectedCrop.isNotEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _selectedCrop,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset(
                                  _selectedImage,
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Baby Version Price: $_babyPrice',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.deepOrangeAccent,
                                ),
                              )
                            ],
                          )
                        : Text(
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
    );
  }
}