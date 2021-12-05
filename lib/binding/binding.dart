import 'package:evsolution/controller/login_controller.dart';
import 'package:evsolution/controller/root_controller.dart';
import 'package:evsolution/controller/stats_controller.dart';
import 'package:get/get.dart';
class Init extends Bindings{
  @override
  void dependencies(){
    Get.put(Statecontroller());
    Get.put(Logincontroller());
    Get.put(Rootcontroller());
  }
}