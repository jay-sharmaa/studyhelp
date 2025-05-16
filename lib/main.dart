import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studyhelp/drawer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

final pdf = pw.Document();

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

List<String> text = [];

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final ImagePicker picker = ImagePicker();
  double endX = 370;
  double endY = 770;
  TextEditingController _controller = TextEditingController();
  List _file = [];

  List<String> storageKeys = [];
  String? selectedSubject;

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

  void _listOfFiles() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appPath = appDocDir.path;
    Directory appDir = Directory(appPath);

    if (appDir.existsSync()) {
      List<FileSystemEntity> files = appDir.listSync();
      setState(() {
        _file = files;
      });

      for (var file in files) {
        print("Found file: ${file.path}");
      }
    } else {
      print("Application storage folder not found!");
    }
  }

  Future<void> _processImage(List<File> files) async {
    for (int i = 0; i < files.length; i++) {
      final inputImage = InputImage.fromFile(files[i]);
      final textRecongnizer =
          TextRecognizer(script: TextRecognitionScript.latin);
      final RecognizedText recognizedText =
          await textRecongnizer.processImage(inputImage);
      List<TextBlock> extractedText = recognizedText.blocks;
      for (TextBlock block in extractedText) {
        String textIndex = "";
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            textIndex += element.text;
            textIndex += ' ';
          }
          textIndex += '\n';
        }
        text.add(textIndex);
      }
    }
  }

  Future<String?> getDownloadsPath() async {
    Directory? downloadsDir = Directory('/storage/emulated/0/Download');
    if (downloadsDir.existsSync()) {
      print("path");
      return downloadsDir.path;
    }
    return null;
  }

  void _createPDF(List<File> files, String fullPath) async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String fullFilePath = "${appDocDir.path}/$fullPath.pdf";

    final folderDir = Directory("${appDocDir.path}/${fullPath.split('/')[0]}");
    if (!(await folderDir.exists())) {
      await folderDir.create(recursive: true);
    }

    final pdf = pw.Document();
    for (File file in files) {
      final image = pw.MemoryImage(file.readAsBytesSync());
      pdf.addPage(pw.Page(
        build: (pw.Context context) => pw.Center(child: pw.Image(image)),
        pageFormat: PdfPageFormat.a4,
      ));
    }

    final outputFile = File(fullFilePath);
    await outputFile.writeAsBytes(await pdf.save());
    print("✅ PDF saved to: $fullFilePath");
  }

  Future<void> _loadFoldersFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> folders = [];
    int index = 1;

    while (true) {
      String? value = prefs.getString(index.toString());
      if (value == null) break;
      folders.add(value);
      index++;
    }

    setState(() {
      storageKeys = folders;
    });
  }

  List<File> imageFile = [];
  int? toChange;
  var set = 0;
  @override
  void dispose() {
    _controllerRotate.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _listOfFiles();
    _loadFoldersFromPrefs();
    super.initState();
  }

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
                    } else {
                      setState(() {});
                      _processImage(imageFile);
                    }
                    break;
                  case 'pdf':
                    if (imageFile.isEmpty) {
                      showSnackBar(context, 'Select At least 1 Image');
                    } else {
                      _loadFoldersFromPrefs();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: const Text(
                                    "Select Subject & Enter File Name"),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    DropdownButtonFormField<String>(
                                      value: selectedSubject,
                                      items: storageKeys
                                          .map((subject) => DropdownMenuItem(
                                                value: subject,
                                                child: Text(subject),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          selectedSubject = value;
                                        });
                                      },
                                      hint: const Text("Select Subject"),
                                    ),
                                    const SizedBox(height: 10),
                                    TextField(
                                      controller: _controller,
                                      decoration: const InputDecoration(
                                          hintText: "File Name"),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      if (_controller.text.trim().isEmpty) {
                                        showSnackBar(context,
                                            "File Name Cannot Be Empty");
                                      } else if (selectedSubject == null) {
                                        showSnackBar(
                                            context, "Please Select a Subject");
                                      } else {
                                        String fullPath =
                                            "$selectedSubject/${_controller.text.trim()}";
                                        _createPDF(imageFile, fullPath);
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text("Save"),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      );
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
              setState(() {
                _listOfFiles();
              });
              if (set == 0) {
                setState(() {});
                _controllerRotate.forward(from: 0);
                endY = 680;
                endX = 280;
                set = 1;
              } else {
                setState(() {});
                resetToOriginalPosition();
                endY = 770;
                endX = 360;
                set = 0;
              }
            },
            backgroundColor: const Color.fromARGB(255, 255, 0, 0),
            child: RotationTransition(
              turns: _animationRotate,
              child: const Icon(Icons.add, color: Colors.black),
            )),
        drawer: const MyDrawer(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: mainScreen())
            ],
          ),
        ));
  }

  Widget mainScreen() {
    return Stack(
      children: [
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
              left: 360,
              top: value,
              child: GestureDetector(
                  onTap: () async {
                    final image =
                        await picker.pickImage(source: ImageSource.camera);
                    resetToOriginalPosition();
                    endY = 900;
                    endX = 380;
                    set = 0;
                    setState(() {});
                    if (image == null) return;
                    imageFile.add(File(image.path));
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
              top: 770,
              child: GestureDetector(
                onTap: () async {
                  final List<XFile> image = await picker.pickMultiImage();
                  resetToOriginalPosition();
                  endY = 900;
                  endX = 360;
                  set = 0;
                  setState(() {});
                  if (image.isEmpty) return;
                  for (int i = 0; i < image.length; i++) {
                    imageFile.add(File(image[i].path));
                  }
                },
                child: iconContainer(Icons.file_open),
              ),
            );
          },
          child: iconContainer(Icons.file_open),
        ),
      ],
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
