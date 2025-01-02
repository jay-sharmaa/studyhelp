import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
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

String text = "";

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final platform = const MethodChannel('images_from_flutter');
  final ImagePicker picker = ImagePicker();
  double endX = 340;
  double endY = 715;

  late final AnimationController _controllerRotate = AnimationController(
    upperBound: 0.13,
    duration: const Duration(milliseconds: 250),
    vsync: this,
  );

  late final Animation<double> _animationRotate = CurvedAnimation(
    parent: _controllerRotate,
    curve: Curves.linear,
  );

  void resetToOriginalPosition() {
    _controllerRotate.animateTo(0.0,
        duration: const Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    _controllerRotate.dispose();
    super.dispose();
  }

  void sendData(dynamic data) async {
    await platform.invokeMethod('receive_data', data);
  }

  Future<void> _processImage(File file) async {
    final inputImage = InputImage.fromFile(file);
    final textRecongnizer = TextRecognizer();
    final RecognizedText recognizedText =
        await textRecongnizer.processImage(inputImage);
    List<TextBlock> extractedText = recognizedText.blocks;
    for (TextBlock block in extractedText) {
      for (TextLine line in block.lines) {
        for(TextElement element in line.elements){
          text += element.text;
          text += ' ';
        }
        text += '\n';
      }
    }
  }

  List<File> imageFile = [];
  Map<int, Uint8List> imageInByte = {};
  int? toChange;
  var set = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Home",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'image_text',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.text_fields_outlined, color: Colors.red),
                    SizedBox(width: 10),
                    Text('Image/Text', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'pdf',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.red),
                    SizedBox(width: 10),
                    Text('PDF', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            ],
            onSelected: (String value) {
              switch (value) {
                case 'image_text':
                  if (imageFile.isEmpty) {
                    showSnackBar(context, 'Select At least 1 Image');
                  } else if (imageFile.length > 1) {
                    showSnackBar(context, 'Select 1 Image Only');
                  } else {
                    setState(() {
                      
                    });
                    _processImage(imageFile[0]);
                  }
                  break;
                case 'pdf':
                  if (imageFile.isEmpty) {
                    showSnackBar(context, 'Select At least 1 Image');
                  } else {
                    sendData(imageInByte);
                  }
                  break;
              }
            },
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (set == 0) {
              setState(() {});
              _controllerRotate.forward(from: 0);
              endY = 655;
              endX = 280;
              set = 1;
            } else {
              setState(() {});
              resetToOriginalPosition();
              endY = 715;
              endX = 340;
              set = 0;
            }
          },
          backgroundColor: const Color.fromARGB(255, 255, 0, 0),
          child: RotationTransition(
            turns: _animationRotate,
            child: const Icon(Icons.add, color: Colors.black),
          )),
      drawer: const MyDrawer(),
      body: Stack(children: [
        Text(text),
        GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3),
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Card(
                  color: toChange == index
                      ? const Color.fromARGB(45, 0, 255, 0)
                      : Colors.transparent,
                  child: Stack(alignment: Alignment.topRight, children: [
                    GestureDetector(
                      child: Center(child: Image.file(imageFile[index])),
                      onTap: () {
                        if (toChange != null) {
                          File? temp = imageFile[index];
                          imageFile[index] = imageFile[toChange!];
                          imageFile[toChange!] = temp;
                          toChange = null;
                        } else {
                          toChange = index;
                        }
                        setState(() {});
                      },
                    ),
                    IconButton(
                        onPressed: () {
                          imageFile.removeAt(index);
                          setState(() {});
                        },
                        icon: const Icon(Icons.remove_circle))
                  ])),
              onLongPress: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog.fullscreen(
                        backgroundColor: Colors.transparent,
                        child: Stack(alignment: Alignment.topRight, children: [
                          Center(
                              child: Image.file(
                            imageFile[index],
                            width: 350,
                            height: 400,
                          )),
                          IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ))
                        ]),
                      );
                    });
              },
            );
          },
          itemCount: imageFile.length,
        ),
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 715.0, end: endY),
          duration: const Duration(milliseconds: 250),
          builder: (BuildContext context, double value, Widget? child) {
            return Positioned(
              left: 340,
              top: value,
              child: GestureDetector(
                  onTap: () async {
                    final image =
                        await picker.pickImage(source: ImageSource.camera);
                    if (image == null) return;
                    imageFile.add(File(image.path));
                    setState(() {});
                  },
                  child: iconContainer(Icons.camera_alt)),
            );
          },
          child: iconContainer(Icons.camera_alt),
        ),
        TweenAnimationBuilder(
          tween: Tween<double>(begin: 340.0, end: endX),
          duration: const Duration(milliseconds: 250),
          builder: (BuildContext context, double value, Widget? child) {
            return Positioned(
                left: value,
                top: 715,
                child: GestureDetector(
                    onTap: () async {
                      final List<XFile> image = await picker.pickMultiImage();
                      if (image.isEmpty) return;
                      for (int i = 0; i < image.length; i++) {
                        imageFile.add(File(image[i].path));
                        var img_in_byte = await image[i].readAsBytes();
                        imageInByte[i] = img_in_byte;
                      }
                      setState(() {});
                    },
                    child: iconContainer(Icons.file_open)));
          },
          child: iconContainer(Icons.file_open),
        ),
      ]),
    );
  }
}

Widget iconContainer(IconData icon) {
  return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.red.shade600, borderRadius: BorderRadius.circular(25)),
      child: Icon(icon));
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
