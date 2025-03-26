import 'package:flutter/material.dart';
import 'package:studyhelp/imageText.dart';

class Algorithmpage extends StatefulWidget {
  final List<Node> nodes;
  const Algorithmpage({required this.nodes, super.key});

  @override
  State<Algorithmpage> createState() => _AlgorithmpageState();
}

class _AlgorithmpageState extends State<Algorithmpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Algorithm Flow',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: ListView.separated(
          itemCount: widget.nodes.length,
          separatorBuilder: (_, __) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final node = widget.nodes[index];

            return Center(
              child: node.isLoop
                  ? DiamondPlaceholder(name: node.type)
                  : CirclePlaceholder(name: node.type),
            );
          },
        ),
      ),
    );
  }
}

class CirclePlaceholder extends StatelessWidget {
  final String name;

  const CirclePlaceholder({required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blueGrey.shade300,
        boxShadow: [
          BoxShadow(color: Colors.grey.shade600, blurRadius: 6, offset: Offset(2, 2))
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

class DiamondPlaceholder extends StatelessWidget {
  final String name;

  const DiamondPlaceholder({required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: DiamondClipper(),
      child: Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent.shade200,
          boxShadow: [
            BoxShadow(color: Colors.grey.shade600, blurRadius: 6, offset: Offset(2, 2))
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

class EllipsePlaceholder extends StatelessWidget {
  final String name;

  const EllipsePlaceholder({required this.name, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.elliptical(90, 50)),
        color: Colors.greenAccent.shade400,
        boxShadow: [
          BoxShadow(color: Colors.grey.shade600, blurRadius: 6, offset: Offset(2, 2))
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

class DiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
