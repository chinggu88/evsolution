
import 'package:get/get.dart';

class Statecontroller extends GetxController {
  static Statecontroller get to => Get.find();

  RxString serverUrl = ''.obs;
  RxString loginType = ''.obs;
  RxString loginId = ''.obs;
  
  @override
  void onInit() async {
    super.onInit();
    // serverUrl = 'http://apis.data.go.kr/B552584/EvCharger/getChargerInfo'.obs;
    // serverUrl = 'http://10.168.0.174:8000/'.obs;
    serverUrl = 'http://222.108.135.234:8001/'.obs;
  }
  //주소키 :: U01TX0FVVEgyMDIxMTIyMDAxMDk1NjExMjA0ODQ=
  
}