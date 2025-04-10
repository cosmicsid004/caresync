import 'dart:ui';

import 'package:caresync/pages/aboutpage.dart';
import 'package:caresync/pages/appointments.dart';
import 'package:caresync/pages/mood.dart';
import 'package:caresync/pages/sensor.dart';
import 'package:caresync/pages/skinanalysis.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldKey.currentState?.openDrawer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // Assign the key to Scaffold
      appBar: AppBar(
        title: const Text("CareSync", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 2)),
      ),

      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              leading: Icon(Icons.house_outlined, color: Colors.green.shade700),
              title: const Text('HOME'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.auto_graph, color: Colors.green.shade700),
              title: const Text('SENSOR DATA'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TemperatureScreen()),
                  ),
            ),
            ListTile(
              leading: Icon(
                Icons.local_hospital_outlined,
                color: Colors.green.shade700,
              ),
              title: const Text('SKIN ANALYSER'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => skinanalysis()),
                  ),
            ),
            ListTile(
              leading: Icon(
                Icons.notification_add_outlined,
                color: Colors.green.shade700,
              ),
              title: const Text('REMINDERS'),
              onTap:
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReminderNotePage()),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.science_outlined,
                color: Colors.green.shade700,
              ),
              title: const Text('APPOINTMENTS'),
              onTap:
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => appointments()),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.help_center_outlined,
                color: Colors.green.shade700,
              ),
              title: const Text('ABOUT'),
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => aboutpage()),
                  ),
            ),
          ],
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
            child: SizedBox(
              child: Lottie.asset(
                'assets/doctor.json',
                fit: BoxFit.cover,
                repeat: true,
                animate: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
