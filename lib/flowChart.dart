import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:studyhelp/drawer.dart';

class MyFlowChart extends StatefulWidget {
  const MyFlowChart({super.key});

  @override
  State<MyFlowChart> createState() => _MyFlowChartState();
}

GlobalKey frontScreen = GlobalKey();

List<File> screenshot = [];

class _MyFlowChartState extends State<MyFlowChart> {
  int index = 1;
  List<DraggableItem> draggableItems = [
    DraggableItem(
      id: 0,
      offset: const Offset(100, 100),
      child: Container(
        width: 100,
        height: 100,
        color: Colors.blue,
        child: const Center(
          child: Text(
            'Drag Me',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    )
  ];

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
                TextButton(onPressed: (){
                  takeScreenShot();
                  setState(() {
                
                  });
                }, child: const Text("Generate ScreenShot")),
                ...draggableItems.map(
                  (item) => Positioned(
                    left: item.offset.dx,
                    top: item.offset.dy,
                    child: Draggable<DraggableItem>(
                      data: item,
                      feedback: Opacity(
                        opacity: 0.7,
                        child: item.child,
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.3,
                        child: item.child,
                      ),
                      onDraggableCanceled: (Velocity velocity, Offset offset) {
                        setState(() {
                          if (item.id == 0) {
                            draggableItems.add(DraggableItem(
                              id: index,
                              offset: offset,
                              child: Container(
                                width: 100,
                                height: 100,
                                color: Colors.blue,
                                child: Center(
                                  child: Text(
                                    (index).toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ));
                            index++;
                          } 
                          else if ((index - item.id) == draggableItems.length) {
                            draggableItems[item.id] = DraggableItem(
                              id: index,
                              offset: offset,
                              child: Container(
                                width: 100,
                                height: 100,
                                color: Colors.blue,
                                child: Center(
                                  child: Text(
                                    (index).toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),);
                          }
                        });
                      },
                      child: item.child,
                    ),
                  ),
                ),
                const GridPaper(
                  color: Colors.grey,
                  child: SizedBox(
                    height: 750,
                    width: 450,
                  ),
                )
              ],
            ),
            ListView.builder(itemBuilder: (context, index){
              return Image.file(screenshot[index]);
            },
            shrinkWrap: true,
            itemCount: screenshot.length,
            )
          ],
        ),
      ),
      drawer: const MyDrawer(),
    );
  }
}

class DraggableItem {
  final int id;
  final Offset offset;
  final Widget child;

  DraggableItem({
    required this.id,
    required this.offset,
    required this.child,
  });
}

takeScreenShot() async {
  RenderRepaintBoundary boundary = 
    frontScreen.currentContext!.findRenderObject() as RenderRepaintBoundary;
  ui.Image image = await boundary.toImage();
  File file = File(image.toString());
  screenshot.add(file);
}
