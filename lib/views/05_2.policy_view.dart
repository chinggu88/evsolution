import 'package:flutter/material.dart';
import 'package:get/get.dart';

class policy extends StatelessWidget {
  const policy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
        title: Center(child: Text('이용약관 및 정책')),
        actions: [
          Container(
            child: const Icon(Icons.search_outlined),
            padding: EdgeInsets.symmetric(horizontal: 20),
          )
        ],
      ),
      body: Text('앱설정'),
    );
  }
}
