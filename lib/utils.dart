import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Widget DecoratedContainer(List<dynamic> fileName, BuildContext context) {
  return SingleChildScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    scrollDirection: Axis.horizontal,
    child: Row(
      children: fileName.map((file) {
        if (file.toString()[file.toString().length - 6] != '/') {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.shade100,
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0),
                        blurRadius: 6.0)
                  ]),
              height: double.infinity,
              margin: const EdgeInsets.only(bottom: 6.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    child: Text(file.toString()),
                    onTap: (){
                      openPDFfromAssets();
                    }
                ),
              ),
            ),
          );
        }
        else{
          return Container();
        }
      }).toList(),
    ),
  );
}

Future<void> openPDFfromAssets() async {
  const String assetPath = 'assests/sample.pdf';

  final Directory tempDir = await getTemporaryDirectory();
  final File file = File('${tempDir.path}/sample.pdf');

  final ByteData data = await rootBundle.load(assetPath);
  final List<int> bytes = data.buffer.asUint8List();
  await file.writeAsBytes(bytes, flush: true);

  await OpenFilex.open(file.path);
}