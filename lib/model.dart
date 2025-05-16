import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'cure_details_page.dart';
import 'cure_service.dart';

class ClassifierScreen extends StatefulWidget {
  const ClassifierScreen({super.key});

  @override
  State<ClassifierScreen> createState() => _ClassifierScreenState();
}

class _ClassifierScreenState extends State<ClassifierScreen> {
  File? _image;
  String _prediction = '';
  double _confidence = 0.0;
  bool _isLoading = false;
  bool _showCureButton = false;
  late Interpreter _interpreter;
  List<String> _labels = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeModel();
  }

  Future<void> _initializeModel() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/model.tflite',
        options: InterpreterOptions()..threads = 4,
      );
      await _loadLabels();
    } catch (e) {
      setState(() => _errorMessage = 'Model loading failed: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadLabels() async {
    try {
      final labelData = await rootBundle.loadString('assets/finallabels.txt');
      _labels = labelData.split('\n')
          .map((label) => label.trim())
          .where((label) => label.isNotEmpty)
          .toList();
    } catch (e) {
      final outputDim = _interpreter.getOutputTensor(0).shape.last;
      _labels = List.generate(outputDim, (i) => 'Class $i');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;
      await _processSelectedImage(File(pickedFile.path));
    } catch (e) {
      setState(() => _errorMessage = 'Image selection failed: $e');
    }
  }

  Future<void> _processSelectedImage(File imageFile) async {
    setState(() {
      _image = imageFile;
      _isLoading = true;
      _prediction = '';
      _showCureButton = false;
      _errorMessage = '';
    });

    await _runInference(_image!);
  }

  Future<void> _runInference(File image) async {
    try {
      final bytes = await image.readAsBytes();
      final imageDecoded = img.decodeImage(bytes);
      if (imageDecoded == null) throw Exception('Image decoding failed');

      final inputTensor = _interpreter.getInputTensor(0);
      final inputShape = inputTensor.shape;
      final resized = img.copyResize(
        imageDecoded,
        width: inputShape[2],
        height: inputShape[1],
      );

      final inputBuffer = _prepareInputBuffer(resized, inputTensor.type, inputShape);

      final outputShape = _interpreter.getOutputTensor(0).shape;
      final outputBuffer = List.filled(
        outputShape.reduce((a, b) => a * b),
        0.0,
      ).reshape(outputShape);
      
      _interpreter.run(inputBuffer, outputBuffer);
      _processOutput(outputBuffer[0]);
    } catch (e) {
      setState(() => _errorMessage = 'Processing failed: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _processOutput(List<dynamic> output) {
    int maxIndex = 0;
    double maxConfidence = 0.0;
    
    for (int i = 0; i < output.length; i++) {
      if (output[i] > maxConfidence) {
        maxConfidence = output[i].toDouble();
        maxIndex = i;
      }
    }

    setState(() {
      _confidence = maxConfidence;
      _prediction = maxIndex < _labels.length ? _labels[maxIndex] : 'Class $maxIndex';
      _showCureButton = true;
    });
  }

  Future<void> _navigateToCurePage() async {
    // Call the CureService to get treatment information
    final cureInfo = await CureService.getCure(_prediction);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CureDetailsPage(
          disease: _prediction,
          cureInfo: cureInfo,
          confidence: _confidence,
          image: _image,
        ),
      ),
    );
  }

  dynamic _prepareInputBuffer(img.Image image, TensorType type, List<int> shape) {
    if (type == TensorType.uint8) {
      return Uint8List.fromList(img.encodeJpg(image)).reshape(shape);
    } else {
      final inputBuffer = Float32List(shape[1] * shape[2] * shape[3]);
      var pixelIndex = 0;
      for (var y = 0; y < shape[1]; y++) {
        for (var x = 0; x < shape[2]; x++) {
          final pixel = image.getPixel(x, y);
          inputBuffer[pixelIndex++] = pixel.r / 255.0;
          inputBuffer[pixelIndex++] = pixel.g / 255.0;
          inputBuffer[pixelIndex++] = pixel.b / 255.0;
        }
      }
      return inputBuffer.reshape(shape);
    }
  }

  @override
  void dispose() {
    _interpreter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Doctor'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else if (_errorMessage.isNotEmpty)
                Text(_errorMessage, style: const TextStyle(color: Colors.red))
              else if (_image != null)
                Container(
                  height: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(_image!, fit: BoxFit.cover),
                  ),
                )
              else
                const Text('Select a plant image to diagnose',
                    style: TextStyle(fontSize: 18)),
              
              if (_prediction.isNotEmpty) ...[
                const SizedBox(height: 20),
                Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Diagnosis: $_prediction',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),                        
                      ],
                    ),
                  ),
                ),
              ],
              
              if (_showCureButton) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _navigateToCurePage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                  child: const Text(
                    'Get Cure',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        backgroundColor: Colors.green,
        tooltip: 'Pick Image',
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
    );
  }
}