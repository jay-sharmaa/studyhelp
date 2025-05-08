import 'dart:typed_data';

import 'package:flutter/material.dart';

class Algorithmpage extends StatefulWidget {
  final Uint8List image;
  const Algorithmpage({required this.image, super.key});

  @override
  State<Algorithmpage> createState() => _AlgorithmpageState();
}

class _AlgorithmpageState extends State<Algorithmpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Algorithm Flow',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Image.memory(widget.image)
    );
  }
}
