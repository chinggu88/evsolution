import 'package:evsolution/controller/login_controller.dart';
import 'package:evsolution/controller/stats_controller.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:url_launcher/url_launcher.dart';

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
                      Text('구현중');
                      break;
                  }
                },
                child: Text('logout!')),
            TextButton(
                onPressed: () async {
                  if (!await launch(
                      'https://apis.openapi.sk.com/tmap/app/routes?appKey=l7xx71089ab0fff0470e97ab985297aa1343&name=SKT타워&lon=126.984098&lat=37.566385'))
                    throw 'Could not launch https://flutter.dev';
                },
                child: Text('launcher app!')),
            TextButton(
                onPressed: () async {
                  bool result = await NaviApi.instance.isKakaoNaviInstalled();
                  if (result) {
                    print('카카오내비 앱으로 길안내 가능');
                    // NaviApi.instance.shareDestination(destination: destination)
                  } else {
                    print('카카오내비 미설치');
                    // 카카오내비 설치 페이지로 이동
                    // launchBrowserTab(Uri.parse(NaviApi.NAVI_HOSTS));
                  }
                },
                child: Text('카카오 네비!')),
          ],
        ),
      ),
    );
  }
}
