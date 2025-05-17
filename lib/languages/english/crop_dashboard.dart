import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  String? _location;
  double? _temperature;
  int? _humidity;
  String? _condition;

  bool _isLoading = false;
  String? _error;

  @override
  bool get wantKeepAlive => true;

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Prevent reloading when navigating back
    if (_location != null && _temperature != null) {
      return;
    }
    _fetchLocationAndWeather();
  }

  final String _openWeatherApiKey =
      'e227b5cc1d93809394d60d8db9aba89e'; // Replace with your actual key

  @override
  void initState() {
    super.initState();
    _fetchLocationAndWeather();
  }

  Future<void> _fetchLocationAndWeather() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      Position position = await _determinePosition();
      debugPrint('Position: ${position.latitude}, ${position.longitude}');

      String cityName = await _reverseGeocode(
        position.latitude,
        position.longitude,
      );
      debugPrint('City: $cityName');

      final weatherData = await _fetchWeatherData(
        position.latitude,
        position.longitude,
      );
      debugPrint('Weather: $weatherData');

      setState(() {
        _location = cityName;
        _temperature = weatherData['temp'];
        _humidity = weatherData['humidity'];
        _condition = weatherData['condition'];
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        _isLoading = false;
        _error = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load weather: ${e.toString()}')),
      );
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Please enable location services';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied, please enable them in app settings';
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );
  }

  Future<String> _reverseGeocode(double latitude, double longitude) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=$latitude&lon=$longitude',
        ),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        debugPrint('Reverse geocode response: $decoded');

        // Try different address fields
        final address = decoded['address'];
        return address['city'] ??
            address['town'] ??
            address['village'] ??
            address['county'] ??
            'Unknown location';
      } else {
        throw 'Failed to reverse geocode: ${response.statusCode}';
      }
    } catch (e) {
      debugPrint('Reverse geocode error: $e');
      return 'Unknown location';
    }
  }

  Future<Map<String, dynamic>> _fetchWeatherData(
    double latitude,
    double longitude,
  ) async {
    try {
      final url =
          'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$_openWeatherApiKey&units=metric';
      debugPrint('Weather API URL: $url');

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        debugPrint('Weather response: $decoded');

        return {
          'temp': decoded['main']['temp'],
          'humidity': decoded['main']['humidity'],
          'condition': decoded['weather'][0]['main'],
        };
      } else {
        throw 'Failed to fetch weather: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      debugPrint('Weather API error: $e');
      throw 'Failed to fetch weather data: $e';
    }
  }

  IconData _getWeatherIcon(String? condition) {
    if (condition == null) return Icons.cloud_queue;
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.water_drop;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.cloud_queue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("AgriHack", style: TextStyle(color: Colors.green.shade900)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Weather Info Row - Icons Only
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Location Icon + Value
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.green.shade800),
                      const SizedBox(width: 4),
                      SizedBox(
                        width: 80,
                        child: Text(
                          _location ?? 'Loading...',
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 8),

                  // Temperature Icon + Value
                  Row(
                    children: [
                      Icon(Icons.thermostat, color: Colors.red.shade800),
                      const SizedBox(width: 4),
                      Text(
                        _temperature != null
                            ? "${_temperature!.toStringAsFixed(1)}°C"
                            : "--",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(width: 8),

                  // Humidity Icon + Value
                  Row(
                    children: [
                      Icon(Icons.water_drop, color: Colors.blue.shade800),
                      const SizedBox(width: 4),
                      Text(
                        _humidity != null ? "$_humidity%" : "--%",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(width: 8),

                  // Condition Icon
                  Icon(
                    _getWeatherIcon(_condition),
                    color: Colors.orange.shade800,
                  ),

                  const SizedBox(width: 8),

                  // Refresh Button
                  _isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                      : IconButton(
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.blue.shade600,
                          size: 20,
                        ),
                        onPressed: _fetchLocationAndWeather,
                      ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Debug information
            if (_error != null)
              Text('Error: $_error', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
