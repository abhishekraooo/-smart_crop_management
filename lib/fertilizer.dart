import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';


class FertilizerForm extends StatefulWidget {
  const FertilizerForm({super.key});

  @override
  _FertilizerFormState createState() => _FertilizerFormState();
}

class _FertilizerFormState extends State<FertilizerForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cropController = TextEditingController();
  final TextEditingController _farmSizeController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  String _previousCrop = '';
  String _previousFarmSize = '';
  String _previousMonth = '';
  String _previousYear = '';

  bool _isLoading = false;
  String _predictionResult = '';
  String _errorMessage = '';

  late FlutterTts flutterTts;
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.5);
  }

  Future<void> _speak() async {
    if (_predictionResult.isNotEmpty && !_isSpeaking) {
      _isSpeaking = true;
      await flutterTts.speak(_predictionResult);
      _isSpeaking = false;
    }
  }

  Future<void> _stopSpeaking() async {
    await flutterTts.stop();
    _isSpeaking = false;
  }

  @override
  void dispose() {
    _stopSpeaking();
    _cropController.dispose();
    _farmSizeController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _getFertilizerRecommendation() async {
    if (!_formKey.currentState!.validate()) return;

    if (_cropController.text == _previousCrop &&
        _farmSizeController.text == _previousFarmSize &&
        _monthController.text == _previousMonth &&
        _yearController.text == _previousYear) {
      setState(() {
        _errorMessage = 'Please change at least one value to get new recommendation';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _predictionResult = '';
    });

    _previousCrop = _cropController.text;
    _previousFarmSize = _farmSizeController.text;
    _previousMonth = _monthController.text;
    _previousYear = _yearController.text;

    try {
      const apiKey = 'ZF5C64BLHOnXbb985TQEoR3x9fr3dTWbap5DoKkX'; // Replace with your actual Cohere API key
      const endpoint = 'https://api.cohere.ai/v1/generate ';

      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'command',
          'prompt': '''
          Provide a single concise sentence recommending fertilizer for ${_cropController.text} 
          planted in month ${_monthController.text}, ${_yearController.text} 
          on ${_farmSizeController.text} hectares. 
          Just state the fertilizer type and amount per hectare.
          ''',
          'max_tokens': 50,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['generations'] != null && data['generations'].isNotEmpty) {
          setState(() {
            _predictionResult = data['generations'][0]['text'].trim();
          });
        } else {
          setState(() {
            _errorMessage = 'No recommendation received.';
          });
        }
      } else {
        setState(() {
          _errorMessage = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to connect to the service';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fertilizer Advisor'),
        actions: [
          if (_predictionResult.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: _speak,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _cropController,
                decoration: const InputDecoration(
                  labelText: 'Crop',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _farmSizeController,
                decoration: const InputDecoration(
                  labelText: 'Farm Size (hectares)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _monthController,
                      decoration: const InputDecoration(
                        labelText: 'Month',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _yearController,
                      decoration: const InputDecoration(
                        labelText: 'Year',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ElevatedButton(
                onPressed: _isLoading ? null : _getFertilizerRecommendation,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Get Recommendation'),
              ),
              const SizedBox(height: 24),
              if (_predictionResult.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text(
                          'Recommended Fertilizer:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(_predictionResult),
                        const SizedBox(height: 8),
                        IconButton(
                          icon: const Icon(Icons.volume_up),
                          onPressed: _speak,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}