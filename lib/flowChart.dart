import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:studyhelp/dragDropWidget.dart';
import 'package:studyhelp/drawer.dart';

class MyFlowChart extends StatefulWidget {
  const MyFlowChart({super.key});

  @override
  State<MyFlowChart> createState() => _MyFlowChartState();
}

GlobalKey frontScreen = GlobalKey();

List<File> screenshot = [];

class _MyFlowChartState extends State<MyFlowChart> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "FlowChart",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.picture_as_pdf),
            color: Colors.red,
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RepaintBoundary(
        key: frontScreen,
        child: Column(
          children: [
            Stack(
              children: [
                Positioned(
                  top: MediaQuery.of(context).size.height / 2,
                  child: TextButton(
                    onPressed: () {
                      takeScreenShot();
                      setState(() {});
                    },
                    child: const Text("Generate ScreenShot"),
                  ),
                ),
                const placeHolder(),
                const GridPaper(
                  color: Colors.grey,
                  child: SizedBox(
                    height: 780,
                    width: 450,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      drawer: const MyDrawer(),
    );
  }
}

takeScreenShot() async {
  RenderRepaintBoundary boundary =
      frontScreen.currentContext!.findRenderObject() as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage();
  File file = File(image.toString());
  screenshot.add(file);
}
