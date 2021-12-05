import 'package:evsolution/controller/root_controller.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Column(
          children: [
            IconButton(onPressed: (){Rootcontroller.to.changeIndex(1);}, icon: Icon(Icons.map)),
            IconButton(onPressed: (){Rootcontroller.to.changeIndex(2);}, icon: Icon(Icons.list)),
            // Image.asset('asset/marker/0.PNG')
          ],
        )
    ); 
    
  }
}