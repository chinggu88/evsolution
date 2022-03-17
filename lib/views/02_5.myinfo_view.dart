import 'package:evsolution/controller/login_controller.dart';
import 'package:evsolution/controller/stats_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

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
            TextButton(
                onPressed: () {
                  switch (Statecontroller.to.loginType.value) {
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
                      print("apple log out");
                      Logincontroller.to.resetlogininfo();
                      break;
                  }
                },
                child: Text('logout!')),
                FutureBuilder(
                  future: Statecontroller.to.initialplayer,
                  builder: (context,snapshot){
                    return AspectRatio(aspectRatio: Statecontroller.to.controller!.value.aspectRatio,
                    child: VideoPlayer(Statecontroller.to.controller!),);
                  }),
                  TextButton(onPressed: (){
                    Statecontroller.to.controller!.play();
                  }, child: Text('실행'))

          ],
        ),
      ),
    );
  }
}
