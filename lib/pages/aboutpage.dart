import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'dart:ui';


class aboutpage extends StatefulWidget {
  const aboutpage({super.key});

  @override
  State<aboutpage> createState() => _aboutpageState();
}

class _aboutpageState extends State<aboutpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "About",
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),

      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 200, // You can adjust the height as needed
              child: Lottie.asset(
                'assets/about.json',
                repeat: true,
                animate: true,
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Why choose CareSync ??",
                  style: TextStyle(
                    fontSize: 35,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  "Because your health deserves smart support. HealthSync bridges the gap between technology and personal care, "
                      "making it easier to live healthier every day.",
                  style: TextStyle(
                    fontSize: 25
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
