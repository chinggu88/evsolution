import 'dart:async';
import 'dart:convert';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:evsolution/controller/stats_controller.dart';
import 'package:evsolution/model/dorojuso.dart';
import 'package:evsolution/model/reverseGeocoding.dart';
import 'package:evsolution/model/routers.dart';
import 'package:evsolution/model/stationinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:evsolution/model/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

enum naviWidgetName { savesearch, resultsearch, getresult, evstationlist }

class Navicontroller extends GetxController {
  static Navicontroller get to => Get.find();
  var dio = Dio(BaseOptions(baseUrl: Statecontroller.to.serverUrl.value));

  TextEditingController startcontroller = new TextEditingController();
  TextEditingController endcontroller = new TextEditingController();
  SheetController sc = SheetController();

  final currentPostion = LatLng(37.56356428218978, 126.97377552185294).obs;
  //출발지검색히스토리
  RxList<DoroJuso> jusoliststart = <DoroJuso>[].obs;
  //도착지검색히스토리
  RxList<DoroJuso> jusolistend = <DoroJuso>[].obs;
  //도착지,출발지,경로상 마커
  RxSet<Marker> naviMarker = <Marker>{}.obs;
  final naviindex = 0.obs;
  //경로line
  RxSet<Polyline> routerlist = <Polyline>{}.obs;
  //경로상 충전기 리스트
  List<Stationinfo> stationinfo = <Stationinfo>[].obs;
  //경로상 충전기 탭 번호
  RxInt tap_num = (-1).obs;
  final storage = new FlutterSecureStorage();
  RxList<String> searchliststart = <String>[].obs;
  RxList<String> searchlistend = <String>[].obs;

  void oninit() async {
    // await storage.delete(key: 'searchlist');
    getpostion();
    listsearch();
    Navicontroller.to.endcontroller.text = "도착지 검색";
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
    Navicontroller.to.stationinfo.clear();
    Navicontroller.to.startcontroller.text = "";
    Navicontroller.to.endcontroller.text = "";
  }

  //현제위치 가져져와서 표시하기
  void getpostion() async {
    //현제위치
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    //현제위치
    currentPostion(LatLng(position.latitude, position.longitude));

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
      if (temp.addressInfo!.buildingName.toString() != '') {
        startcontroller.text +=
            "현위치 : " + temp.addressInfo!.buildingName.toString();
      } else {
        startcontroller.text += temp.addressInfo!.roadName.toString() +
            '-' +
            temp.addressInfo!.buildingIndex.toString();
      }
    }
  }

  //주소검색
  void getjuso(String text, String kindvalue) {
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

        if (kindvalue == 'start') {
          jusoliststart.clear();
          info.forEach((element) {
            jusoliststart.add(element);
          });
          naviindex(2);
        } else {
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
  void clicktojuso(int i, BuildContext context, String kind,
      Completer<GoogleMapController> mcontroller) async {
    FocusScope.of(context).unfocus();
    EasyDebounce.cancel('jusosearch');

    //주소xy좌표구하기
    Geocoding? info = null;
    Map<String, dynamic> params = {};
    if (kind == 'start') {
      params = {
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
    } else {
      params = {
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
    }

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
    //카메라이동
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
    int index = 0;
    if (naviMarker.any((e) => e.markerId == kind)) {
      naviMarker.forEach((e) {
        if (e.markerId == kind) {
          //마커지우고
          naviMarker.remove(index);
          //마커 다시 그리고
          naviMarker.add(Marker(
            markerId: MarkerId(kind),
            position: LatLng(lat, lon),
          ));
        }
        ;
        index++;
      });
    } else {
      naviMarker.add(Marker(
        markerId: MarkerId(kind),
        position: LatLng(lat, lon),
      ));
    }

    //최근검색추가
    if (kind == 'start') {
      innersaveresultjuso(Navicontroller.to.jusoliststart[i], lat, lon, kind);
      startcontroller.text = Navicontroller.to.jusoliststart[i].bdNm.toString();
    } else {
      innersaveresultjuso(Navicontroller.to.jusolistend[i], lat, lon, kind);
      endcontroller.text = Navicontroller.to.jusolistend[i].bdNm.toString();
    }

    //리스트초기화
    jusoliststart.clear();
    jusolistend.clear();
    naviindex(4);
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
    sc.hide();
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

    //test
    stationinfo.add(Stationinfo.fromJson({
      "lat": 37.5515012548,
      "lng": 126.9139520503,
      "businId": "EV",
      "businNm": "에버온",
      "statId": "EV000122",
      "statUpdDt": "20211030003310",
      "stat": "9",
      "statNm": "마포 메세나폴리스아파트",
      "count": 9,
      "addr": "서울특별시 마포구 양화로 45 (서교동, 메세나폴리스)",
      "parkingFree": "24시간 이용가능,입주민만 사용가능 거주자외출입제한"
    }));
    stationinfo.add(Stationinfo.fromJson({
      "lat": 37.547595313672,
      "lng": 126.9365446997,
      "businId": "EV",
      "businNm": "에버온",
      "statId": "EV002224",
      "statUpdDt": "20211030094213",
      "stat": "2",
      "statNm": "서울마포 세양청마루아파트",
      "count": 2,
      "addr": "서울특별시 마포구 독막로 209",
      "parkingFree": "24시간 이용가능,입주민만 사용가능 거주자외출입제한"
    }));
    stationinfo.add(Stationinfo.fromJson({
      "lat": 37.548963,
      "lng": 126.940205,
      "businId": "HE",
      "businNm": "한국전기차충전서비스",
      "statId": "HE000757",
      "statUpdDt": "20211029093505",
      "stat": "2",
      "statNm": "전기안전공사 서울지역본부",
      "count": 1,
      "addr": "서울특별시 마포구 백범로 73",
      "parkingFree": "24시간 이용가능"
    }));
    stationinfo.add(Stationinfo.fromJson({
      "lat": 37.5477360786,
      "lng": 126.9320622462,
      "businId": "PI",
      "businNm": "차지비",
      "statId": "PI000244",
      "statUpdDt": "20211029234356",
      "stat": "2",
      "statNm": "서울시 서강동 주민센터",
      "count": 1,
      "addr": "서울특별시 마포구 독막로 165",
      "parkingFree": "24시간 이용가능"
    }));
    stationinfo.add(Stationinfo.fromJson({
      "lat": 37.5516149385,
      "lng": 126.9117247826,
      "businId": "PI",
      "businNm": "차지비",
      "statId": "PI000248",
      "statUpdDt": "20211030143214",
      "stat": "3",
      "statNm": "서울시 합정동 주민센터",
      "count": 1,
      "addr": "서울특별시 마포구 월드컵로5길 11",
      "parkingFree": "24시간 이용가능"
    }));
    stationinfo.add(Stationinfo.fromJson({
      "lat": 37.5470727699,
      "lng": 126.9456466563,
      "businId": "PI",
      "businNm": "차지비",
      "statId": "EV000122",
      "statUpdDt": "20211030052501",
      "stat": "2",
      "statNm": "서울시 염리동 주민센터",
      "count": 1,
      "addr": "서울특별시 마포구 숭문길 14",
      "parkingFree": "24시간 이용가능"
    }));
    //마커추가
    stationinfo.forEach((e) {
      naviMarker.add(Marker(
          markerId: MarkerId(e.statId!.toString()),
          position: LatLng(e.lat!, e.lng!),
          infoWindow: InfoWindow(title: e.statNm)));
    });
  }

  //검색결과 마커셋팅
  clicktosearchlist(
      int i, String kind, Completer<GoogleMapController> mcontroller) async {
    List<String> temp = [];
    if (kind == 'start') {
      temp = Navicontroller.to.searchliststart[i].split('/');
    } else {
      temp = Navicontroller.to.searchlistend[i].split('/');
    }
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
    //검색테스트 추가
    if (kind == 'start') {
      startcontroller.text = temp[0].toString();
    } else {
      endcontroller.text = temp[0].toString();
    }

    int index = 0;
    if (naviMarker.any((e) => e.markerId == kind)) {
      naviMarker.forEach((e) {
        if (e.markerId == kind) {
          //마커지우고
          naviMarker.remove(index);
          //마커 다시 그리고
          naviMarker.add(Marker(
            markerId: MarkerId(kind),
            position: LatLng(lat, lon),
          ));
        }
        ;
        index++;
      });
    } else {
      naviMarker.add(Marker(
        markerId: MarkerId(kind),
        position: LatLng(lat, lon),
      ));
    }

    naviindex(4);
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
  Future<void> innersaveresultjuso(
      DoroJuso i, double lat, double lon, String kind) async {
    String searchlist = '';
    if (kind == 'start') {
      searchlist = 'searchliststart';
    } else if (kind == 'end') {
      searchlist = 'searchlistend';
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

  //경로상 충전소 리스트 탭
  Taplist(int i, Completer<GoogleMapController> mcontroller) async {
    //클릭 index
    tap_num(i);
    //리스트 다시 그리기
    test();
    //클릭한 목록으로 화면 이동
    if (!mcontroller.isCompleted) return;
    final cont = await mcontroller.future;
    cont.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(stationinfo[i].lat!, stationinfo[i].lng!),
        zoom: 16.0,
      ),
    ));

    //마커infowindow 보이게하기
    await cont.showMarkerInfoWindow(MarkerId(stationinfo[i].statId.toString()));
  }

  //네이게이션 연결
  void openDialog() {
    Get.dialog(
      AlertDialog(
        title: Container(
            alignment: Alignment.center,
            width: Get.size.width * 0.7,
            // height: Get.size.height * 0.2,
            child: Text('길안내 연결')),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
                onTap: () async {
                  Stationinfo temp = stationinfo[tap_num.value];
                  if (!await launch(
                      'https://apis.openapi.sk.com/tmap/app/routes?appKey=l7xx71089ab0fff0470e97ab985297aa1343&name=${temp.statNm}&lon=${temp.lng}&lat=${temp.lat}'))
                    throw 'Could not launch https://flutter.dev';
                },
                child: Image.asset("assets/image/navi/tmap.PNG")),
            GestureDetector(
                onTap: () async {
                  bool result = await NaviApi.instance.isKakaoNaviInstalled();

                  if (result) {
                    Stationinfo temp = stationinfo[tap_num.value];
                    await NaviApi.instance.navigate(
                      destination: Location(
                          name: temp.statNm.toString(),
                          x: temp.lng.toString(),
                          y: temp.lat.toString()),
                      option: NaviOption(coordType: CoordType.wgs84),
                    );
                  } else {
                    // 카카오내비 설치 페이지로 이동
                    launchBrowserTab(Uri.parse(NaviApi.webNaviInstall));
                  }
                },
                child: Image.asset("assets/image/navi/kakaomap.PNG"))
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }

  void test() {
    stationinfo.clear();
    //test
    stationinfo.add(Stationinfo.fromJson({
      "lat": 37.5515012548,
      "lng": 126.9139520503,
      "businId": "EV",
      "businNm": "에버온",
      "statId": "EV000122",
      "statUpdDt": "20211030003310",
      "stat": "9",
      "statNm": "마포 메세나폴리스아파트",
      "count": 9,
      "addr": "서울특별시 마포구 양화로 45 (서교동, 메세나폴리스)",
      "parkingFree": "24시간 이용가능,입주민만 사용가능 거주자외출입제한"
    }));
    stationinfo.add(Stationinfo.fromJson({
      "lat": 37.547595313672,
      "lng": 126.9365446997,
      "businId": "EV",
      "businNm": "에버온",
      "statId": "EV002224",
      "statUpdDt": "20211030094213",
      "stat": "2",
      "statNm": "서울마포 세양청마루아파트",
      "count": 2,
      "addr": "서울특별시 마포구 독막로 209",
      "parkingFree": "24시간 이용가능,입주민만 사용가능 거주자외출입제한"
    }));
    stationinfo.add(Stationinfo.fromJson({
      "lat": 37.548963,
      "lng": 126.940205,
      "businId": "HE",
      "businNm": "한국전기차충전서비스",
      "statId": "HE000757",
      "statUpdDt": "20211029093505",
      "stat": "2",
      "statNm": "전기안전공사 서울지역본부",
      "count": 1,
      "addr": "서울특별시 마포구 백범로 73",
      "parkingFree": "24시간 이용가능"
    }));
    stationinfo.add(Stationinfo.fromJson({
      "lat": 37.5477360786,
      "lng": 126.9320622462,
      "businId": "PI",
      "businNm": "차지비",
      "statId": "PI000244",
      "statUpdDt": "20211029234356",
      "stat": "2",
      "statNm": "서울시 서강동 주민센터",
      "count": 1,
      "addr": "서울특별시 마포구 독막로 165",
      "parkingFree": "24시간 이용가능"
    }));
    stationinfo.add(Stationinfo.fromJson({
      "lat": 37.5516149385,
      "lng": 126.9117247826,
      "businId": "PI",
      "businNm": "차지비",
      "statId": "PI000248",
      "statUpdDt": "20211030143214",
      "stat": "3",
      "statNm": "서울시 합정동 주민센터",
      "count": 1,
      "addr": "서울특별시 마포구 월드컵로5길 11",
      "parkingFree": "24시간 이용가능"
    }));
    stationinfo.add(Stationinfo.fromJson({
      "lat": 37.5470727699,
      "lng": 126.9456466563,
      "businId": "PI",
      "businNm": "차지비",
      "statId": "EV000122",
      "statUpdDt": "20211030052501",
      "stat": "2",
      "statNm": "서울시 염리동 주민센터",
      "count": 1,
      "addr": "서울특별시 마포구 숭문길 14",
      "parkingFree": "24시간 이용가능"
    }));
  }
}
