import 'dart:async';
import 'dart:convert';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:evsolution/controller/stats_controller.dart';
import 'package:evsolution/model/dorojuso.dart';
import 'package:evsolution/model/reverseGeocoding.dart';
import 'package:evsolution/model/routers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:evsolution/model/juso.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:evsolution/model/geocoding.dart';

enum naviWidgetName { savesearch, resultsearch, getresult, evstationlist }

class Navicontroller extends GetxController {
  static Navicontroller get to => Get.find();
  var dio = Dio(BaseOptions(baseUrl: Statecontroller.to.serverUrl.value));

  RxString starttext = ''.obs;
  RxString endtext = '도착지'.obs;
  final currentPostion = LatLng(37.5646279797785, 126.97756750354343).obs;
  RxList<DoroJuso> jusoliststart = <DoroJuso>[].obs;
  RxList<DoroJuso> jusolistend = <DoroJuso>[].obs;
  RxSet<Marker> naviMarker = <Marker>{}.obs;
  final naviindex = 0.obs;
  RxSet<Polyline> routerlist = <Polyline>{}.obs;
  final storage = new FlutterSecureStorage();
  RxList<String> searchliststart = <String>[].obs;
  RxList<String> searchlistend = <String>[].obs;

  void oninit() async {
    // await storage.delete(key: 'searchlist');
    getpostion();
    listsearch();
  }

  void onclose() {
    EasyDebounce.cancel('jusosearch');
    Navicontroller.to.naviindex(1);
    Navicontroller.to.jusoliststart.clear();
    Navicontroller.to.jusolistend.clear();
    Navicontroller.to.searchliststart.clear();
    Navicontroller.to.searchlistend.clear();
    Navicontroller.to.routerlist.clear();
    Navicontroller.to.naviMarker.clear();
  }

  //현제위치 가져져와서 표시하기
  void getpostion() async {
    //현제위치
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //현제위치
    currentPostion(LatLng(position.latitude, position.longitude));
    //마커추가
    Navicontroller.to.naviMarker.add(Marker(
      markerId: MarkerId('start'),
      position: LatLng(position.latitude, position.longitude),
    ));

    //주소추출
    jusoliststart.clear();
    var prams = {
      'version': '1',
      'format': 'json',
      'callback': 'result',
      'appKey': 'l7xx71089ab0fff0470e97ab985297aa1343',
      'lon': position.longitude,
      'lat': position.latitude,
      'addressType': 'A10',
    };

    var response = await Dio().get(
        'https://apis.openapi.sk.com/tmap/geo/reversegeocoding',
        queryParameters: prams);
    if (response.statusCode == 200) {
      Map<String, dynamic> responseMap = jsonDecode(response.toString());
      var temp = ReversGeocoding.fromJson(responseMap);

      if (temp.addressInfo!.buildingName.toString() == ' ') {
        starttext(temp.addressInfo!.buildingName.toString());
      } else {
        starttext(temp.addressInfo!.roadName.toString() +
            '-' +
            temp.addressInfo!.buildingIndex.toString());
      }
    }
  }

  //주소검색
  void getjuso(String text,String kindvalue) {
    EasyDebounce.debounce('jusosearch', Duration(milliseconds: 200), () async {
      
      
      var prams = {
        'confmKey': 'U01TX0FVVEgyMDIxMTIyMDAxMDk1NjExMjA0ODQ=',
        'currentPage': '1',
        'countPerPage': '15',
        'keyword': text,
        'resultType': 'json',
      };

      var response = await Dio().get(
          'https://www.juso.go.kr/addrlink/addrLinkApi.do',
          queryParameters: prams);
      if (response.statusCode == 200) {
        List<DoroJuso> info =
            (response.data["results"]["juso"]).map<DoroJuso>((json) {
          return DoroJuso.fromJson(json);
        }).toList();

        if(kindvalue == 'start'){
          jusoliststart.clear();  
          info.forEach((element) {
            jusoliststart.add(element);
          });
          naviindex(2);
        }else{
          jusolistend.clear();  
          info.forEach((element) {
            jusolistend.add(element);
          });
          naviindex(3);
        }
        
      }
      
      
    });
  }

  //주소위치로 이동
  void clicktojuso(Completer<GoogleMapController> mcontroller,
      SheetController sc, int i, BuildContext context,String kind) async {
    FocusScope.of(context).unfocus();
    EasyDebounce.cancel('jusosearch');
    if(kind == 'start'){
      //주소xy좌표구하기
    Geocoding? info = null;
    var params = {
      'version': '1',
      'format': 'json',
      'callback': 'result',
      'appKey': 'l7xx71089ab0fff0470e97ab985297aa1343',
      'coordType': 'WGS84GEO',
      'city_do': Navicontroller.to.jusoliststart[i].siNm,
      'gu_gun': Navicontroller.to.jusoliststart[i].sggNm,
      'dong': Navicontroller.to.jusoliststart[i].emdNm,
      'bunji': Navicontroller.to.jusoliststart[i].lnbrSlno.toString() != '0'
          ? Navicontroller.to.jusoliststart[i].lnbrMnnm.toString() +
              '-' +
              Navicontroller.to.jusoliststart[i].lnbrSlno.toString()
          : Navicontroller.to.jusoliststart[i].lnbrMnnm
    };
    var response = await Dio().get(
        'https://apis.openapi.sk.com/tmap/geo/geocoding',
        queryParameters: params);
    if (response.statusCode == 200) {
      info = Geocoding.fromJson(response.data["coordinateInfo"]);
    }

    // String juso = Navicontroller.to.jusolist[i].upperAddrName.toString() +
    //     Navicontroller.to.jusolist[i].middleAddrName.toString() +
    //     Navicontroller.to.jusolist[i].lowerAddrName.toString();
    // List<String> temp = Navicontroller.to.searchlist[i].split('/');

    double lat = double.parse(info!.lat.toString());
    double lon = double.parse(info.lon.toString());

    if (!mcontroller.isCompleted) return;
    final cont = await mcontroller.future;
    cont.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(lat, lon),
        zoom: 14.0,
      ),
    ));
    //검색창축소
    sc.snapToExtent(0.3);
    //마커추가
    naviMarker.add(Marker(
      markerId: MarkerId('start'),
      position: LatLng(lat, lon),
    ));

    //최근검색추가
    innersaveresultjuso(Navicontroller.to.jusoliststart[i], lat, lon,'start');

    //리스트초기화
    jusoliststart.clear();
    naviindex(2);

    }else if(kind == 'end'){
      //주소xy좌표구하기
    Geocoding? info = null;
    var params = {
      'version': '1',
      'format': 'json',
      'callback': 'result',
      'appKey': 'l7xx71089ab0fff0470e97ab985297aa1343',
      'coordType': 'WGS84GEO',
      'city_do': Navicontroller.to.jusolistend[i].siNm,
      'gu_gun': Navicontroller.to.jusolistend[i].sggNm,
      'dong': Navicontroller.to.jusolistend[i].emdNm,
      'bunji': Navicontroller.to.jusolistend[i].lnbrSlno.toString() != '0'
          ? Navicontroller.to.jusolistend[i].lnbrMnnm.toString() +
              '-' +
              Navicontroller.to.jusolistend[i].lnbrSlno.toString()
          : Navicontroller.to.jusolistend[i].lnbrMnnm
    };
    var response = await Dio().get(
        'https://apis.openapi.sk.com/tmap/geo/geocoding',
        queryParameters: params);
    if (response.statusCode == 200) {
      info = Geocoding.fromJson(response.data["coordinateInfo"]);
    }

    // String juso = Navicontroller.to.jusolist[i].upperAddrName.toString() +
    //     Navicontroller.to.jusolist[i].middleAddrName.toString() +
    //     Navicontroller.to.jusolist[i].lowerAddrName.toString();
    // List<String> temp = Navicontroller.to.searchlist[i].split('/');

    double lat = double.parse(info!.lat.toString());
    double lon = double.parse(info.lon.toString());

    if (!mcontroller.isCompleted) return;
    final cont = await mcontroller.future;
    cont.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(lat, lon),
        zoom: 14.0,
      ),
    ));
    //검색창축소
    sc.snapToExtent(0.3);
    //마커추가
    naviMarker.add(Marker(
      markerId: MarkerId('end'),
      position: LatLng(lat, lon),
    ));

    //최근검색추가
    innersaveresultjuso(Navicontroller.to.jusolistend[i], lat, lon,'end');

    //리스트초기화
    jusolistend.clear();
    naviindex(3);
    }
    
  }

  //화면이동시 marker이동
  void setMarker(CameraPosition position) {
    naviMarker.clear();
    Navicontroller.to.naviMarker.add(Marker(
      markerId: MarkerId('start'),
      position: LatLng(position.target.latitude, position.target.longitude),
    ));

    getpostion();
  }

  void searchStarttoEnd(Completer<GoogleMapController> mcontroller) async {
    List<MyProperties> mp = [];
    double startx = 0.0, starty = 0.0, endx = 0.0, endy = 0.0;
    naviMarker.forEach((e) {
      if (e.markerId == MarkerId('start')) {
        startx = e.position.longitude;
        starty = e.position.latitude;
      } else if (e.markerId == MarkerId('end')) {
        endx = e.position.longitude;
        endy = e.position.latitude;
      }
    });

    var prams = {
      "version": "1",
      "format": "json",
      "callack": "result",
      "appKey": "l7xx71089ab0fff0470e97ab985297aa1343",
      "startX": startx,
      "startY": starty,
      "endX": endx,
      "endY": endy,
      "reqCoordType": "WGS84GEO",
      "resCoordType": "WGS84GEO",
      "searchOption": '0',
      "trafficInfo": 'Y'
    };
    print(prams);
    var response = await Dio()
        .get('https://apis.openapi.sk.com/tmap/routes', queryParameters: prams);

    List<Features> temp = [];
    if (response.statusCode == 200) {
      temp = (response.data["features"]).map<Features>((json) {
        return Features.fromJson(json);
      }).toList();
    }
    temp.forEach((e) {
      List<LatLng> coorslist = [];
      String temp = e.geometry!.coordinates.toString().replaceAll("[", "");
      temp = temp.replaceAll("]", "");
      var templist = temp.split(",");

      for (int i = 0; i <= templist.length - 2; i += 2) {
        // for (int i = 0; i < templist.length; i++) {
        coorslist.add(LatLng(double.parse(templist[i + 1].toString()),
            double.parse(templist[i].toString())));
        // i++;
      }
      e.properties!.totalDistance.toString();

      mp.add(MyProperties(
          totalDistance: e.properties!.totalDistance,
          totalTime: e.properties!.totalTime,
          totalFare: e.properties!.totalFare,
          taxiFare: e.properties!.taxiFare,
          index: e.properties!.index,
          pointIndex: e.properties!.pointIndex,
          name: e.properties!.name,
          description: e.properties!.description,
          nextRoadName: e.properties!.nextRoadName,
          turnType: e.properties!.turnType,
          pointType: e.properties!.pointType,
          lineIndex: e.properties!.lineIndex,
          distance: e.properties!.distance,
          time: e.properties!.time,
          roadType: e.properties!.roadType,
          facilityType: e.properties!.facilityType,
          coordinates: coorslist));
    });
    //경로그리기
    // - 0: 고속도로
    // - 1: 자동차전용
    // - 2: 국도
    // - 3: 국가지원 지방도
    // - 4: 지방도
    // - 5: 주요도로1(일반도로 1중 6,5차로)
    // - 6: 주요도로2(일반도로 1 중 4,3 차로)
    // - 7: 주요도로3(일반도로 1 중 2차로)
    // - 8: 기타도로1(일반도로 1 중 1차로)
    // - 9: 기타도로2(이면도로)
    // - 10: 페리항로
    // - 11: 단지내도로(아파트단지내 도로)
    // - 12: 단지 내 도로(시장내 도로)
    // - 16: 일반도로
    // - 20: 번화가링크
    int index = 0;
    for (var v in mp) {
      Color color = Colors.red;
      List<LatLng> points = [];
      v.coordinates?.forEach((e) {
        points.add(LatLng(e.latitude, e.longitude));
      });

      if (v.roadType == 0) {
        color = Colors.red;
      } else if (v.roadType == 16) {
        color = Colors.green;
      } else {
        color = Colors.blue;
      }

      routerlist.add(Polyline(
          polylineId: PolylineId(index.toString()),
          points: points,
          color: color,
          width: 5));
      index++;
    }

    //bound설정
    double swx = 0.0, swy = 0.0, nex = 0.0, ney = 0.0;
    startx < endx ? {swx = startx, nex = endx} : {swx = endx, nex = startx};
    starty < endy ? {swy = starty, ney = endy} : {swy = endy, ney = endy};
    LatLngBounds bound =
        LatLngBounds(southwest: LatLng(swy, swx), northeast: LatLng(ney, nex));
    final cont = await mcontroller.future;
    cont.animateCamera(CameraUpdate.newLatLngBounds(bound, 100));

    // routerlist.add(Polyline(
    //   polylineId: PolylineId('1'),
    //   points: points_0,
    //   color: Colors.red,
    // ));
    // routerlist.add(Polyline(
    //   polylineId: PolylineId('2'),
    //   points: points_1,
    //   color: Colors.blue,
    // ));
    // routerlist.add(Polyline(
    //   polylineId: PolylineId('3'),
    //   points: points_2,
    //   color: Colors.green,
    // ));
    // print(routerlist.length);
    // routerlist.forEach((e) {
    //   print("${e.points} to ${e.color}");
    // });
    // if (response.statusCode == 200) {
    // List<features> info =(response.data["features"]).map<features>((json) {
    //     return features.fromJson(json);
    //   }).toList();
    //   info.forEach((element) {
    //     print(element.toJson()["geometry"]["type"]);
    //     if(element.toJson()["geometry"]["type"] == 'LineString'){

    //       List<GeometryList> temp =(element.toJson()["geometry"]).map<GeometryList>((json) {
    //         return GeometryList.fromJson(json);
    //       }).toList();
    //       temp.forEach((e) {
    //         print('lineString ${e.toString()}');
    //        });
    //     }
    //     print(element.toJson()["properties"]);
    //   });
    // }
    // var response = await dio.post('/navigation?startY=${startx}&startX=${starty}&endY=${endx}&endX=${endy}');

    // if(response.statusCode == 200){
    //   List<LatLng> points=[];
    //   var temp = response.data.toString().replaceAll(']', '');
    //   temp = temp.replaceAll('[', '');
    //   temp = temp.replaceAll(' ', '');
    //    List output = temp.split('}');

    //    for(int i =0;i<output.length-1;i++){
    //      var element = output[i].toString();
    //      var result=element;
    //     if(element[0] == ','){
    //       result = element.toString().substring(1,element.length);
    //     }
    //      var e  = result.toString().replaceAll('{', '');
    //      var xy = e.split(',');
    //      var x = xy[1].toString().split(':');
    //      var y = xy[0].toString().split(':');
    //     points.add(LatLng(double.parse(x[1]),double.parse(y[1])));

    //    }
    //     //경로그리기
    //     routerlist.add(Polyline(
    //       polylineId: PolylineId('router'),
    //       points:points,
    //       color:Colors.red,
    //     ));

    // }
  }

  //검색결과 마커셋팅
  clicktosearchlist(Completer<GoogleMapController> mcontroller,
      SheetController sc, int i,String kindvalue) async {
    List<String> temp = Navicontroller.to.searchlistend[i].split('/');

    double lat = double.parse(temp[2]);
    double lon = double.parse(temp[3]);

    if (!mcontroller.isCompleted) return;
    final cont = await mcontroller.future;
    cont.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(lat, lon),
        zoom: 14.0,
      ),
    ));
    //검색창축소
    sc.snapToExtent(0.3);
    if(kindvalue =='start'){
      //마커추가
      naviMarker.add(Marker(
        markerId: MarkerId('end'),
        position: LatLng(lat, lon),
      ));

      //리스트초기화
      jusoliststart.clear();
    }else{
      //마커추가
      naviMarker.add(Marker(
        markerId: MarkerId('end'),
        position: LatLng(lat, lon),
      ));

      //리스트초기화
      jusolistend.clear();
    }
    
    naviindex(3);
  }

  //히스토리검색 셋팅
  void listsearch() async {
    if (await storage.containsKey(key: 'searchliststart')) {
      String? searchtext = await storage.read(key: 'searchliststart');
      List<dynamic> searchliststart = searchtext.toString().split(',');
      searchliststart.forEach((element) {
        Navicontroller.to.searchliststart.add(element);
      });
    }
    if (await storage.containsKey(key: 'searchlistend')) {
      String? searchtext = await storage.read(key: 'searchlistend');
      List<dynamic> setsearchlistend = searchtext.toString().split(',');
      setsearchlistend.forEach((element) {
        Navicontroller.to.searchlistend.add(element);
      });
    }
  }

  //검색결과 내부저장
  Future<void> innersaveresultjuso(DoroJuso i, double lat, double lon,String kind) async {
    String searchlist='';
    if(kind == 'start'){
       searchlist='searchliststart';
    }else if(kind == 'end'){
       searchlist ='searchlistend';
    }
    var searchresult;
    List<dynamic> templist = [];
    templist.add(i.bdNm.toString() +
        '/' +
        i.roadAddrPart1.toString() +
        '/' +
        lat.toString() +
        '/' +
        lon.toString());
    if (await storage.containsKey(key: searchlist)) {
      searchresult = await storage.read(key: searchlist);
      templist.addAll(searchresult.toString().split(','));
    }
    //중복아이템 삭제
    for (int i = 1; i < templist.length; i++) {
      var temp = templist[i].toString().replaceAll('[', '');
      temp = temp.replaceAll(']', '');
      if (templist[0].toString().replaceAll(" ", "") ==
          temp.toString().replaceAll(" ", "")) {
        templist.removeAt(i);
      }
    }
    //10개이상이면 마지막목록 삭제
    while (templist.length > 10) {
      templist.removeAt(templist.length - 1);
    }

    var temp = templist.toString().replaceAll('[', '');
    temp = temp.replaceAll(']', '');

    await storage.write(
      key: searchlist,
      value: temp,
    );
  }

  //검색결과삭제
  Future<void> innerdeleteresultjuso(int index) async {
    Navicontroller.to.jusolistend.removeAt(index);
    await storage.delete(key: 'searchlist');
    if (Navicontroller.to.jusolistend.length != 0) {
      await storage.write(
        key: 'searchlist',
        value: Navicontroller.to.jusolistend.join(','),
      );
    }
  }
}
