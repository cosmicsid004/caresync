import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'dart:ui';

class TemperatureScreen extends StatefulWidget {
  const TemperatureScreen({super.key});

  @override
  State<TemperatureScreen> createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends State<TemperatureScreen> {
  double temperature = 0.0;
  int bpm = 0;
  Timer? timer;

  Future<void> fetchSensorData() async {
    final url = Uri.parse('http://10.10.185.65/sensor'); // Replace with your NodeMCU IP
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          temperature = data['temperature']?.toDouble() ?? 0.0;
          bpm = data['bpm'] ?? 0;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to connect: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSensorData();
    timer = Timer.periodic(Duration(seconds: 1), (_) => fetchSensorData());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green, // Basic green theme
        brightness: Brightness.dark,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Sensor Stats',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 1),
          ),
        ),
        body: Stack(
          children: [
            SizedBox.expand(
              child: Lottie.asset(
                'assets/background.json',
                fit: BoxFit.cover,
                repeat: true,
                animate: true,
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                // Higher values for smoothness
                child: Container(
                  color: Colors.white.withOpacity(
                    0.05,
                  ), // Less opacity for a cleaner look
                ),
              ),
            ),
            Center(
              child: Card(
                elevation: 20,
                color: Colors.grey.shade200,
                margin: EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        'assets/temp.json', // Make sure this file exists
                        height: 150,
                        repeat: true,
                        animate: true,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Temperature: ${temperature.toStringAsFixed(2)} °C',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      SizedBox(height: 30),
                      Lottie.asset(
                        'assets/heart.json', // Add this asset too
                        height: 120,
                        repeat: true,
                        animate: true,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Heart Rate: $bpm BPM',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
