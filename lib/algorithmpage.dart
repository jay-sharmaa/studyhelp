import 'package:flutter/material.dart';
import 'dart:collection';

import 'package:studyhelp/imageText.dart';

class Algorithmpage extends StatefulWidget {
  final List<Pair> mylist;
  const Algorithmpage({required this.mylist, super.key});

  @override
  State<Algorithmpage> createState() => _AlgorithmpageState();
}

class Node {
  String dataType;
  List<dynamic> value;
  int id;

  Node(this.dataType, this.value, this.id);
}

void addEdge(List<List<Node>> adj, Node u, Node v) {
  adj[u.id].add(v);
}

List<Node> bfs(List<List<Node>> adj, int startId, int V) {
  List<bool> vis = List.filled(V, false);
  Queue<int> q = Queue<int>();
  vis[startId] = true;
  q.add(startId);
  List<Node> bfsResult = [];

  while (q.isNotEmpty) {
    int currId = q.removeFirst();

    for (Node neighbor in adj[currId]) {
      if (!vis[neighbor.id]) {
        vis[neighbor.id] = true;
        q.add(neighbor.id);
        bfsResult.add(neighbor);
      }
    }
  }
  return bfsResult;
}

class _AlgorithmpageState extends State<Algorithmpage> {
  late List<Node> result;
  @override
  void initState() {
    super.initState();
    List<List<Node>> adj = List.generate(widget.mylist.length * 2 + 1, (_) => []);

    for(int i = 0;i<widget.mylist.length - 1;i++){
      var node1 = Node(widget.mylist[i].dataType, widget.mylist[i].values, i);
      var node2 = Node(widget.mylist[i+1].dataType, widget.mylist[i+1].values, i+1);
      addEdge(adj, node1, node2);
    }

    result = bfs(adj, 0, widget.mylist.length * 2 + 1);
    for(int i = 0;i<result.length;i++){
      print('${result[i].dataType} ${result[i].value} ${result[i].id}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Algorithm",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: result.length,
        itemBuilder: (context, index){
        return Text("${result[index].dataType} ${result[index].value} ${result[index].id}");
      }),
    );
  }
}