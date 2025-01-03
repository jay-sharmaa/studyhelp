import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studyhelp/drawer.dart';
import 'package:studyhelp/main.dart';

class Imagetext extends StatefulWidget {
  const Imagetext({super.key});

  @override
  State<Imagetext> createState() => _ImagetextState();
}

class _ImagetextState extends State<Imagetext> {
  List<TextEditingController> _textEditingController = [];
  TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    _initializeControlers();
    super.initState();
  }

  void _initializeControlers() {
    for (int i = 0; i < text.length; i++) {
      _textEditingController.add(TextEditingController(text: text[i]));
    }
  }

  void _createPDF(List<String> pages, String fileName) async {
    final Directory? _directory = await getDownloadsDirectory();
    for (int i = 0; i < pages.length; i++) {
      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            child: pw.Text(pages[i], style: pw.TextStyle(fontSize: 10)),
          );
        },
        pageFormat: PdfPageFormat.a4,
      ));
    }

    final file = File("${_directory!.path}/$fileName.pdf");
    try {
      await file.writeAsBytes(await pdf.save());
    } on Exception catch (_) {
      showSnackBar(context, "File With This Name Exists In This Location");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Image To Text",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("File Name"),
                      content: TextField(
                        controller: _controller,
                      ),
                      actions: [
                        GestureDetector(
                            onTap: () {
                              if (_controller.text != "") {
                                _createPDF(text, _controller.text);
                                _controller.dispose();
                                Navigator.pop(context);
                              } else {
                                showSnackBar(
                                    context, "File Name Cannot Be Empty");
                              }
                            },
                            child: const Text("Save"))
                      ],
                    );
                  });
            },
            icon: const Icon(Icons.picture_as_pdf),
            color: Colors.red,
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const MyDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _textEditingController.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade500,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _textEditingController[index],
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(fontSize: 16),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(16),
                          border: InputBorder.none,
                          hintText: 'Edit text here...',
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: Stack(
                  children: [
                    AnimatedGradientContainer(), // Make sure this is imported
                    const Center(
                      child: Text(
                        "Generate Algorithm",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedGradientContainer extends StatefulWidget {
  @override
  _AnimatedGradientContainerState createState() =>
      _AnimatedGradientContainerState();
}

class _AnimatedGradientContainerState extends State<AnimatedGradientContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<Color> colorList = [
    Colors.purple.shade200,
    Colors.purple.shade400,
    Colors.purple.shade600,
    Colors.purple.shade400,
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colorList,
              stops: [
                0,
                _controller.value,
                _controller.value + 0.3,
                1,
              ],
            ),
          ),
        );
      },
    );
  }
}
