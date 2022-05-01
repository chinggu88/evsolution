import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class Statecontroller extends GetxController {
  static Statecontroller get to => Get.find();

  RxString serverUrl = ''.obs;
  RxString loginType = ''.obs;
  RxString loginId = ''.obs;

  //splash
  late VideoPlayerController? controller;
  late Future<void>? initialplayer;

  @override
  void onInit() async {
    super.onInit();
    // serverUrl = 'http://apis.data.go.kr/B552584/EvCharger/getChargerInfo'.obs;
    // serverUrl = 'http://222.108.135.234:8001/'.obs;
    serverUrl = 'https://3434-106-101-128-220.jp.ngrok.io'.obs;
    controller = VideoPlayerController.asset('assets/video/plash_home.mp4');
    initialplayer = controller!.initialize();

    controller!.setLooping(true);
  }
  //주소키 :: U01TX0FVVEgyMDIxMTIyMDAxMDk1NjExMjA0ODQ=

}
