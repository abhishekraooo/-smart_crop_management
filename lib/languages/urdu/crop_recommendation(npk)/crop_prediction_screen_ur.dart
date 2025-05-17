// crop_prediction_screen_hi.dart (Hindi)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hacksprint_mandya/languages/kannada/crop_recommendation(npk)/crop_result_screen_ka.dart';
import 'package:hacksprint_mandya/utils/language_strings.dart';
import '../../../utils/feature_range.dart';
import '../../../utils/tflite_service.dart';

class CropPredictionScreenUR extends StatefulWidget {
  const CropPredictionScreenUR({Key? key}) : super(key: key);

  @override
  State<CropPredictionScreenUR> createState() => _CropPredictionScreenHIState();
}

class _CropPredictionScreenHIState extends State<CropPredictionScreenUR> {
  final TfliteService _tflite = TfliteService();
  late Map<String, FeatureRange> featureRanges;
  final LanguageStrings _strings = UrduStrings();

  bool _isInitialized = false;
  String _predictedCrop = "Predicted Crops";

  late List<TextEditingController> _controllers;
  List<FocusNode> _focusNodes = [];

  @override
  void initState() {
    super.initState();

    // Initialize controllers and focus nodes
    _controllers = List.generate(7, (_) => TextEditingController());
    _focusNodes = List.generate(7, (_) => FocusNode());

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

    final List<double> mean = [90.0, 42.0, 43.0, 20.87, 82.0, 6.5, 200.0];
    final List<double> std = [5.0, 3.0, 4.0, 1.0, 5.0, 0.3, 20.0];

    try {
      final predictions = await _tflite.predictTopNCropsWithProb(
        doubleInputs,
        mean: mean,
        std: std,
        topN: 5,
      );

      final topCrops = predictions.map((item) => item.keys.first).toList();
      final probabilities =
          predictions.map((item) => item.values.first).toList();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => CropResultScreenKA(
                mainCrop: topCrops[0],
                sideCrops: topCrops.sublist(1),
                probabilities: probabilities,
              ),
        ),
      );

      setState(() {
        _predictedCrop = topCrops.join(', ');
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
      if (text.isEmpty) {
        return "Please enter a value for ${featureNames[i]}";
      }

      final numValue = double.tryParse(text);
      if (numValue == null) {
        return "${featureNames[i]} must be a number.";
      }

      final range = featureRanges[featureNames[i]]!;
      if (numValue < range.min || numValue > range.max) {
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
    // Dispose controllers
    for (var c in _controllers) {
      c.dispose();
    }

    // Dispose focus nodes
    for (var node in _focusNodes) {
      node.dispose();
    }

    _tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.green[100],
        title: null,
      ),
      backgroundColor: Colors.green[100],
      body:
          _isInitialized
              ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        _strings.pageTitle,
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Center(
                        child: SizedBox(
                          height: 220,
                          width: double.infinity,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _controllers.length,
                            separatorBuilder:
                                (context, index) => const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              final labels = [
                                _strings.nitrogen,
                                _strings.phosphorus,
                                _strings.potassium,
                                _strings.temperature,
                                _strings.humidity,
                                _strings.ph,
                                _strings.rainfall,
                              ];
                              return Container(
                                width: 180,
                                height: 180,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        labels[index],
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: _controllers[index],
                                        keyboardType: TextInputType.number,
                                        focusNode: _focusNodes[index],
                                        decoration: InputDecoration(
                                          hintText: _getDefaultHint(index),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 16),
                                        onFieldSubmitted: (value) {
                                          if (index < _focusNodes.length - 1) {
                                            FocusScope.of(context).requestFocus(
                                              _focusNodes[index + 1],
                                            );
                                          } else {
                                            FocusScope.of(context).unfocus();
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: _predict,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          _strings.predictButton,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
