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
    return Obx((){
      return Scaffold(
          // appBar: setAppbar(),
          body: setbody(),
          bottomNavigationBar:setNavigator(),
      );
    });
  }

  PreferredSizeWidget setAppbar(){
  String viewname='';
  switch (RouteName.values[Rootcontroller.to.currentIndex.value]) {
           case RouteName.home:
            viewname='Home_View';
            
            break;
            case RouteName.uselist:
            viewname='uselist';
            
            break;
            case RouteName.navisearch:
            viewname='favorite';
            
            break;
            case RouteName.myinfo:
            viewname='myinfo';
            
            break;
            case RouteName.map:
            viewname='map';
            break;
         }
  return AppBar(
    title:Text(viewname),
    
    
);
}
Widget setbody(){
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
Widget setNavigator(){
  return BottomNavigationBar(
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        currentIndex:Rootcontroller.to.currentIndex.value,
        onTap: Rootcontroller.to.changeIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),title: Text('홈')),
          BottomNavigationBarItem(icon: Icon(Icons.map),title: Text('내주변')),
          BottomNavigationBarItem(icon: Icon(Icons.navigation),title: Text('경로')),
          BottomNavigationBarItem(icon: Icon(Icons.favorite),title: Text('최근충전')),
          BottomNavigationBarItem(icon: Icon(Icons.info ),title: Text('내정보')),
        ]) ;
}
 Widget setdraw(){
    
    return  Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('로그인유형'),
            Text(Statecontroller.to.loginType.value),
            Text('로그인ID'),
            Text(Statecontroller.to.loginId.value),
            TextButton(onPressed: (){
              switch(Statecontroller.to.loginType.value){
                case 'naver':
                Logincontroller.to.logoutWithNaver();
            Logincontroller.to.resetlogininfo();
                  break;
                case 'kakao':
                Logincontroller.to.logoutWithTalk();
               Logincontroller.to.resetlogininfo();
                break;
                case 'google':
                Logincontroller.to.signOutWithGoogle();
              Logincontroller.to.resetlogininfo();
                break;
                case 'apple':
                Text('구현중');
                break;
              }              
            
            }, child: Text('logout!')),
            
          ],
        ),
      );
  }
}