import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
  List<File> imagefile = [];
  int? toChange;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home", style: TextStyle(fontSize: 24, color: Colors.white),),
        backgroundColor: Colors.black,
        actions: [
          IconButton(onPressed: (){
            if(imagefile.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Select Images First"), dismissDirection: DismissDirection.horizontal,)
              );
            }
          }, 
          icon: const Icon(Icons.picture_as_pdf), color: Colors.red,)
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
            final ImagePicker picker = ImagePicker();
            final List<XFile> image = await picker.pickMultiImage();
            for(var img in image){
              imagefile.add(File(img.path));
            }
            setState(() {
              
            });
        },
        backgroundColor: const Color.fromARGB(255, 255, 0, 0),
        child: const Icon(Icons.add)
      ),
      drawer: const MyDrawer(),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), 
        itemBuilder: (context, index){
          return GestureDetector(
            child: Card(
              color: toChange == index? Color.fromARGB(45, 0, 255, 0) : Colors.transparent,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  GestureDetector(child: Center(child: Image.file(imagefile[index])), onTap: (){
                    if(toChange != null){
                      File? temp = imagefile[index];
                      imagefile[index] = imagefile[toChange!];
                      imagefile[toChange!] = temp;
                      toChange = null;
                    }
                    else{
                      toChange = index;
                    }
                    setState(() {
                      
                    });
                  },),
                  IconButton(onPressed: (){
                    imagefile.removeAt(index);
                    setState(() {
                      
                    });
                  }, icon: const Icon(Icons.remove_circle))
                ]
              )
            ),
            onLongPress: (){
              showDialog(context: context, builder: (context){
                return Dialog.fullscreen(
                  backgroundColor: Colors.transparent,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Center(child: Image.file(imagefile[index], width: 350, height: 400,)), 
                      IconButton(onPressed: (){
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.arrow_back, color: Colors.white,))
                  ]),
                );
              });
            },
          );
        },
        itemCount: imagefile.length,
      ),
    );
  }
}
