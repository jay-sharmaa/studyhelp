import 'dart:io';
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
                const Placeholder(),
                const GridPaper(
                  color: Colors.grey,
                  child: SizedBox(
                    height: 650,
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

class DraggableItem {
  final int id;
  final Offset offset;
  final Widget child;
  String sampleText;

  DraggableItem({
    this.sampleText = "SampleText",
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

class Placeholder extends StatefulWidget {
  const Placeholder({super.key});
  @override
  State<Placeholder> createState() => _placeholderState();
}

class _placeholderState extends State<Placeholder> {
  int currSquareIndex = 0;
  int currCircleIndex = 0;

  List<DraggableItem> draggableItemsSquare = [
    DraggableItem(
      id: 0,
      offset: const Offset(0, 0),
      child: Container(
        width: 85,
        height: 85,
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

  List<DraggableItem> draggableItemsCircle = [
    DraggableItem(
      id: 0,
      offset: const Offset(125, 0),
      child: ClipOval(
        child: Container(
          width: 85,
          height: 85,
          color: Colors.blue,
          child: const Center(
            child: Text(
              'Drag Me',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 650,
      width: 450,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ClipOval(
                  child: Container(
                    width: 85,
                    height: 85,
                    color: Colors.blue,
                    child: const Center(
                      child: Text(
                        'Drag Me',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Stack(children: [
              for (var index in draggableItemsSquare)
                Positioned(
                  left: index.offset.dx,
                  top: index.offset.dy,
                  child: Draggable<DraggableItem>(
                    data: index,
                    feedback: Opacity(
                      opacity: 0.7,
                      child: index.child,
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: index.child,
                    ),
                    onDraggableCanceled: (Velocity velocity, Offset offset) {
                      setState(() {
                        Offset finalOffset = renderPosition(context, offset);
                        if (index.id == 0) {
                          draggableItemsSquare.add(DraggableItem(
                            id: ++currSquareIndex,
                            offset: finalOffset,
                            child: Container(
                              width: 85,
                              height: 85,
                              color: Colors.blue,
                              child: Center(
                                child: Text(
                                  ('$currSquareIndex ${index.id}'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ));
                        } else if (index.id <= currSquareIndex) {
                          draggableItemsSquare[index.id] = DraggableItem(
                            id: index.id,
                            offset: finalOffset,
                            child: Container(
                              width: 85,
                              height: 85,
                              color: Colors.blue,
                              child: Center(
                                child: Text(
                                  ('$currSquareIndex ${index.id}'),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        }
                      });
                    },
                    child: index.child,
                  ),
                ),
              for (var index in draggableItemsCircle)
                Positioned(
                  left: index.offset.dx,
                  top: index.offset.dy,
                  child: Draggable<DraggableItem>(
                    data: index,
                    feedback: Opacity(
                      opacity: 0.7,
                      child: index.child,
                    ),
                    childWhenDragging: Opacity(
                      opacity: 0.3,
                      child: index.child,
                    ),
                    onDraggableCanceled: (Velocity velocity, Offset offset) {
                      setState(() {
                        Offset finalOffset = renderPosition(context, offset);
                        if (index.id == 0) {
                          draggableItemsCircle.add(DraggableItem(
                            id: ++currCircleIndex,
                            offset: finalOffset,
                            child: ClipOval(
                              child: Container(
                                width: 85,
                                height: 85,
                                color: Colors.blue,
                                child: Center(
                                  child: Text(
                                    ('$currCircleIndex ${index.id}'),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ));
                        } else if (index.id <= currCircleIndex) {
                          draggableItemsCircle[index.id] = DraggableItem(
                            id: index.id,
                            offset: finalOffset,
                            child: ClipOval(
                              child: Container(
                                width: 85,
                                height: 85,
                                color: Colors.blue,
                                child: Center(
                                  child: Text(
                                    ('$currCircleIndex ${index.id}'),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      });
                    },
                    child: index.child,
                  ),
                ),
            ]),
          ),
        ],
      ),
    );
  }

  Offset renderPosition(BuildContext context, Offset offset) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset finalOffset = renderBox.globalToLocal(offset);
    if(finalOffset.dy <= 50) {
      return finalOffset;
    } else{
      return finalOffset - const Offset(0, 50);
    }
  }
}
