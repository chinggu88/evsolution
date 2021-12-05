import 'package:evsolution/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(
              height: Get.size.height * 0.562,
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
                child:Stack(
                  children: [
                    Container(
                      alignment:Alignment.center,
                      width: Get.size.height * 0.062,
                      height: Get.size.height * 0.062,
                      child:SvgPicture.asset(
                          'assets/image/login/naver.svg'),
                    ),
                    Container(
                      alignment:Alignment.center,
                      width: (Get.size.width * 0.733),
                      height: Get.size.height * 0.062,
                      child:Text(
                        'NAVER로 로그인',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'AppleSDGothicNeoR00',
                        ),
                      ),
                    )
                  ],
                )
              ),
            ),
            Container(
              height: Get.size.height * 0.019,
            ),
            GestureDetector(
              onTap: Logincontroller.to.iskakaotalkInstalled.value ?Logincontroller.to.loginWithTalk: Logincontroller.to.loginWithTalk,
              child: Container(
                width: Get.size.width * 0.733,
                height: Get.size.height * 0.062,
                decoration: BoxDecoration(
                  color: Color(0xfffae64c),
                  borderRadius: BorderRadius.circular(61),
                ),
                child:Stack(
                  children: [
                    Container(
                      alignment:Alignment.center,
                      width: Get.size.height * 0.062,
                      height: Get.size.height * 0.062,
                      child:SvgPicture.asset(
                          'assets/image/login/kakao.svg'),
                    ),
                    Container(
                      alignment:Alignment.center,
                      width: (Get.size.width * 0.733),
                      height: Get.size.height * 0.062,
                      child:Text(
                        'KAKAO로 로그인',
                        style: TextStyle(
                          color: Color(0xff392020),
                          fontFamily: 'AppleSDGothicNeoR00',
                        ),
                      ),
                    )
                  ],
                )
              ),
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
                child:Stack(
                  children: [
                    Container(
                      alignment:Alignment.center,
                      width: Get.size.height * 0.062,
                      height: Get.size.height * 0.062,
                      child:SvgPicture.asset(
                          'assets/image/login/google.svg'),
                    ),
                    Container(
                      alignment:Alignment.center,
                      width: (Get.size.width * 0.733),
                      height: Get.size.height * 0.062,
                      child:Text(
                        'GOOGLE로 로그인',
                        style: TextStyle(
                          color: Color(0xff392020),
                          fontFamily: 'AppleSDGothicNeoR00',
                        ),
                      ),
                    )
                  ],
                )
              ),
            ),
            Container(
              height: Get.size.height * 0.03,
            ),
            TextButton(
              onPressed: () {
                      Get.toNamed('/root');
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
