import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:lottie/lottie.dart';

class skinanalysis extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ImagePickerDemo(),
    );
  }
}

class ImagePickerDemo extends StatefulWidget {
  @override
  _ImagePickerDemoState createState() => _ImagePickerDemoState();
}

class _ImagePickerDemoState extends State<ImagePickerDemo> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  File? file;
  var _recognitions;
  var v = "";
  // var dataList = [];
  @override
  void initState() {
    super.initState();
    loadmodel().then((value) {
      setState(() {});
    });
  }

  loadmodel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        file = File(image!.path);
      });
      detectimage(file!);
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future detectimage(File image) async {
    int startTime = new DateTime.now().millisecondsSinceEpoch;
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 6,
      threshold: 0.05,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _recognitions = recognitions;
      v = recognitions.toString();
      // dataList = List<Map<String, dynamic>>.from(jsonDecode(v));
    });
    print("//////////////////////////////////////////////////");
    print(_recognitions);
    // print(dataList);
    print("//////////////////////////////////////////////////");
    int endTime = new DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime}ms");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skin Analyser',style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 2)),
      ),
      body: Stack(
        children: [

          SizedBox.expand(
            child: Lottie.asset(
              'assets/skin_background.json',
              fit: BoxFit.cover,
              repeat: true,
              animate: true,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100), // Higher values for smoothness
              child: Container(
                color: Colors.white.withOpacity(0.05), // Less opacity for a cleaner look
              ),
            ),
          ),

          Center(
          child: SizedBox(
            height: 500,
            width: 400,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  if (_image != null)
                    Image.file(
                      File(_image!.path),
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    )
                  else
                    Text('No image selected'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Pick Image from Gallery'),
                  ),
                  SizedBox(height: 20),
                  if (_recognitions != null)
                    ..._recognitions!.map<Widget>((rec) {
                      return Text(
                        rec['label'],
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      );
                    }).toList()
                  else
                    Text('No analysis result'),
                ],
              ),
            ),
          ),
        ),
        ]
      )
    );
  }
}