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
      appBar: AppBar(title: Text('Algorithm Page')),
      body: ListView.builder(
        itemCount: widget.nodes.length,
        itemBuilder: (context, index){
          if(widget.nodes[index].isLoop){
            return DiamondPlaceholder(name: widget.nodes[index].type);
          }
          else{
            return Column(children: [
                CirclePlaceholder(name: widget.nodes[index].type),
                SizedBox(height: 10,)
              ],
            );
          }
        },
      )
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
        color: Colors.grey.shade400,
      ),
      child: Text(name),
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
        width: 150,
        height: 150,
        color: Colors.grey.shade400,
        child: Text(name),
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
      width: 150,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(75, 60)),
        color: Colors.grey.shade400,
      ),
      child: Text(name),
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