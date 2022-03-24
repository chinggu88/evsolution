import 'package:evsolution/controller/freport_controller.dart';
import 'package:evsolution/controller/login_controller.dart';
import 'package:evsolution/controller/map_controller.dart';
import 'package:evsolution/controller/navi_controller.dart';
import 'package:evsolution/controller/root_controller.dart';
import 'package:evsolution/controller/stats_controller.dart';
import 'package:get/get.dart';

class Init extends Bindings {
  @override
  void dependencies() {
    Get.put(Statecontroller(),permanent:true);
    // Get.put(Rootcontroller(),permanent:true);
    Get.lazyPut(() => Rootcontroller());
    Get.put(Logincontroller());
    Get.lazyPut(() => Mapcontroller());
    Get.lazyPut(() => Navicontroller());
    Get.lazyPut(() => Freport_controller());
  }
}
