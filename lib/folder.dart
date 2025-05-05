import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:studyhelp/drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({super.key});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  List<String> storageKeys = [];

  @override
  void initState() {
    super.initState();
    _loadFoldersFromPrefs();
  }

  Future<void> _loadFoldersFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> folders = [];
    int index = 1;

    while (true) {
      String? value = prefs.getString(index.toString());
      if (value == null) break;
      folders.add(value);
      index++;
    }

    setState(() {
      storageKeys = folders;
    });
  }

  Future<void> _addFolder(String name) async {
    final prefs = await SharedPreferences.getInstance();
    int index = 1;

    while (prefs.containsKey(index.toString())) {
      index++;
    }

    await prefs.setString(index.toString(), name);

    final baseDir = await getExternalStorageDirectory();
    final folder = Directory('${baseDir!.path}/$name');

    if (!(await folder.exists())) {
      await folder.create(recursive: true);
    }

    setState(() {
      storageKeys.add(name);
    });
}

  void _createFolderDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Name For Folder"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter folder name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                _addFolder(name);
              }
              Navigator.of(context).pop();
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Folders", style: TextStyle(fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: _createFolderDialog,
            icon: const Icon(Icons.create_new_folder),
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const MyDrawer(),
      body: storageKeys.isEmpty
          ? const Center(child: Text("No folders created."))
          : Padding(
            padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: storageKeys.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FolderIcon(color: true,),
                      const SizedBox(height: 6),
                      Text(
                        storageKeys[index],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}


class FolderIcon extends StatelessWidget {
  final Color folderColor;
  final Color tabColor;
  final double width;
  final double height;
  final bool color;

  const FolderIcon(
      {super.key,
      this.folderColor = const Color(0xFFFFC107),
      this.tabColor = const Color(0xFFFFB300),
      this.width = 100,
      this.height = 80,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Positioned(
            top: 7,
            left: 0,
            child: Container(
              width: width * 0.4,
              height: height * 0.30,
              decoration: BoxDecoration(
                color: tabColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(4),
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.15,
            child: Container(
              width: width,
              height: height * 0.65,
              decoration: BoxDecoration(
                color: color ? Colors.black : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Positioned(
            top: height * 0.25,
            child: Container(
              width: width,
              height: height * 0.75,
              decoration: BoxDecoration(
                color: folderColor,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
