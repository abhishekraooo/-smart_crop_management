import 'package:flutter/material.dart';
import 'feature_range.dart';
import 'tflite_service.dart';

class CropPredictionScreen extends StatefulWidget {
  const CropPredictionScreen({Key? key}) : super(key: key);

  @override
  State<CropPredictionScreen> createState() => _CropPredictionScreenState();
}

class _CropPredictionScreenState extends State<CropPredictionScreen> {
  final TfliteService _tflite = TfliteService();
  late Map<String, FeatureRange> featureRanges;

  bool _isInitialized = false;
  String _predictedCrop = "Predicted Crops";
  final List<TextEditingController> _controllers = List.generate(
    7,
    (_) => TextEditingController(),
  );

  @override
  void initState() {
    super.initState();
    _initializeModelAndLabels();
    _loadFeatureRanges();
  }

  Future<void> _initializeModelAndLabels() async {
    try {
      await Future.wait([_tflite.loadModel(), _tflite.loadLabels()]);
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  Future<void> _loadFeatureRanges() async {
    featureRanges = await FeatureRange.loadRanges();
  }

  void _predict() async {
    final String? error = _getValidationError();
    if (error != null) {
      _showErrorDialog(error);
      return;
    }

    final List<double> doubleInputs =
        _controllers.map((c) => double.parse(c.text)).toList();

    final mean = [90.0, 42.0, 43.0, 20.87, 82.0, 6.5, 200.0];
    final std = [5.0, 3.0, 4.0, 1.0, 5.0, 0.3, 20.0];

    try {
      final prediction = await _tflite.predictTopNCrops(
        doubleInputs,
        mean: mean,
        std: std,
        topN: 5,
      );
      setState(() {
        _predictedCrop = prediction.join(', ');
      });
    } catch (e) {
      _showErrorDialog(e.toString());
    }
  }

  String? _getValidationError() {
    final List<String> featureNames = [
      'N',
      'P',
      'K',
      'temperature',
      'humidity',
      'ph',
      'rainfall',
    ];

    for (int i = 0; i < _controllers.length; i++) {
      final text = _controllers[i].text.trim();
      if (text.isEmpty) return "Please fill all fields.";

      final numValue = double.tryParse(text);
      if (numValue == null) return "${featureNames[i]} must be a number.";

      final range = featureRanges[featureNames[i]];
      if (range != null && (numValue < range.min || numValue > range.max)) {
        return "${featureNames[i]} must be between ${range.min} and ${range.max}.";
      }
    }

    return null;
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: Navigator.of(context).pop,
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  String _getDefaultHint(int index) {
    final hints = [
      "e.g. 90",
      "e.g. 42",
      "e.g. 43",
      "e.g. 20.87",
      "e.g. 82",
      "e.g. 6.5",
      "e.g. 200",
    ];
    return hints[index];
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    _tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crop Prediction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _isInitialized
                ? Form(
                  child: ListView(
                    children: [
                      ...[
                        'Nitrogen (N)',
                        'Phosphorus (P)',
                        'Potassium (K)',
                        'Temperature',
                        'Humidity',
                        'pH',
                        'Rainfall',
                      ].asMap().entries.map((entry) {
                        final index = entry.key;
                        final label = entry.value;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextFormField(
                            controller: _controllers[index],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: label,
                              hintText: _getDefaultHint(index),
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _predict,
                        child: const Text('Predict Crop'),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Result: $_predictedCrop',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                )
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
