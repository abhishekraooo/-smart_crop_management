import 'package:flutter/material.dart';
import 'dart:io';

class CureDetailsPage extends StatelessWidget {
  final String disease;
  final String cureInfo;
  final double confidence;
  final File? image;

  const CureDetailsPage({
    super.key,
    required this.disease,
    required this.cureInfo,
    required this.confidence,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Treatment for $disease'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (image != null) ...[
              Center(
                child: Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(image!, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            Text(
              'Diagnosis: $disease',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 24),
            const Divider(thickness: 1),
            const SizedBox(height: 16),
            Text(
              cureInfo,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Back to Scanner',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}