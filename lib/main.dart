import 'package:evsolution/views/01.login_view.dart';
import 'package:evsolution/views/02_0.root_view.dart';
import 'package:evsolution/views/02_2.map_view.dart';
import 'package:evsolution/views/02_3.navisearch_view.dart';
import 'package:evsolution/views/03_faultreport_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'binding/binding.dart';

void main() async {
  KakaoSdk.init(nativeAppKey: '66e672ee1880f39278d8540da0a88613');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  runApp(GetMaterialApp(
    home: AnimatedSplashScreen(
      nextScreen: Login(),
      splash: 'assets/video/splash_home.mp4',
    ),
    // initialRoute: "/login",
    initialBinding: Init(),
    getPages: [
      GetPage(name: "/login", page: () => Login()),
      GetPage(name: "/root", page: () => Root()),
      GetPage(name: "/freport", page: () => Faultreport()),
      GetPage(name: "/Map", page: () => map()),
      GetPage(name: "/Navi", page: () => Navisearch()),
    ],
  ));
}
