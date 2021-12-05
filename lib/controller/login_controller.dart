import 'package:dio/dio.dart';
import 'package:evsolution/controller/stats_controller.dart';
import 'package:evsolution/model/userinfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:kakao_flutter_sdk/user.dart';

class Logincontroller extends GetxController {
  static Logincontroller get to => Get.find();

  static final storage = new FlutterSecureStorage();
  var dio = Dio(BaseOptions(baseUrl: Statecontroller.to.serverUrl.value));
  //카카오톡 설치여부
  RxBool iskakaotalkInstalled = false.obs;
   @override
  void onInit() async {
    super.onInit();
    getlogininfo();
    initKakaoTalkInstalled();
  }

  // google login
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print(googleUser.displayName);
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
    print("naver login ");
    try {
      final NaverLoginResult result = await FlutterNaverLogin.logIn();
      final bool log = await FlutterNaverLogin.isLoggedIn;

      print(result.account.name);
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
    List<Userinfo> info;
    if (userInfo.isNotEmpty) {
      print(userInfo.toString());
      var response = await dio.post('/login/getuserinfo', data: {
        'id': userInfo['id'].toString(),
        'kind': userInfo['kind'].toString()
      });
      print(response.data);
      if (response.statusCode == 200) {
        info = (response.data).map<Userinfo>((json) {
          return Userinfo.fromJson(json);
        }).toList();
        if (info.length == 1) {
          Statecontroller.to.loginType(info[0].kind);
          Statecontroller.to.loginId(info[0].id);
          Get.offNamed('/root');
        }
      }
    }
  }

  //최초 로그인정보 저장 데이터베이스
  insertlogininfoDB(String id, String kind, String token) async {
    List<Userinfo> info;
    String? fmtoken =await FirebaseMessaging.instance.getToken() ;
    if(fmtoken != null) {
      var response = await dio.post('/login/userinfo',
        data: {'id': id, 'kind': kind, 'token': token,'fmtoken':fmtoken});
    print(response.data);
    if (response.statusCode == 200) {
      info = (response.data).map<Userinfo>((json) {
        return Userinfo.fromJson(json);
      }).toList();
      if (info.length == 1) {
        Statecontroller.to.loginType(info[0].kind);
        Statecontroller.to.loginId(info[0].id);
        Get.offNamed('/root');
      }
    }
    }

    
  }
}