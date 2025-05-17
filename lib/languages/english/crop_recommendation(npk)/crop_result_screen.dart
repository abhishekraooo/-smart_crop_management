import 'package:flutter/material.dart';
import 'package:hacksprint_mandya/auth/auth_service.dart';
import 'package:hacksprint_mandya/languages/english/crop_dashboard.dart';
import 'package:hacksprint_mandya/utils/home_navigators.dart';

class CropResultScreen extends StatelessWidget {
  final String mainCrop;
  final List<String> sideCrops;
  final List<double> probabilities;

  const CropResultScreen({
    Key? key,
    required this.mainCrop,
    required this.sideCrops,
    required this.probabilities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: null,
        backgroundColor: Colors.green.shade100,
      ),
      backgroundColor: Colors.green[100],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Crop Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.green, width: 2),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      "Main Crop",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            mainCrop,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        Text(
                          "${(probabilities[0] * 100).toStringAsFixed(1)}%",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Side Crops Section
            Text(
              "🌿 Suggested Side Crops",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple[800],
              ),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: sideCrops.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.green.shade900.withOpacity(0.2),
                      child: Text("${index + 1}"),
                    ),
                    title: Text(sideCrops[index]),
                    trailing: Text(
                      "${(probabilities[index + 1] * 100).toStringAsFixed(1)}%",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),

            // Home Icon Button
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 10),
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.home, size: 32),
                  color: Colors.green,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                MainNavigation(authService: AuthService()),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
