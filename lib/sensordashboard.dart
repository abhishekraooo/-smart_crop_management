import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SensorDashboard extends StatefulWidget {
  @override
  _SensorDashboardState createState() => _SensorDashboardState();
}

class _SensorDashboardState extends State<SensorDashboard> {
  String baseUrl = "http://192.168.137.44:5050"; // <- replace this!
  Map<String, dynamic> sensorData = {};
  Timer? timer;
  bool motorSwitch = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchSensorData();
    timer = Timer.periodic(Duration(seconds: 2), (_) => fetchSensorData());
  }

  Future<void> fetchSensorData() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/data"));
      if (response.statusCode == 200) {
        setState(() {
          sensorData = json.decode(response.body);
          motorSwitch = sensorData["motor_on"] ?? false;
        });
      }
    } catch (e) {
      print("Error fetching sensor data: $e");
    }
  }

  Future<void> toggleMotor(bool state) async {
    setState(() {
      loading = true;
    });
    try {
      final response = await http.get(Uri.parse(
          "$baseUrl/control-motor?state=${state ? 'on' : 'off'}"));
      if (response.statusCode == 200) {
        await fetchSensorData(); // refresh motor state
      }
    } catch (e) {
      print("Error toggling motor: $e");
    } finally {
      setState(() {
        loading = false;
        motorSwitch = state;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Widget buildSensorTile(String title, dynamic value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: ListTile(
        title: Text(title),
        subtitle: Text(value != null ? value.toString() : "Loading..."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Smart Agri Dashboard"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildSensorTile("Temperature (°C)", sensorData["temperature"]),
            buildSensorTile("Humidity (%)", sensorData["humidity"]),
            buildSensorTile("Soil Dry", sensorData["soil_dry"] == true ? "Yes" : "No"),
            buildSensorTile("Rain Detected", sensorData["rain_detected"] == true ? "Yes" : "No"),
            buildSensorTile("NPK LED Color", sensorData["led_color"]),
            buildSensorTile("Motor Status", sensorData["motor_on"] == true ? "ON" : "OFF"),
            SwitchListTile(
              title: Text("Manually Control Water Pump"),
              value: motorSwitch,
              onChanged: (val) {
                toggleMotor(val);
              },
            ),
            if (loading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}