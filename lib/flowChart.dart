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
  bool gridVisibility = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "FlowChart",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RepaintBoundary(
        key: frontScreen,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.height / 1.25,
                    left: MediaQuery.of(context).size.width / 4,
                    child: TextButton(
                      onPressed: () {
                        takeScreenShot();
                        setState(() {});
                      },
                      child: Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              color: Colors.white),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Generate ScreenShot",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black)),
                          )),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 1.25,
                    left: MediaQuery.of(context).size.width / 12,
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        size: 44,
                      ),
                      color: Colors.red,
                      onPressed: () {
                        screenshot.clear();
                        connections.clear();

                        items.forEach((key, value) {
                          value.removeWhere((item) => item.id != 0);
                        });

                        placeHolderKey.currentState?.initState();
                        setState(() {});
                      },
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 1.25,
                    left: MediaQuery.of(context).size.width / 1.25,
                    child: IconButton(
                      icon: const Icon(
                        Icons.grid_3x3,
                        size: 44,
                      ),
                      color: Colors.red,
                      onPressed: () {
                        gridVisibility = !gridVisibility;
                        setState(() {});
                      },
                    ),
                  ),
                  PlaceHolder(key: placeHolderKey),
                  if (gridVisibility)
                    const GridPaper(
                      color: Colors.grey,
                      child: SizedBox(
                        height: 800,
                        width: 450,
                      ),
                    )
                ],
              ),
            ],
          ),
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
