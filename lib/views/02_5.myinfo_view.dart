import 'package:evsolution/controller/login_controller.dart';
import 'package:evsolution/controller/stats_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class Myinfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: Get.size.height * 0.05,
          ),
          Container(
            alignment: Alignment.center,
            child: Text("마이페이지"),
          ),
          SizedBox(
            height: Get.size.height * 0.1,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Get.size.width * 0.05,
                ),
                SizedBox(width: Get.size.width * 0.8, child: const Text("앱설정")),
                GestureDetector(
                  onTap: ()=>Get.dialog(const Text('test1)')),
                  child: SizedBox(
                      width: Get.size.width * 0.15,
                      child: const Icon(Icons.arrow_forward_ios)),
                ),
              ],
            ),
          ),
          SizedBox(
            height: Get.size.height * 0.1,
            child: GestureDetector(
              onTap: (() => Get.toNamed('/setting')),
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: Get.size.width * 0.05,
                  ),
                  SizedBox(width: Get.size.width * 0.8, child: const Text("마이차저 설정")),
                  SizedBox(
                      width: Get.size.width * 0.15,
                      child: const Icon(Icons.arrow_forward_ios)),
                ],
              ),
            ),
          ),
          SizedBox(
            height: Get.size.height * 0.1,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Get.size.width * 0.05,
                ),
                SizedBox(width: Get.size.width * 0.8, child: Text("이용약관 및 정책")),
                SizedBox(
                    width: Get.size.width * 0.15,
                    child: const Icon(Icons.arrow_forward_ios)),
              ],
            ),
          ),
          SizedBox(
            height: Get.size.height * 0.1,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Get.size.width * 0.05,
                ),
                Container(width: Get.size.width * 0.8, child: Text("버전정보")),
                Container(
                    width: Get.size.width * 0.15,
                    child: Icon(Icons.arrow_forward_ios)),
              ],
            ),
          ),
          Container(
            height: Get.size.height * 0.1,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Get.size.width * 0.05,
                ),
                Container(width: Get.size.width * 0.8, child: Text("서비스 소개")),
                Container(
                    width: Get.size.width * 0.15,
                    child: Icon(Icons.arrow_forward_ios)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
