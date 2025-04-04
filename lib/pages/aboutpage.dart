import 'package:flutter/material.dart';

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
        title: Text("About"),
      ),
    );
  }
}
