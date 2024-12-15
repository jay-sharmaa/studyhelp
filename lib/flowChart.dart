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
  int index = 0;

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
                TextButton(
                    onPressed: () {
                      takeScreenShot();
                      setState(() {});
                    },
                    child: const Text("Generate ScreenShot"),
                  ),
                    
                Expanded(child: placeholder(index: index)),
                const GridPaper(
                  color: Colors.grey,
                  child: SizedBox(
                    height: 750,
                    width: 450,
                  ),
                )
              ],
            ),
            
            ListView.builder(
              itemBuilder: (context, index) {
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

class placeholder extends StatefulWidget {
  int index;
  placeholder({required int this.index, super.key});
  @override
  State<placeholder> createState() => _placeholderState();
}

class _placeholderState extends State<placeholder> {
  
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
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemBuilder: (context, index){
          return Positioned(
            left: draggableItems[index].offset.dx,
            top: draggableItems[index].offset.dy,
            child: Draggable<DraggableItem>(
              data: draggableItems[index],
              feedback: Opacity(
                opacity: 0.7,
                child: draggableItems[index].child,
              ),
              childWhenDragging: Opacity(
                opacity: 0.3,
                child: draggableItems[index].child,
              ),
              onDraggableCanceled: (Velocity velocity, Offset offset) {
                setState(() {
                  if (draggableItems[index].id == 0) {
                    draggableItems.add(DraggableItem(
                      id: widget.index,
                      offset: offset,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            (widget.index).toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ));
                    widget.index++;
                  } else if (draggableItems[index].id <= widget.index) {
                    draggableItems[draggableItems[index].id] = DraggableItem(
                      id: draggableItems[index].id,
                      offset: offset,
                      child: Container(
                        width: 100,
                        height: 100,
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            (widget.index).toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  }
                });
              },
              child: draggableItems[index].child,
            ),
          );
        },
        itemCount: draggableItems.length,
      ),
    );
  }
}
