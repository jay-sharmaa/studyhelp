import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studyhelp/aiapicall.dart';
import 'package:studyhelp/algorithmpage.dart';
import 'package:studyhelp/drawer.dart';
import 'package:studyhelp/main.dart';

class Pair {
  String dataType;
  List<dynamic> values;
  Pair({required this.dataType, required this.values});
}

class Imagetext extends StatefulWidget {
  const Imagetext({super.key});

  @override
  State<Imagetext> createState() => _ImagetextState();
}

class _ImagetextState extends State<Imagetext> {
  // Single TextEditingController for all text
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController _fileNameController = TextEditingController();

  late List<Node> resultMap;

  @override
  void initState() {
    _initializeController();
    super.initState();
  }

  void _initializeController() {
    _textEditingController.text = text.join('\n\n');
  }

  List<String> _updateTextFromController() {
    return _textEditingController.text.split('\n\n');
  }

  void _createPDF(String fileName) async {
    final List<String> updatedText = _updateTextFromController();
    
    final Directory? directory = await getDownloadsDirectory();
    for (int i = 0; i < updatedText.length; i++) {
      pdf.addPage(pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            child: pw.Text(updatedText[i], style: const pw.TextStyle(fontSize: 10)),
          );
        },
        pageFormat: PdfPageFormat.a4,
      ));
    }

    final file = File("${directory!.path}/$fileName.pdf");
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
                      controller: _fileNameController,
                    ),
                    actions: [
                      GestureDetector(
                        onTap: () {
                          if (_fileNameController.text != "") {
                            _createPDF(_fileNameController.text);
                            Navigator.pop(context);
                          } else {
                            showSnackBar(context, "File Name Cannot Be Empty");
                          }
                        },
                        child: const Text("Save")
                      )
                    ],
                  );
                }
              );
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: TextField(
                    controller: _textEditingController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(fontSize: 16),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(16),
                      border: InputBorder.none,
                      hintText: 'Edit text here...',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 50,
                child: Stack(
                  children: [
                    AnimatedGradientContainer(),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final List<String> updatedText = _updateTextFromController();
                          String prompt = updatedText.join(' ');
                          resultMap = await generateContent(prompt);

                          for(int i = 0;i<resultMap.length;i++){
                            print(resultMap[i].name + " " + resultMap[i].type + " " + resultMap[i].isLoop.toString());
                          }
                          
                          Future.delayed(const Duration(seconds: 5));
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                              return Algorithmpage(nodes: resultMap);
                            })
                          );
                        },
                        child: const Text(
                          "Generate Algorithm",
                          style: TextStyle(fontSize: 18),
                        ),
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

  @override
  void dispose() {
    _textEditingController.dispose();
    _fileNameController.dispose();
    super.dispose();
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

class Node<T> {
  String name;
  T? value;
  String type;
  String? conditionVariable;
  String? operator;
  T? limit;
  bool isLoop;
  
  // New property to track conditional block status
  bool isInConditionalBlock;

  Node.variable(this.name, this.type, this.value, {this.isInConditionalBlock = false})
      : conditionVariable = null,
        operator = null,
        limit = null,
        isLoop = false;

  Node.condition(
    this.conditionVariable, 
    this.operator, 
    this.limit, 
    this.type, 
    {this.isLoop = false, this.isInConditionalBlock = true}
  ) : name = '',
      value = null;

  bool evaluate(Map<String, dynamic> context) {
    if (conditionVariable == null || operator == null || limit == null) return false;
    if (!context.containsKey(conditionVariable)) return false;
    var currentValue = context[conditionVariable];
    
    switch (operator) {
      case '<':
        return currentValue < limit;
      case '<=':
        return currentValue <= limit;
      case '>':
        return currentValue > limit;
      case '>=':
        return currentValue >= limit;
      case '==':
        return currentValue == limit;
      case '!=':
        return currentValue != limit;
      default:
        throw Exception('Unsupported operator: $operator');
    }
  }

  @override
  String toString() {
    if (conditionVariable != null) {
      return '{${isLoop ? "while_loop" : "if_statement"}: [${isLoop ? 1 : 0}, $conditionVariable $operator $limit, $type, inConditionalBlock: $isInConditionalBlock]}';
    }
    return '{$name: [$type, $value, inConditionalBlock: $isInConditionalBlock]}';
  }
}