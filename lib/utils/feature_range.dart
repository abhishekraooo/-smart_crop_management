import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class FeatureRange {
  final String name;
  final double min;
  final double max;

  FeatureRange({required this.name, required this.min, required this.max});

  static Future<Map<String, FeatureRange>> loadRanges() async {
    final String jsonString = await rootBundle.loadString(
      'assets/ranges/feature_ranges.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    final Map<String, FeatureRange> ranges = {};
    jsonMap.forEach((key, value) {
      ranges[key] = FeatureRange(
        name: key,
        min: value['min'].toDouble(),
        max: value['max'].toDouble(),
      );
    });

    return ranges;
  }
}
