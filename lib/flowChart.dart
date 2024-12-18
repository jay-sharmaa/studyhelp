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
      // appBar: AppBar(
      //   title: const Text(
      //     "FlowChart",
      //     style: TextStyle(fontSize: 24, color: Colors.white),
      //   ),
        backgroundColor: Colors.black,
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(Icons.picture_as_pdf),
        //     color: Colors.red,
        //   )
        // ],
        // iconTheme: const IconThemeData(color: Colors.white),
      // ),
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
            
            // ListView.builder(
            //   itemBuilder: (context, index) {
            //     return Image.file(screenshot[index]);
            //   },
            //   shrinkWrap: true,
            //   itemCount: screenshot.length,
            // )
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

class Placeholder extends StatefulWidget {
  const Placeholder({super.key});
  @override
  State<Placeholder> createState() => _placeholderState();
}

class _placeholderState extends State<Placeholder> {
  int currindex = 0;
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
      height: 650,
      width: 450,
      child: Stack(
        children:[
          for(var index in draggableItems)
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
                    if (index.id == 0) {
                      draggableItems.add(DraggableItem(
                        id: ++currindex,
                        offset: offset,
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.blue,
                          child: Center(
                            child: Text(
                              ('$currindex ${index.id}'),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ));
                    } else if(index.id <= currindex) {
                      draggableItems[index.id] = DraggableItem(
                        id: currindex,
                        offset: offset,
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.blue,
                          child: Center(
                            child: Text(
                              ('$currindex ${index.id}'),
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
            )
          ]
      ),
    );
  }
}
