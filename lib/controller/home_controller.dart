import 'package:dio/dio.dart';
import 'package:evsolution/controller/stats_controller.dart';
import 'package:evsolution/model/stationinfo.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class Homcontroller extends GetxController {
  static Homcontroller get to => Get.find();

  //즐겨찾기 정보
  List<Stationinfo> favoriteinfo = <Stationinfo>[].obs;
  var dio = Dio(BaseOptions(baseUrl: Statecontroller.to.serverUrl.value));

  @override
  void onInit() {
    favoritestation();
  }

  //즐겨찾기
  favoritestation() async {
    favoriteinfo.clear();
    //리스트 생성
    var response = await dio.get('/search/favorites', queryParameters: {
      'id': Statecontroller.to.loginId.value,
    });

    if (response.statusCode == 200) {
      var temp = (response.data['evstation']).map<Stationinfo>((json) {
        return Stationinfo.fromJson(json);
      }).toList();
      favoriteinfo.addAll(temp);
    }
  }
}
