import 'package:evsolution/controller/home_controller.dart';
import 'package:evsolution/controller/map_controller.dart';
import 'package:evsolution/controller/navi_controller.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

enum RouteName { home, map, navisearch, uselist, myinfo }

class Rootcontroller extends GetxController {
  static Rootcontroller get to => Get.find();
  //현제 바텀탭 번호
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
    super.onInit();
    //권한설정
    _handlePermission();
  }

  void changeIndex(int index) {
    currentIndex(index);
    switch (index) {
      case 0:
        Homcontroller.to.onClose();
        Homcontroller.to.onInit();
        break;
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

  Future<void> _handlePermission() async {
    //권한확인
    permission.forEach((element) async {
      if (!await element.isGranted) {
        await element.request();
      }
    });
  }
}
