import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:evsolution/controller/stats_controller.dart';
import 'package:evsolution/model/userinfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:video_player/video_player.dart';

class Logincontroller extends GetxController {
  static Logincontroller get to => Get.find();

  static final storage = new FlutterSecureStorage();
  var dio = Dio(BaseOptions(baseUrl: Statecontroller.to.serverUrl.value));
  //카카오톡 설치여부
  RxBool iskakaotalkInstalled = false.obs;

  //splash
  late VideoPlayerController? controller;
  late Future<void>? initialplayer;

  @override
  void onInit() async {
    super.onInit();
    getlogininfo();
    initKakaoTalkInstalled();
    //splash
    controller = VideoPlayerController.asset('assets/video/plash_home.mp4');
    initialplayer = controller!.initialize();
  }

  // google login
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      print(googleUser!.displayName.toString());
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      if (googleUser.email != null) {
        setlogininfo(
            googleUser.email, 'google', googleAuth.accessToken.toString());
        insertlogininfoDB(
            googleUser.email, 'google', googleAuth.accessToken.toString());
      }

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print(e);
    }
  }

  // google logout
  Future<void> signOutWithGoogle() async {
    Statecontroller.to.loginType('');
    Statecontroller.to.loginId('');
    FirebaseAuth.instance.signOut();
    Get.offNamed('/login');
  }

  //naver login
  Future<void> loginWithNaver() async {
    log("naver login ");
    try {
      final NaverLoginResult result = await FlutterNaverLogin.logIn();
      final bool log = await FlutterNaverLogin.isLoggedIn;

      NaverAccessToken token = await FlutterNaverLogin.currentAccessToken;
      if (result.account.email != null) {
        setlogininfo(
            result.account.email, 'naver', token.accessToken.toString());
        insertlogininfoDB(
            result.account.email, 'naver', token.accessToken.toString());
      }
    } catch (e) {
      Get.snackbar('주의', '네이버앱을 설치해주세요');
      print(e.toString());
    }
  }

  //naver logout
  Future<void> logoutWithNaver() async {
    FlutterNaverLogin.logOut();
    Statecontroller.to.loginType('');
    Statecontroller.to.loginId('');
    Get.offNamed('/login');
  }

  //카카오톡 설치여부 확인
  initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    iskakaotalkInstalled(installed);
  }

  //웹로그인
  loginWithkakao() async {
    try {
      await UserApi.instance.loginWithKakaoTalk();
      await UserApi.instance.me();

      var user = await UserApi.instance.me();
      var token;
      await UserApi.instance.accessTokenInfo().then((value) => token = value);
      if (user.kakaoAccount!.email != null) {
        setlogininfo(
            user.kakaoAccount!.email.toString(), 'kakao', token.id.toString());
        insertlogininfoDB(
            user.kakaoAccount!.email.toString(), 'kakao', token.id.toString());
      }
    } catch (e) {
      print(e.toString());
    }
  }

  loginWithTalk() async {
    try {
      await UserApi.instance.loginWithKakaoAccount();
      var user = await UserApi.instance.me();
      var token = await UserApi.instance.accessTokenInfo();
      if (user.kakaoAccount!.email != null) {
        setlogininfo(
            user.kakaoAccount!.email.toString(), 'kakao', token.id.toString());
        insertlogininfoDB(
            user.kakaoAccount!.email.toString(), 'kakao', token.id.toString());
      }
    } catch (e) {
      print('error on login: $e');
    }
  }

  logoutWithTalk() async {
    try {
      await UserApi.instance.logout();
      Statecontroller.to.loginType('');
      Statecontroller.to.loginId('');
      Get.offNamed('/login');
    } catch (e) {
      print(e.toString());
    }
  }

  //apple 로그인
  // Future<UserCredential> signInWithApple() async {
  Future<void> signInWithApple() async {
    log('apple login !');

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    FirebaseAuth.instance.signInWithCredential(oauthCredential).then((value) {
      setlogininfo(value.user!.email.toString(), 'apple',
          value.credential!.token.toString());
      insertlogininfoDB(value.user!.email.toString(), 'apple',
          value.credential!.token.toString());
    }).catchError((e) {
      print(e);
    });

    // return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  //apple logout
  Future<void> signOutWithApple() async {
    Statecontroller.to.loginType('');
    Statecontroller.to.loginId('');
    FirebaseAuth.instance.signOut();
    Get.offNamed('/login');
  }

  //최초로그인정보 저장 휴대폰 내부 저장소
  setlogininfo(String id, String kind, String token) async {
    await storage.write(key: "id", value: id); //로그인아이디
    await storage.write(key: "kind", value: kind); //로그인종류
    await storage.write(key: "token", value: token); //로그인토큰
  }

  //로그아웃시 로그인정보 리셋
  resetlogininfo() async {
    await storage.deleteAll();
  }

  //자동로그인 설정
  getlogininfo() async {
    var userInfo = await storage.readAll();

    if (userInfo.isNotEmpty) {
      print(userInfo['id'].toString());
      print(userInfo['kind'].toString());
      var response = await dio.get('/login/user-info', queryParameters: {
        'id': userInfo['id'].toString(),
        'kind': userInfo['kind'].toString()
      });
      if (response.statusCode == 200) {
        if (userInfo['id'] == response.data['id'] &&
            userInfo['kind'] == response.data['kind']) {
          Statecontroller.to.loginType(response.data['kind']);
          Statecontroller.to.loginId(response.data['id']);
          Get.offNamed('/root');
        }
      }
    }
  }

  //최초 로그인정보 저장 데이터베이스
  insertlogininfoDB(String id, String kind, String token) async {
    String? fmtoken = await FirebaseMessaging.instance.getToken();
    if (fmtoken != null) {
      var response = await dio.post('/login/user-info',
          data: {'id': id, 'kind': kind, 'token': token, 'fmtoken': fmtoken});

      if (response.statusCode == 200) {
        if (id == response.data['id'] && kind == response.data['kind']) {
          Statecontroller.to.loginType(response.data['kind']);
          Statecontroller.to.loginId(response.data['id']);
          Get.offNamed('/root');
        }
      }
    }
  }
}
