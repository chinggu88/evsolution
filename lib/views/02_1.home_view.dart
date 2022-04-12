import 'package:evsolution/controller/home_controller.dart';
import 'package:evsolution/controller/root_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xfff6f6f6),
          elevation: 0,
          leading: Image.asset('assets/image/home/group_325.png'),
          title: Text('마이차져',
              style: TextStyle(
                fontFamily: 'Pretendard',
                color: Color(0xff000000),
                fontSize: 25,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
              )),
          actions: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              width: Get.size.width * 0.061,
              height: Get.size.height * 0.034,
              child: SvgPicture.asset('assets/image/home/notification.svg'),
            )
          ],
        ),
        backgroundColor: Color(0xfff6f6f6),
        body: Column(
          children: [
            SizedBox(height: Get.size.height * 0.026),
            Container(
              height: Get.size.height * 0.097,
              child: Row(
                children: [
                  SizedBox(width: Get.size.width * 0.064),
                  Container(
                    child: Image.asset('assets/image/home/testimge.png'),
                  ),
                  SizedBox(width: Get.size.width * 0.051),
                  Container(
                      width: Get.size.width * 0.51,
                      height: Get.size.height * 0.097,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: Get.size.height * 0.022,
                            child: Text("반갑습니다",
                                style: TextStyle(
                                  fontFamily: 'Pre-Light',
                                  color: Color(0xff858585),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  fontStyle: FontStyle.normal,
                                )),
                          ),
                          Container(
                            height: Get.size.height * 0.03,
                            child: Text("박세라님",
                                style: TextStyle(
                                  fontFamily: 'Pre-Medium',
                                  color: Color(0xff000000),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                )),
                          ),
                          Container(
                            height: Get.size.height * 0.022,
                            child: Text("2020 메르세데츠벤츠 A클래스(4세대)",
                                style: TextStyle(
                                  fontFamily: 'Pre-Medium',
                                  color: Color(0xff858585),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.normal,
                                )),
                          )
                        ],
                      )),
                ],
              ),
            ),
            SizedBox(height: Get.size.height * 0.038),
            GestureDetector(
              onTap: () => Rootcontroller.to.changeIndex(1),
              child: Container(
                width: Get.size.width * 0.91,
                height: Get.size.height * 0.134,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0x1a000000),
                          offset: Offset(2, 2),
                          blurRadius: 4,
                          spreadRadius: 0)
                    ],
                    gradient: LinearGradient(
                        begin:
                            Alignment(0.49999941210803356, 0.7238717377749965),
                        end: Alignment(1.444515475402662, -1.1987297492747653),
                        colors: [
                          const Color(0xff00229b),
                          const Color(0xffd0f6ff)
                        ])),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/image/home/mapicon.svg'),
                    SizedBox(width: Get.size.width * 0.05),
                    new Text("내 주변 충전소 찾기",
                        style: TextStyle(
                          fontFamily: 'Pre-Medium',
                          color: Color(0xffffffff),
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ))
                  ],
                ),
              ),
            ),
            SizedBox(height: Get.size.height * 0.013),
            GestureDetector(
              onTap: () => Rootcontroller.to.changeIndex(2),
              child: Container(
                width: Get.size.width * 0.91,
                height: Get.size.height * 0.134,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    boxShadow: [
                      BoxShadow(
                          color: const Color(0x1a000000),
                          offset: Offset(2, 2),
                          blurRadius: 4,
                          spreadRadius: 0)
                    ],
                    gradient: LinearGradient(
                        begin:
                            Alignment(0.49999941210803356, 0.7238717377749965),
                        end: Alignment(1.444515475402662, -1.1987297492747653),
                        colors: [
                          const Color(0xff00229b),
                          const Color(0xffd0f6ff)
                        ])),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset('assets/image/home/naviicon.svg'),
                    SizedBox(width: Get.size.width * 0.05),
                    new Text("경로상 충전소 찾기",
                        style: TextStyle(
                          fontFamily: 'Pre-Medium',
                          color: Color(0xffffffff),
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ))
                  ],
                ),
              ),
            ),
            SizedBox(height: Get.size.height * 0.05),
            Row(
              children: [
                SizedBox(width: Get.size.width * 0.05),
                Container(
                  alignment: Alignment.centerLeft,
                  child: new Text("즐겨찾는 충전소",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        color: Color(0xff4b4b4b),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        letterSpacing: 0.5,
                      )),
                ),
              ],
            ),
            SizedBox(height: Get.size.height * 0.006),
            Obx(() {
              return Homcontroller.to.favoriteinfo.length != 0
                  ? Row(
                      children: [
                        SizedBox(width: Get.size.width * 0.05),
                        Expanded(
                            child: Container(
                          height: Get.size.height * 0.2,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: Homcontroller.to.favoriteinfo.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  children: [
                                    new Container(
                                      width: Get.size.width * 0.397,
                                      height: Get.size.height * 0.191,
                                      decoration: new BoxDecoration(
                                        color: Color(0xffffffff),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color(0x19000000),
                                              offset: Offset(2, 2),
                                              blurRadius: 4,
                                              spreadRadius: 0)
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                              height: Get.size.height * 0.023),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                  'assets/image/home/start_icon.svg'),
                                              SizedBox(
                                                  width:
                                                      Get.size.width * 0.031),
                                              new Text(
                                                  Homcontroller
                                                      .to
                                                      .favoriteinfo[index]
                                                      .statNm
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontFamily: 'Pretendard',
                                                    color: Color(0xff363434),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    fontStyle: FontStyle.normal,
                                                  ))
                                            ],
                                          ),
                                          SizedBox(
                                              height: Get.size.height * 0.045),
                                          Row(
                                            children: [
                                              SizedBox(
                                                  width:
                                                      Get.size.width * 0.039),
                                              new Text("29분",
                                                  style: TextStyle(
                                                    fontFamily: 'Pretendard',
                                                    color: Color(0xff323232),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle: FontStyle.normal,
                                                    letterSpacing: 0.5,
                                                  )),
                                            ],
                                          ),
                                          SizedBox(
                                              height: Get.size.height * 0.015),
                                          Row(
                                            children: [
                                              SizedBox(
                                                  width:
                                                      Get.size.width * 0.039),
                                              new Text("5.9km",
                                                  style: TextStyle(
                                                    fontFamily: 'Pretendard',
                                                    color: Color(0xff4b4b4b),
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w300,
                                                    fontStyle: FontStyle.normal,
                                                    letterSpacing: 0.5,
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: Get.size.width * 0.02,
                                      color: Color(0xfff6f6f6),
                                    )
                                  ],
                                );
                              }),
                        )),
                      ],
                    )
                  : Container(
                      child: Expanded(
                          child: Center(child: Text('즐겨찾기 목록이 없습니다.'))),
                    );
            })
          ],
        ));
  }
}
