import 'package:evsolution/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              height: Get.size.height * 0.204,
            ),
            Container(
              height: Get.size.height * 0.17,
              width: Get.size.width * 0.30,
              child: SvgPicture.asset('assets/image/login/group_325.svg'),
            ),
            Container(
              height: Get.size.height * 0.02,
            ),
            Container(
              child: Text(
                'My Smart Charging',
                style: TextStyle(
                  color: Color(0xff01239c),
                  fontFamily: 'NotoSansKR',
                ),
              ),
            ),
            Container(
              height: Get.size.height * 0.11,
            ),
            GestureDetector(
              onTap: Logincontroller.to.loginWithNaver,
              child: Container(
                  width: Get.size.width * 0.733,
                  height: Get.size.height * 0.062,
                  decoration: BoxDecoration(
                    color: Color(0xff5ac466),
                    borderRadius: BorderRadius.circular(61),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: Get.size.height * 0.062,
                        height: Get.size.height * 0.062,
                        child: SvgPicture.asset('assets/image/login/naver.svg'),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: (Get.size.width * 0.733),
                        height: Get.size.height * 0.062,
                        child: Text(
                          'NAVER로 로그인',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'AppleSDGothicNeoR00',
                          ),
                        ),
                      )
                    ],
                  )),
            ),
            Container(
              height: Get.size.height * 0.019,
            ),
            GestureDetector(
              onTap: Logincontroller.to.iskakaotalkInstalled.value
                  ? Logincontroller.to.loginWithTalk
                  : Logincontroller.to.loginWithTalk,
              child: Container(
                  width: Get.size.width * 0.733,
                  height: Get.size.height * 0.062,
                  decoration: BoxDecoration(
                    color: Color(0xfffae64c),
                    borderRadius: BorderRadius.circular(61),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: Get.size.height * 0.062,
                        height: Get.size.height * 0.062,
                        child: SvgPicture.asset('assets/image/login/kakao.svg'),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: (Get.size.width * 0.733),
                        height: Get.size.height * 0.062,
                        child: Text(
                          'KAKAO로 로그인',
                          style: TextStyle(
                            color: Color(0xff392020),
                            fontFamily: 'AppleSDGothicNeoR00',
                          ),
                        ),
                      )
                    ],
                  )),
            ),
            Container(
              height: Get.size.height * 0.019,
            ),
            GestureDetector(
              onTap: Logincontroller.to.signInWithGoogle,
              child: Container(
                  width: Get.size.width * 0.733,
                  height: Get.size.height * 0.062,
                  decoration: BoxDecoration(
                    color: Color(0xfff0f0f0),
                    borderRadius: BorderRadius.circular(61),
                  ),
                  child: Stack(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: Get.size.height * 0.062,
                        height: Get.size.height * 0.062,
                        child:
                            SvgPicture.asset('assets/image/login/google.svg'),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: (Get.size.width * 0.733),
                        height: Get.size.height * 0.062,
                        child: Text(
                          'GOOGLE로 로그인',
                          style: TextStyle(
                            color: Color(0xff392020),
                            fontFamily: 'AppleSDGothicNeoR00',
                          ),
                        ),
                      )
                    ],
                  )),
            ),
            Container(
              height: Get.size.height * 0.03,
            ),
            FlatButton(
              color: Colors.grey.withOpacity(0.3),
              onPressed: Logincontroller.to.signInWithApple,
              child: Text("Apple Login"),
            ),
            TextButton(
              onPressed: () async {
                await Geolocator.requestPermission();
                Get.offNamed('/root');
              },
              child: Text(
                '먼저 둘러보기',
                style: TextStyle(
                  color: Color(0xff939393),
                  fontFamily: 'NotoSans',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
