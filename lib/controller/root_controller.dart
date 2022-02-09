import 'package:evsolution/controller/map_controller.dart';
import 'package:evsolution/controller/navi_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

enum RouteName { home, map, navisearch, uselist, myinfo }

class Rootcontroller extends GetxController {
  static Rootcontroller get to => Get.find();
  RxInt currentIndex = 0.obs;
  RxString currentView = 'Home'.obs;

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
