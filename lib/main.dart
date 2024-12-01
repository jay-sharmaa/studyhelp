import 'package:flutter/material.dart';
import 'package:studyhelp/drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "StudyHelp",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
            
        },
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        child: const Icon(Icons.add)
      ),
      drawer: MyDrawer(),
    );
  }
}