import 'package:evsolution/controller/login_controller.dart';
import 'package:evsolution/controller/stats_controller.dart';
import 'package:flutter/material.dart';

class Myinfo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
        ),
      
    );
  }
}