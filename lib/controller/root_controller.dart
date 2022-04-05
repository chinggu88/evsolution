import 'package:evsolution/controller/map_controller.dart';
import 'package:evsolution/controller/navi_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

enum RouteName { home, map, navisearch, uselist, myinfo }

class Rootcontroller extends GetxController {
  static Rootcontroller get to => Get.find();
  RxInt currentIndex = 0.obs;
  RxString currentView = 'Home'.obs;
  //권한목록
  List<Permission> permission = [
    Permission.location,
    Permission.bluetooth,
    Permission.camera
  ];
  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    //권한설정
  }

  void changeIndex(int index) {
    currentIndex(index);
    switch (index) {
      case 1:
        Mapcontroller.to.onClose();
        Mapcontroller.to.onInit();
        break;
      case 2:
        Navicontroller.to.onclose();
        Navicontroller.to.oninit();
        break;
    }
  }
}
