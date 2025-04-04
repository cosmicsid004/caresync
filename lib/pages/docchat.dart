import 'package:flutter/material.dart';

class docchat extends StatefulWidget {
  const docchat({super.key});

  @override
  State<docchat> createState() => _docchatState();
}

class _docchatState extends State<docchat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doc Chat"),
      ),
    );
  }
}
