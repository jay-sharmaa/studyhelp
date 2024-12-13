import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:studyhelp/drawer.dart';
import 'dart:ui' as ui;

class Imagetext extends StatefulWidget {
  const Imagetext({super.key});

  @override
  State<Imagetext> createState() => _ImagetextState();
}

GlobalKey frontScreen = GlobalKey();

List<Uint8List> screenshot = [];

class _ImagetextState extends State<Imagetext> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image To Text", style: TextStyle(fontSize: 24, color: Colors.white),),
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: (){

          }, 
          icon: const Icon(Icons.picture_as_pdf), color: Colors.red,)
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          RepaintBoundary(
            key: frontScreen,
            child: TextButton(onPressed: () async{
              takeScreenShot();
              setState(() {
                
              });
            }, child: Text("Take screenshot")),
          ),
          Center(child: ElevatedButton(onPressed: (){}, child: const Text("Press Me")),),
          if(screenshot.isNotEmpty)
          Image.memory(screenshot[0])
        ],
      ),
      drawer: const MyDrawer(),
    );
  }
}

takeScreenShot() async {
  RenderRepaintBoundary boundary = 
    frontScreen.currentContext!.findRenderObject() as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage();
  ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  Uint8List pngBytes = byteData!.buffer.asUint8List();
  screenshot.add(pngBytes);
  screenshot.forEach(print);
}