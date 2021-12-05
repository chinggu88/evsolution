import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Userlist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
          icon: Icon(Icons.list),
          iconSize: 20,
          onPressed:(){
            Get.bottomSheet(              
              GestureDetector(                
                child: Container(
                  height: Get.size.height ,
                  color: Colors.white,
                  child: Column(
                    children: getlist()
                  )
                ),
              ),
              
            );
          }
        ),
      ),
    );
  }

  List<Widget> getlist(){
    List<Widget> result=[];
    result.add(Text('a1'));
    result.add(Text('a1'));result.add(Text('a1'));
    result.add(Text('a1'));result.add(Text('a1'));result.add(Text('a1'));result.add(Text('a1'));result.add(Text('a1'));
    return result;
  }
}