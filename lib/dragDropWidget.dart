import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DraggableItem {
  final int id;
  final Offset offset;
  final Widget child;
  String sampleText;
  Color color;

  DraggableItem({
    this.sampleText = "SampleText",
    this.color = Colors.black,
    required this.id,
    required this.offset,
    required this.child,
  });
}

class placeHolder extends StatefulWidget {
  const placeHolder({super.key});
  @override
  State<placeHolder> createState() => _placeholderState();
}

class _placeholderState extends State<placeHolder> {
  int currSquareIndex = 0;
  int currCircleIndex = 0;
  int currRhombusIndex = 0;
  List<Offset> points = [];

  List<DraggableItem> draggableItemsSquare = [
    DraggableItem(
      id: 0,
      offset: const Offset(15, 10),
      child: Container(
        width: 85,
        height: 85,
        color: Colors.yellow,
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
      offset: const Offset(130, 10),
      child: ClipOval(
        child: Container(
          width: 85,
          height: 85,
          color: Colors.yellow.shade300,
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

  List<DraggableItem> draggableItemsRhombus = [
    DraggableItem(
        id: 0,
        color: Colors.yellow.shade500,
        offset: const Offset(250, 28.37),
        child: Transform.rotate(
          angle: math.pi / 4,
          child: Container(
            width: 85,
            height: 85,
            color: Colors.yellow.shade500,
            child: Center(
              child: Transform.rotate(
                angle: -math.pi/4,
                child: const Text(
                  'Drag Me',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ))
  ];

  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      height: 780,
      width: 450,
      child: Stack(children: [
        CustomPaint(
          painter: CustomLine(points: points),
        ),
        for (var index in draggableItemsSquare)
          Positioned(
            left: index.offset.dx,
            top: index.offset.dy,
            child: InkWell(
              onDoubleTap: (){
                setState(() {
                  
                });
                points.add(index.offset);
              },
              child: Draggable<DraggableItem>(
                data: index,
                feedback: Opacity(
                  opacity: 0.7,
                  child: Material(child: index.child),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: Material(child: index.child),
                ),
                onDraggableCanceled: (Velocity velocity, Offset offset) {
                  setState(() {
                    Offset finalOffset = renderPosition(context, offset);
                    if (index.id == 0) {
                      draggableItemsSquare.add(DraggableItem(
                        id: ++currSquareIndex,
                        color: Colors.yellow,
                        offset: finalOffset,
                        child: Container(
                          width: 85,
                          height: 85,
                          color: Colors.yellow,
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
                        color: Colors.yellow,
                        offset: finalOffset,
                        child: Container(
                          width: 85,
                          height: 85,
                          color: Colors.yellow,
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
          ),
        for (var index in draggableItemsCircle)
          Positioned(
            left: index.offset.dx,
            top: index.offset.dy,
            child: InkWell(
              onDoubleTap: (){
                points.add(index.offset);
              },
              child: Draggable<DraggableItem>(
                data: index,
                feedback: Opacity(
                  opacity: 0.7,
                  child: Material(child: index.child),
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
                        color: Colors.yellow.shade300,
                        offset: finalOffset,
                        child: ClipOval(
                          child: Container(
                            width: 85,
                            height: 85,
                            color: Colors.yellow.shade300,
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
                        color: Colors.yellow.shade300,
                        offset: finalOffset,
                        child: ClipOval(
                          child: Container(
                            width: 85,
                            height: 85,
                            color: Colors.yellow.shade300,
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
          ),
        for (var index in draggableItemsRhombus)
          Positioned(
            left: index.offset.dx,
            top: index.offset.dy,
            child: InkWell(
              onDoubleTap: (){
                points.add(index.offset);
                setState(() {
                  
                });
              },
              child: Draggable<DraggableItem>(
                data: index,
                feedback: Opacity(
                  opacity: 0.7,
                  child: Material(child: index.child),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.3,
                  child: index.child,
                ),
                onDraggableCanceled: (Velocity velocity, Offset offset) {
                  setState(() {
                    Offset finalOffset = renderPosition(context, offset);
                    if (index.id == 0) {
                      draggableItemsRhombus.add(
                        DraggableItem(
                          id: ++currRhombusIndex,
                          color: Colors.yellow.shade500,
                          offset: finalOffset,
                          child: Transform.rotate(
                            angle: math.pi / 4,
                            child: Container(
                              width: 85,
                              height: 85,
                              color: Colors.yellow.shade500,
                              child: Center(
                                child: Transform.rotate(
                                  angle: -math.pi / 4,
                                  child: Text(
                                    ('$currRhombusIndex ${index.id}'),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (index.id <= currRhombusIndex) {
                      draggableItemsRhombus[index.id] = DraggableItem(
                        id: index.id,
                        color: Colors.yellow.shade500,
                        offset: finalOffset,
                        child: Transform.rotate(
                          angle: math.pi / 4,
                          child: Container(
                            width: 85,
                            height: 85,
                            color: Colors.yellow.shade500,
                            child: Center(
                              child: Transform.rotate(
                                angle: -math.pi / 4,
                                child: Text(
                                  ('$currRhombusIndex ${index.id}'),
                                  style: const TextStyle(color: Colors.white),
                                ),
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
          ),
      ]),
    );
  }

  Offset renderPosition(BuildContext context, Offset offset) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset finalOffset = renderBox.globalToLocal(offset);
    if (finalOffset.dy <= 50) {
      return Offset(finalOffset.dx, 100);
    }
    return finalOffset;
  }
}


class CustomLine extends CustomPainter{
  CustomLine({required this.points});
  final _paint = Paint()..color = Colors.black ..style = PaintingStyle.fill ..strokeWidth = 5;
  List<Offset> points = [];


  @override
  void paint(Canvas canvas, Size size){
    if (points.length < 2) return;
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], _paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    print('Repaint...');
    return true;
  }
}