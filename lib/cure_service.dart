import 'dart:convert';
import 'package:http/http.dart' as http;

class CureService {
  static const String _apiKey = 'xTI22IQvnRin0yn2mXLoxDssV3WM0ih0cubmwMeh'; // Replace with your key
  static const String _baseUrl = 'https://api.cohere.ai/v1/generate';

  static Future<String> getCure(String disease) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
          'Cohere-Version': '2022-12-06',
        },
        body: jsonEncode({
          'model': 'command',
          'prompt': '''
As a plant pathologist, provide a comprehensive treatment plan for $disease. Include:
1. Disease overview (symptoms, causes)
2. Immediate treatment steps (organic & chemical)
3. Long-term management
4. Prevention strategies
5. When to consult an expert

Format with clear headings and bullet points.
          ''',
          'max_tokens': 400,
          'temperature': 0.5,
          'k': 0,
          'p': 0.75,
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return _formatResponse(jsonResponse['generations'][0]['text']);
      } else {
        throw 'API Error: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      throw 'Failed to get cure: $e';
    }
  }

  static String _formatResponse(String text) {
    // Clean up the API response
    return text
        .replaceAll('\n\n', '\n')
        .replaceAll(RegExp(r'^\s+'), '')
        .replaceAll(RegExp(r'\s+$'), '');
  }
}