import 'package:flutter/material.dart';
import 'package:studyhelp/drawer.dart';

class Gallerypdf extends StatefulWidget {
  const Gallerypdf({super.key});

  @override
  State<Gallerypdf> createState() => _GallerypdfState();
}

class _GallerypdfState extends State<Gallerypdf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("StudyHelp", style: TextStyle(fontSize: 24, color: Colors.white),),
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: (){

          }, 
          icon: const Icon(Icons.picture_as_pdf), color: Colors.red,)
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: MyDrawer(),
    );
  }
}