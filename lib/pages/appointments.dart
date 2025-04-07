import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'dart:ui';

void main() {
  runApp(const appointments());
}

class appointments extends StatelessWidget {
  const appointments({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medical Test Scheduler',
      theme: ThemeData(
        primarySwatch: Colors.green, // Basic green theme
        brightness: Brightness.dark,
      ),
      home: const MedicalTestPage(),
    );
  }
}

class MedicalTestPage extends StatefulWidget {
  const MedicalTestPage({super.key});

  @override
  State<MedicalTestPage> createState() => _MedicalTestPageState();
}

class _MedicalTestPageState extends State<MedicalTestPage> {
  final List<String> _tests = [
    'Blood Test',
    'X-Ray',
    'MRI',
    'CT Scan',
    'ECG',
  ];
  String? _selectedTest;
  TimeOfDay? _selectedTime;

  Future<void> _pickTime() async {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  Future<void> _sendData() async {
    if (_selectedTest == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both test and time.')),
      );
      return;
    }

    final url = Uri.parse('http://10.10.156.39:5000/receive'); // change this
    final response = await http.post(
      url,
      body: {
        'test': _selectedTest!,
        'time': _selectedTime!.format(context),
      },
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data sent successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send data.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Medical Test', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 2),)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 500,
                  height: 600,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xAAFFF2FF),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.grey,),
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Medical Test',
                                labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                              ),
                              value: _selectedTest,
                              style: const TextStyle(color: Colors.white, fontSize: 16), // <- Selected text color
                              items: _tests.map((test) {
                                return DropdownMenuItem(
                                  value: test,
                                  child: Text(
                                    test,
                                    style: const TextStyle(color: Colors.white), // <- Dropdown items color
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) => setState(() => _selectedTest = value),
                            ),
                          ),

                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Text('Time:', style: TextStyle(fontSize: 18, color: Colors.black),),
                              const SizedBox(width: 10),
                              Text(_selectedTime != null
                                  ? _selectedTime!.format(context)
                                  : 'No time selected', style: TextStyle(fontSize: 18, color: Colors.black)),
                              const Spacer(),
                              ElevatedButton(
                                onPressed: _pickTime,
                                child: const Text('Pick Time', style: TextStyle(fontSize: 18), ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: _sendData,
                            child: const Text('Book', style: TextStyle(fontSize: 18), ),
                          ),
                        ],
                      ),
                    ),
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