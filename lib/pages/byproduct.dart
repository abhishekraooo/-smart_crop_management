import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ByProductScreen extends StatefulWidget {
  const ByProductScreen({super.key});

  @override
  _ByProductScreenState createState() => _ByProductScreenState();
}

class _ByProductScreenState extends State<ByProductScreen> {
  final TextEditingController _cropController = TextEditingController();
  List<String> byproducts = [];
  bool _isLoading = false;
  String _errorMessage = '';

  // Hardcoded Cohere API Key (replace with your actual API key)
  final String _cohereApiKey = 'VG03XZkdjlAsRNBnwL79i1LLrG4rByxSoHrxqCTX';

  Future<void> _fetchByproducts(String cropName) async {
    setState(() {
      _isLoading = true;
      byproducts.clear();
      _errorMessage = '';
    });

    try {
      String prompt = """
      Based on the crop "$cropName", what are 5-6 common byproducts derived from it? 
      Please provide a concise list of byproducts without explanations.
      
      Example Response:
      - Byproduct 1
      - Byproduct 2
      - Byproduct 3
      ...
      """;

      final response = await http.post(
        Uri.parse('https://api.cohere.ai/v1/generate'),
        headers: {
          'Authorization': 'Bearer $_cohereApiKey',
          'Content-Type': 'application/json',
          'Cohere-Version': '2022-12-06',
        },
        body: jsonEncode({
          'model': 'command',
          'prompt': prompt,
          'max_tokens': 100,
          'temperature': 0.7,
          'k': 0,
          'stop_sequences': [],
          'return_likelihoods': 'NONE',
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        String textResponse = jsonResponse['generations'][0]['text'];

        // Parse the response into a list of byproducts
        List<String> parsedByproducts = textResponse
            .split('\n') // Split by new lines
            .where((line) => line.trim().isNotEmpty) // Remove empty lines
            .map((line) => line.replaceAll(RegExp(r'^- '), '').trim()) // Remove bullet points
            .toList();

        setState(() {
          byproducts = parsedByproducts;
        });
      } else {
        throw Exception('Failed to fetch byproducts: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToDetailsPage(String byproduct) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ByProductDetailsScreen(byproduct: byproduct),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Byproducts Finder'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cropController,
              decoration: InputDecoration(
                labelText: 'Enter Crop Name and Press Enter',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                if (_cropController.text.isNotEmpty) {
                  _fetchByproducts(_cropController.text);
                }
              },
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_errorMessage.isNotEmpty)
              Center(
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (byproducts.isEmpty)
              const Center(
                child: Text('No byproducts found.'),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: byproducts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(byproducts[index]),
                        onTap: () => _navigateToDetailsPage(byproducts[index]),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Full Page for Byproduct Details
class ByProductDetailsScreen extends StatelessWidget {
  final String byproduct;

  const ByProductDetailsScreen({super.key, required this.byproduct});

  Future<Map<String, dynamic>> _fetchByproductDetails() async {
    try {
      String prompt = """
      Provide detailed information about the byproduct "$byproduct". 
      Include the following in bullet points:
      - Current Market Rate (in USD per unit): [value]
      - Cost of Making (in USD per unit): [value]
      - Conditions Required:
        * Temperature: [value]
        * Humidity: [value]
        * Equipment: [value]

      Example Response:
      - Current Market Rate: \$50 per ton
      - Cost of Making: \$30 per ton
      - Conditions Required:
        * Temperature: 25°C to 30°C
        * Humidity: 50% to 60%
        * Equipment: Dryer, Grinder
      """;

      final response = await http.post(
        Uri.parse('https://api.cohere.ai/v1/generate'),
        headers: {
          'Authorization': 'Bearer VG03XZkdjlAsRNBnwL79i1LLrG4rByxSoHrxqCTX',
          'Content-Type': 'application/json',
          'Cohere-Version': '2022-12-06',
        },
        body: jsonEncode({
          'model': 'command',
          'prompt': prompt,
          'max_tokens': 200,
          'temperature': 0.7,
          'k': 0,
          'stop_sequences': [],
          'return_likelihoods': 'NONE',
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('API Response: ${jsonResponse['generations'][0]['text']}'); // Log the response
        String textResponse = jsonResponse['generations'][0]['text'].trim();

        // Parse the response into structured data
        Map<String, dynamic> details = {};
        List<String> lines = textResponse.split('\n');
        for (String line in lines) {
          line = line.trim(); // Remove leading/trailing spaces
          if (line.startsWith('-')) {
            List<String> parts = line.split(':');
            if (parts.length > 1) {
              String key = parts[0].replaceAll('-', '').trim();
              String value = parts.sublist(1).join(':').trim(); // Handle values with colons
              details[key] = value;
            } else if (line.trim().startsWith('*')) {
              if (!details.containsKey('Conditions Required')) {
                details['Conditions Required'] = [];
              }
              details['Conditions Required'].add(line.replaceAll('*', '').trim());
            }
          }
        }

        // Add fallback data if any field is missing
        if (!details.containsKey('Current Market Rate')) {
          details['Current Market Rate'] = '\$50 per ton (example)';
        }
        if (!details.containsKey('Cost of Making')) {
          details['Cost of Making'] = '\$30 per ton (example)';
        }
        if (!details.containsKey('Conditions Required')) {
          details['Conditions Required'] = [
            'Temperature: 25°C to 30°C ',
            'Humidity: 50% to 60% ',
            'Equipment: Dryer, Grinder ',
          ];
        }

        return details;
      } else {
        throw Exception('Failed to fetch byproduct details: ${response.statusCode}');
      }
    } catch (e) {
      return {
        'Error': e.toString(),
        'Current Market Rate': '\$50 per ton (fallback)',
        'Cost of Making': '\$30 per ton (fallback)',
        'Conditions Required': [
          'Temperature: 25°C to 30°C ',
          'Humidity: 50% to 60%',
        'Equipment: Dryer, Grinder 2d d ffr   ',
        ],
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(byproduct),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchByproductDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            Map<String, dynamic> details = snapshot.data ?? {};
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Market Rate:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(details['Current Market Rate'] ?? 'Not available'),
                    const SizedBox(height: 10),
                    Text(
                      'Cost of Making:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(details['Cost of Making'] ?? 'Not available'),
                    const SizedBox(height: 10),
                    Text(
                      'Conditions Required:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (details.containsKey('Conditions Required'))
                      ...List.generate(
                        (details['Conditions Required'] as List<dynamic>).length,
                        (index) => Text(
                          '- ${(details['Conditions Required'] as List<dynamic>)[index]}',
                        ),
                      )
                    else
                      const Text('Not available'),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}