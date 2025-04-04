import 'dart:convert';
import 'dart:async'; // Import timer
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart'; // Import Lottie

class sensor extends StatefulWidget {
  const sensor({super.key});

  @override
  State<sensor> createState() => _sensorState();
}

class _sensorState extends State<sensor> {

  double pulse = 0.0;
  Timer? timer;

  Future<void> fetchSensorData() async {
    final url = Uri.parse('http://192.168.1.108/sensor'); // Replace with actual IP
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          pulse = data['pulse'];
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
    fetchSensorData(); // Fetch data immediately
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => fetchSensorData()); // Auto-refresh every second
  }

  @override
  void dispose() {
    timer?.cancel(); // Stop timer when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Heart Rate Monitor')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(width: 20, height: 40,),

                Card(
                  elevation: 20,
                  color: Colors.grey,
                  child: Padding(
                      padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Lottie Animation
                        Lottie.asset(
                          'assets/heart.json', // Ensure the JSON file exists in assets
                          height: 200,
                          repeat: true,
                          animate: true,
                        ),
                        SizedBox(height: 20),
                        // Sensor Data Display
                        Text(
                          'Pulse: ${pulse.toStringAsFixed(2)} BPM',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),

                Card(
                  elevation: 20,
                  color: Colors.grey,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Lottie Animation
                        Lottie.asset(
                          'assets/heart.json', // Ensure the JSON file exists in assets
                          height: 200,
                          repeat: true,
                          animate: true,
                        ),
                        SizedBox(height: 20),
                        // Sensor Data Display
                        Text(
                          'Pulse: ${pulse.toStringAsFixed(2)}%',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),

                Card(
                  elevation: 20,
                  color: Colors.grey,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Lottie Animation
                        Lottie.asset(
                          'assets/heart.json', // Ensure the JSON file exists in assets
                          height: 200,
                          repeat: true,
                          animate: true,
                        ),
                        SizedBox(height: 20),
                        // Sensor Data Display
                        Text(
                          'Pulse: ${pulse.toStringAsFixed(2)}%',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
