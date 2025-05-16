import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const FertilizerApp());
}

class FertilizerApp extends StatelessWidget {
  const FertilizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fertilizer Advisor',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const FertilizerForm(),
    );
  }
}

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

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _initializeTts();
    _loadPreviousSelections();
  }

  Future<void> _initializeTts() async {
    await flutterTts.setLanguage('en-US');
    await flutterTts.setSpeechRate(0.5);
  }

  Future<void> _speak() async {
    if (_predictionResult.isNotEmpty) {
      await flutterTts.speak(_predictionResult);
    }
  }

  Future<void> _loadPreviousSelections() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _cropController.text = prefs.getString('last_crop') ?? '';
      _farmSizeController.text = prefs.getString('last_farm_size') ?? '';
      _monthController.text = prefs.getString('last_month') ?? '';
      _yearController.text = prefs.getString('last_year') ?? '';
    });
  }

  Future<void> _saveToHistory(String recommendation) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList('recommendations') ?? [];
    history.insert(0, recommendation);
    await prefs.setStringList('recommendations', history);
    await prefs.setString('last_crop', _cropController.text);
    await prefs.setString('last_farm_size', _farmSizeController.text);
    await prefs.setString('last_month', _monthController.text);
    await prefs.setString('last_year', _yearController.text);
  }

  Future<List<String>> _getHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('recommendations') ?? [];
  }

  @override
  void dispose() {
    flutterTts.stop();
    _cropController.dispose();
    _farmSizeController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _getFertilizerRecommendation() async {
    if (!_formKey.currentState!.validate()) return;

    // Prevent duplicate API call
    if ((_cropController.text == _previousCrop &&
        _farmSizeController.text == _previousFarmSize &&
        _monthController.text == _previousMonth &&
        _yearController.text == _previousYear)) {
      setState(() {
        _errorMessage = 'Please change at least one value.';
      });
      return;
    }

    final now = DateTime.now();
    int currentYear = now.year;
    int currentMonth = now.month;

    int? inputMonth = int.tryParse(_monthController.text);
    int? inputYear = int.tryParse(_yearController.text);

    if (inputMonth == null || inputMonth < 1 || inputMonth > 12) {
      setState(() {
        _errorMessage = 'Enter a valid month (1–12)';
      });
      return;
    }

    if (inputYear == null || inputYear < 1900 || inputYear > currentYear) {
      setState(() {
        _errorMessage = 'Enter a valid year (not in the future)';
      });
      return;
    }

    if (inputYear == currentYear && inputMonth > currentMonth) {
      setState(() {
        _errorMessage = 'Cannot select a future month in the current year.';
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
      const apiKey = 'ZF5C64BLHOnXbb985TQEoR3x9fr3dTWbap5DoKkX'; // Replace with your Cohere key
      const endpoint = 'https://api.cohere.ai/v1/generate';

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
          'max_tokens': 130,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['generations'] != null && data['generations'].isNotEmpty) {
          setState(() {
            _predictionResult = data['generations'][0]['text'].trim();
          });
          _saveToHistory(_predictionResult);
        } else {
          setState(() {
            _errorMessage = 'No recommendation received.';
          });
        }
      } else {
        setState(() {
          _errorMessage =
              'API Error: ${response.statusCode}\n${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to connect: $e';
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
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () async {
              final history = await _getHistory();
              if (history.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No history found.')),
                );
                return;
              }
              showModalBottomSheet(
                context: context,
                builder: (_) {
                  return SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(history[index]),
                        );
                      },
                    ),
                  );
                },
              );
            },
          ),
          if (_predictionResult.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: _speak,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _cropController,
                          decoration: InputDecoration(
                            labelText: 'Crop Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _farmSizeController,
                          decoration: InputDecoration(
                            labelText: 'Farm Size (hectares)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _monthController,
                                decoration: InputDecoration(
                                  labelText: 'Month',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    value?.isEmpty ?? true ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _yearController,
                                decoration: InputDecoration(
                                  labelText: 'Year',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) =>
                                    value?.isEmpty ?? true ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.green,
                  ),
                  onPressed: _isLoading ? null : _getFertilizerRecommendation,
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const Text(
                          'Recommend',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(height: 20),
                if (_predictionResult.isNotEmpty)
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Recommended Fertilizer:',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _predictionResult,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(Icons.volume_up),
                              onPressed: _speak,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}