import 'dart:math' as math;
import 'package:flutter/material.dart';

enum ShapeType { square, circle, rhombus }

class Connection {
  final DraggableItem from;
  final DraggableItem to;
  final Color color;

  Connection({
    required this.from,
    required this.to,
    this.color = Colors.black,
  });
}

class DraggableItem {
  final int id;
  Offset offset;
  final Widget child;
  final ShapeType type;
  final Color color;
  final TextEditingController textEditingController;

  DraggableItem({
    required this.id,
    required this.offset,
    required this.child,
    required this.type,
    required this.color,
    required this.textEditingController
  });

  factory DraggableItem.createShape({
    required int id,
    required Offset offset,
    required ShapeType type,
    String initialText = '',
  }) {
    final textEditingController = TextEditingController(text: initialText);

    switch (type) {
      case ShapeType.square:
        return DraggableItem(
          id: id,
          offset: offset,
          type: type,
          color: Colors.yellow,
          textEditingController: textEditingController,
          child: Container(
            width: 85,
            height: 85,
            color: Colors.yellow,
            child: Center(
              child: TextField(
                controller: textEditingController,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        );

      case ShapeType.circle:
        return DraggableItem(
          id: id,
          offset: offset,
          type: type,
          color: Colors.yellow.shade300,
          textEditingController: textEditingController,
          child: ClipOval(
            child: Container(
              width: 85,
              height: 85,
              color: Colors.yellow.shade300,
              child: Center(
                child: TextField(
                  controller: textEditingController,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ),
        );

      case ShapeType.rhombus:
        return DraggableItem(
          id: id,
          offset: offset,
          type: type,
          color: Colors.yellow.shade500,
          textEditingController: textEditingController,
          child: Transform.rotate(
            angle: math.pi / 4,
            child: Container(
              width: 85,
              height: 85,
              color: Colors.yellow.shade500,
              child: Center(
                child: Transform.rotate(
                  angle: -math.pi / 4,
                  child: TextField(
                    controller: textEditingController,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
    }
  }
  Offset get centerOffset {
    return Offset(
      offset.dx + 42.5,
      offset.dy + 42.5,
    );
  }
}



class PlaceHolder extends StatefulWidget {
  const PlaceHolder({super.key});
  @override
  State<PlaceHolder> createState() => _PlaceHolderState();
}

final List<Connection> connections = [];

class _PlaceHolderState extends State<PlaceHolder> {
  final Map<ShapeType, List<DraggableItem>> items = {
    ShapeType.square: [],
    ShapeType.circle: [],
    ShapeType.rhombus: [],
  };
  
  final Map<ShapeType, int> counters = {
    ShapeType.square: 0,
    ShapeType.circle: 0,
    ShapeType.rhombus: 0,
  };


  DraggableItem? selectedNode;

  List<Offset> points = [];

  @override
  void initState() {
    super.initState();
    items[ShapeType.square]!.add(DraggableItem.createShape(
      id: 0,
      offset: const Offset(15, 10),
      type: ShapeType.square,
      initialText: 'Drag Me',
    ));
    
    items[ShapeType.circle]!.add(DraggableItem.createShape(
      id: 0,
      offset: const Offset(130, 10),
      type: ShapeType.circle,
      initialText: 'Drag Me',
    ));
    
    items[ShapeType.rhombus]!.add(DraggableItem.createShape(
      id: 0,
      offset: const Offset(250, 28.37),
      type: ShapeType.rhombus,
      initialText: 'Drag Me',
    ));
  }

  void _handleDragEnd(DraggableItem item, Offset offset) {
  setState(() {
    final finalOffset = renderPosition(context, offset);
    
    if (item.id == 0) {
      counters[item.type] = counters[item.type]! + 1;
      items[item.type]!.add(DraggableItem.createShape(
        id: counters[item.type]!,
        offset: finalOffset,
        type: item.type,
        initialText: '${counters[item.type]} ${item.id}',
      ));
    } else {
      final index = items[item.type]!.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        final updatedItem = DraggableItem.createShape(
          id: item.id,
          offset: finalOffset,
          type: item.type,
          initialText: '${counters[item.type]} ${item.id}',
        );
        items[item.type]![index] = updatedItem;
        for (var connection in connections) {
          if (connection.from.id == item.id) {
            connection.from.offset = finalOffset;
          }
          if (connection.to.id == item.id) {
            connection.to.offset = finalOffset;
          }
        }
      }
    }
  });
}

  void _handleNodeTap(DraggableItem item) {
  setState(() {
    if (selectedNode == null) {
      selectedNode = item;
    } else if (selectedNode != item) {
      connections.add(Connection(
        from: DraggableItem(
          id: selectedNode!.id,
          offset: selectedNode!.offset,
          child: selectedNode!.child,
          type: selectedNode!.type,
          color: selectedNode!.color,
          textEditingController: TextEditingController(),
        ),
        to: DraggableItem(
          id: item.id,
          offset: item.offset,
          child: item.child,
          type: item.type,
          color: item.color,
          textEditingController: TextEditingController(),
        ),
      ));
      selectedNode = null;
    } else {
      selectedNode = null;
    }
  });
}

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 780,
      width: 450,
      child: Stack(
        children: [CustomPaint(
            painter: ConnectionPainter(
              connections: connections,
              selectedNode: selectedNode,
            ),
          ),
          ...items.entries.expand((entry) => entry.value.map((item) => 
            Positioned(
              left: item.offset.dx,
              top: item.offset.dy,
              child: GestureDetector(
                onDoubleTap: () => _handleNodeTap(item),
                child: Draggable<DraggableItem>(
                  data: item,
                  feedback: Opacity(
                    opacity: 0.7,
                    child: Material(child: item.child),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.3,
                    child: Material(child: item.child),
                  ),
                  onDraggableCanceled: (velocity, offset) => 
                    _handleDragEnd(item, offset),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: selectedNode?.id == item.id 
                          ? Colors.blue 
                          : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: item.child,
                  ),
                ),
              ),
            ),
          )),
        ],
      ),
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

class ConnectionPainter extends CustomPainter {
  final List<Connection> connections;
  final DraggableItem? selectedNode;

  ConnectionPainter({
    required this.connections,
    this.selectedNode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final connection in connections) {
      final start = connection.from.centerOffset;
      final end = connection.to.centerOffset;
      
      canvas.drawLine(start, end, paint);
      
      _drawArrow(canvas, start, end, paint);
    }

    if (selectedNode != null) {
      paint.color = Colors.blue;
      paint.strokeWidth = 1;
    }
  }

  void _drawArrow(Canvas canvas, Offset start, Offset end, Paint paint) {
    const arrowSize = 15.0;
    final delta = end - start;
    final angle = math.atan2(delta.dy, delta.dx);
    
    final arrowPath = Path()
      ..moveTo(end.dx - arrowSize * math.cos(angle - math.pi / 6),
               end.dy - arrowSize * math.sin(angle - math.pi / 6))
      ..lineTo(end.dx, end.dy)
      ..lineTo(end.dx - arrowSize * math.cos(angle + math.pi / 6),
               end.dy - arrowSize * math.sin(angle + math.pi / 6))
      ..close();
    
    canvas.drawPath(arrowPath, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}