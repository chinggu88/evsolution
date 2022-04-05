import 'package:evsolution/controller/login_controller.dart';
import 'package:evsolution/controller/root_controller.dart';
import 'package:evsolution/controller/stats_controller.dart';
import 'package:evsolution/views/02_1.home_view.dart';
import 'package:evsolution/views/02_2.map_view.dart';
import 'package:evsolution/views/02_3.navisearch_view.dart';
import 'package:evsolution/views/02_4.userlist_view.dart';
import 'package:evsolution/views/02_5.myinfo_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Root extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: setbody(),
        bottomNavigationBar: setNavigator(),
      );
    });
  }

  Widget setbody() {
    switch (RouteName.values[Rootcontroller.to.currentIndex.value]) {
      case RouteName.home:
        return Home();
        // ignore: dead_code
        break;
      case RouteName.map:
        return map();
        // ignore: dead_code
        break;
      case RouteName.navisearch:
        return Navisearch();
        // ignore: dead_code
        break;
      case RouteName.uselist:
        return Userlist();
        // ignore: dead_code
        break;
      case RouteName.myinfo:
        return Myinfo();
        // ignore: dead_code
        break;
    }
  }

  Widget setNavigator() {
    return BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        currentIndex: Rootcontroller.to.currentIndex.value,
        onTap: Rootcontroller.to.changeIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: '내주변'),
          BottomNavigationBarItem(icon: Icon(Icons.navigation), label: '경로'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: '최근충전'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: '내정보'),
        ]);
  }
}
