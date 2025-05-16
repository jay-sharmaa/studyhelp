import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Folderstorage extends StatefulWidget {
  final String folderName;

  const Folderstorage({super.key, required this.folderName});

  @override
  State<Folderstorage> createState() => _FolderstorageState();
}

class _FolderstorageState extends State<Folderstorage> {
  List<FileSystemEntity> files = [];

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final baseDir = await getApplicationDocumentsDirectory();
    final targetDir = Directory('${baseDir.path}/${widget.folderName}');

    if (await targetDir.exists()) {
      final fileList = targetDir.listSync().whereType<File>().toList();
      setState(() {
        files = fileList;
      });
    } else {
      setState(() {
        files = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName, style: const TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: files.isEmpty
          ? const Center(child: Text("No files found."))
          : ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                final file = files[index];
                final name = file.path.split('/').last;
                return ListTile(
                  leading: const Icon(Icons.insert_drive_file),
                  title: Text(name),
                  onTap: () {
                    OpenFile.open(file.path);
                  },
                );
              },
            ),
    );
  }
}
