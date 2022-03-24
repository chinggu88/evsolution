import 'package:evsolution/controller/map_controller.dart';
import 'package:evsolution/controller/navi_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

enum ErrName { connect, lcd, nocomu, program, breaker, other }

class Freport_controller extends GetxController {
  static Freport_controller get to => Get.find();

  var radio_name = ErrName.connect;
}
