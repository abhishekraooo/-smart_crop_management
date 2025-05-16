import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;

class TfliteService {
  late Interpreter _interpreter;
  bool _isModelLoaded = false;
  List<String> _labels = [];

  List<String> get labels => _labels;

  /// Load the TFLite model from assets
  Future<void> loadModel() async {
    try {
      final modelPath = 'assets/tflite/crop_prediction_model.tflite';
      final modelData = await rootBundle.load(modelPath);
      final Uint8List modelBytes = modelData.buffer.asUint8List();

      _interpreter = await Interpreter.fromBuffer(modelBytes);
      _isModelLoaded = true;
      print("✅ Model loaded successfully.");
    } catch (e) {
      _isModelLoaded = false;
      throw Exception("❌ Failed to load TFLite model: $e");
    }
  }

  /// Load crop labels from label.txt
  Future<void> loadLabels() async {
    try {
      final labelPath = 'assets/labels/label.txt';
      final String labelContent = await rootBundle.loadString(labelPath);
      _labels =
          labelContent
              .split('\n')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList();
      print("✅ Labels loaded: $_labels");
    } catch (e) {
      throw Exception("❌ Failed to load labels: $e");
    }
  }

  /// Predict top N crops based on input values
  Future<List<String>> predictTopNCrops(
    List<double> input, {
    required List<double> mean,
    required List<double> std,
    int topN = 5,
  }) async {
    if (_labels.isEmpty) throw Exception("Labels not loaded");
    if (!_isModelLoaded) throw Exception("Model not loaded");

    // Standard scale input
    final scaledInput = _standardScale(input, mean: mean, std: std);

    final inputTensor = [scaledInput.map((e) => e.toDouble()).toList()];
    final outputTensor = List<List<double>>.filled(
      1,
      List<double>.filled(_labels.length, 0.0),
    );

    try {
      _interpreter.run(inputTensor, outputTensor);

      List<MapEntry<String, double>> cropProbs = [];

      for (int i = 0; i < outputTensor[0].length; i++) {
        cropProbs.add(MapEntry(_labels[i], outputTensor[0][i]));
      }

      cropProbs.sort((a, b) => b.value.compareTo(a.value));

      return cropProbs.take(topN).map((entry) => entry.key).toList();
    } catch (e) {
      throw Exception("❌ Prediction failed: $e");
    }
  }

  /// Standard Scaler (matches scikit-learn's StandardScaler)
  List<double> _standardScale(
    List<double> values, {
    required List<double> mean,
    required List<double> std,
  }) {
    assert(values.length == mean.length && mean.length == std.length);
    return values.asMap().entries.map((e) {
      return (e.value - mean[e.key]) / std[e.key];
    }).toList();
  }

  /// Close interpreter when done
  void close() {
    _interpreter.close();
  }
}
