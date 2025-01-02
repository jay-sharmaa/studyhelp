import 'package:flutter/material.dart';
import 'package:studyhelp/flowChart.dart';
import 'package:studyhelp/imageText.dart';
import 'package:studyhelp/main.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});
  @override
  State<MyDrawer> createState() => _DrawerState();
}

List<bool> mylist = [true, false, false];

class _DrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:  Colors.black,
      child: Column(
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              dividerTheme: const DividerThemeData(color: Colors.transparent)
            ),
            child: DrawerHeader(
              child: Container(
                
              )
            ),
          ),
          const Divider(color: Colors.red, thickness: 1,),
          GestureDetector(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Home", style: TextStyle(color: mylist[0]? Colors.red : Colors.white, fontSize: mylist[0]? 32:24),),
              ],
            ),
            onTap: (){
              mylist.fillRange(0, 3, false);
              mylist[0] = true;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                return const HomePage();
              }));
            },
          ),
          const SizedBox(height: 25,),
          GestureDetector(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("FlowChart", style: TextStyle(color: mylist[1]? Colors.red : Colors.white, fontSize: mylist[1]? 32:24),),
              ],
            ),
            onTap: (){
              mylist.fillRange(0, 3, false);
              mylist[1] = true;
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return const MyFlowChart();
              }));
            },
          ),
          const SizedBox(height: 25,),
          GestureDetector(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Image/Text", style: TextStyle(color: mylist[2]? Colors.red : Colors.white, fontSize: mylist[2]? 32:24),),
              ],
            ),
            onTap: (){
              mylist.fillRange(0, 3, false);
              mylist[2] = true;
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return const Imagetext();
              }));
            },
          ),
        ],
      )
    );
  }
}