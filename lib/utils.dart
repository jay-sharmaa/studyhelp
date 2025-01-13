import 'package:flutter/material.dart';

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
                    // Navigator.push(context, MaterialPageRoute(builder: (context){
                      
                    // }));
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
