import 'package:get/get.dart';
enum RouteName {home,map,navisearch,uselist,myinfo}

class Rootcontroller extends GetxController {
  static Rootcontroller get to => Get.find();
  RxInt currentIndex=0.obs;
  RxString currentView = 'Home'.obs;
  void changeIndex(int index){
    currentIndex(index);
  }
 
}