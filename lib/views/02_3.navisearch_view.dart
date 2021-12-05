import 'package:flutter/material.dart';

class Navisearch extends StatelessWidget {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('도착지와 출발지를 입력해주세요')
          ],
        ),
      ),
    );
  }
}
