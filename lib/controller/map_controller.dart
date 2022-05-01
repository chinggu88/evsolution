import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:evsolution/controller/stats_controller.dart';
import 'package:evsolution/model/evstationinfo.dart';
import 'package:evsolution/model/stationinfo.dart';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Mapcontroller extends GetxController {
  static Mapcontroller get to => Get.find();
  var dio = Dio(BaseOptions(baseUrl: Statecontroller.to.serverUrl.value));

  PanelController pcontroller = new PanelController();
  final currentPostion = LatLng(0.0, 0.0).obs;
  RxSet<Marker> evMarker = <Marker>{}.obs;
  //주변충전소 정보
  List<Stationinfo> stationinfo = <Stationinfo>[].obs;
  //즐겨찾기 정보
  List<Stationinfo> favoriteinfo = <Stationinfo>[].obs;
  //충정소 정조
  List<Evstationinfo> evstationinfo = <Evstationinfo>[].obs;
  Marker? clickmarker;

  final naviindex = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    setlocation();
  }

  @override
  void onClose() async {
    super.onClose();
    evMarker.clear();
    stationinfo.clear();
  }

  //현재위치로 셋팅
  setlocation() async {
    //현제위치
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentPostion(LatLng(position.latitude, position.longitude));
  }

  //화면이동
  void onCameraIdle(Completer<GoogleMapController> gcontroller) async {
    var response;
    if (!gcontroller.isCompleted) return;
    final cont = await gcontroller.future;
    LatLngBounds ragion = await cont.getVisibleRegion();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (ragion != null) {
      response = await dio.post('/search/evstation', data: {
        'minx': ragion.southwest.latitude.toString(),
        'miny': ragion.southwest.longitude.toString(),
        'maxx': ragion.northeast.latitude.toString(),
        'maxy': ragion.northeast.longitude.toString(),
        'currentXY': [
          position.latitude.toString(),
          position.longitude.toString()
        ]
      });

      if (response.statusCode == 200) {
        stationinfo = (response.data['data']).map<Stationinfo>((json) {
          return Stationinfo.fromJson(json);
        }).toList();

        //기존마커리스트와 새로운 마커리스트에서 새로 추가된 마커만 마커그리기
        //1.기존마커리스트에서 새로운 마커리스트와 겹치지 않는 마커 지우기
        int evindex = 0;
        Set<String> rmindex = {};

        evMarker.forEach((ev) {
          bool chk = true;
          stationinfo.forEach((station) {
            if (ev.markerId.value == station.statId) {
              chk = false;
            }
          });
          if (chk) {
            rmindex.add(ev.markerId.value);
          }
          evindex++;
        });
        //삭제

        rmindex.forEach((e) {
          // evMarker.remove(e);
          evMarker.removeWhere((element) => element.markerId.value == e);
        });

        //2.새로운마커리스트에서 기존마커리스트와 중복되지 않는 리스트 마커 그리기
        int stationindex = 0;
        Set<Stationinfo> tempstation = <Stationinfo>{};

        stationinfo.forEach((e) {
          bool chk = true;
          evMarker.forEach((ev) async {
            if (ev.markerId.value == e.statId) {
              chk = false;
            }
          });
          if (chk) {
            tempstation.add(e);
          }
        });
        //추가

        tempstation.forEach((e) async {
          switch (0) {
            case 0:
              await getBytesFromAsset('assets/image/map/0.png', 100).then(
                  (value) => evMarker.add(Marker(
                      markerId: MarkerId(e.statId.toString()),
                      position: LatLng(e.lat!, e.lng!),
                      icon: BitmapDescriptor.fromBytes(value),
                      onTap: () => markertap(e))));
              break;
            case 1:
              await getBytesFromAsset('assets/image/map/1.png', 100).then(
                  (value) => evMarker.add(Marker(
                      markerId: MarkerId(e.statId.toString()),
                      position: LatLng(e.lat!, e.lng!),
                      icon: BitmapDescriptor.fromBytes(value),
                      onTap: () => markertap(e))));
              break;
            case 2:
              await getBytesFromAsset('assets/image/map/2.png', 100).then(
                  (value) => evMarker.add(Marker(
                      markerId: MarkerId(e.statId.toString()),
                      position: LatLng(e.lat!, e.lng!),
                      icon: BitmapDescriptor.fromBytes(value),
                      onTap: () => markertap(e))));
              break;
            case 3:
              await getBytesFromAsset('assets/image/map/3.png', 100).then(
                  (value) => evMarker.add(Marker(
                      markerId: MarkerId(e.statId.toString()),
                      position: LatLng(e.lat!, e.lng!),
                      icon: BitmapDescriptor.fromBytes(value),
                      onTap: () => markertap(e))));
              break;
            case 4:
              await getBytesFromAsset('assets/image/map/4.png', 100).then(
                  (value) => evMarker.add(Marker(
                      markerId: MarkerId(e.statId.toString()),
                      position: LatLng(e.lat!, e.lng!),
                      icon: BitmapDescriptor.fromBytes(value),
                      onTap: () => markertap(e))));
              break;
            case 5:
              await getBytesFromAsset('assets/image/map/5.png', 100).then(
                  (value) => evMarker.add(Marker(
                      markerId: MarkerId(e.statId.toString()),
                      position: LatLng(e.lat!, e.lng!),
                      icon: BitmapDescriptor.fromBytes(value),
                      onTap: () => markertap(e))));
              break;
            case 6:
              await getBytesFromAsset('assets/image/map/6.png', 100).then(
                  (value) => evMarker.add(Marker(
                      markerId: MarkerId(e.statId.toString()),
                      position: LatLng(e.lat!, e.lng!),
                      icon: BitmapDescriptor.fromBytes(value),
                      onTap: () => markertap(e))));
              break;
            case 7:
              await getBytesFromAsset('assets/image/map/7.png', 100).then(
                  (value) => evMarker.add(Marker(
                      markerId: MarkerId(e.statId.toString()),
                      position: LatLng(e.lat!, e.lng!),
                      icon: BitmapDescriptor.fromBytes(value),
                      onTap: () => markertap(e))));
              break;
            case 8:
              await getBytesFromAsset('assets/image/map/8.png', 100).then(
                  (value) => evMarker.add(Marker(
                      markerId: MarkerId(e.statId.toString()),
                      position: LatLng(e.lat!, e.lng!),
                      icon: BitmapDescriptor.fromBytes(value),
                      onTap: () => markertap(e))));
              break;
            case 9:
              await getBytesFromAsset('assets/image/map/9.png', 100).then(
                  (value) => evMarker.add(Marker(
                      markerId: MarkerId(e.statId.toString()),
                      position: LatLng(e.lat!, e.lng!),
                      icon: BitmapDescriptor.fromBytes(value),
                      onTap: () => markertap(e))));
              break;
            case 10:
              await getBytesFromAsset('assets/image/map/10.png', 100).then(
                  (value) => evMarker.add(Marker(
                      markerId: MarkerId(e.statId.toString()),
                      position: LatLng(e.lat!, e.lng!),
                      icon: BitmapDescriptor.fromBytes(value),
                      onTap: () => markertap(e))));
              break;
            default:
              await getBytesFromAsset('assets/image/map/0.png', 100).then(
                  (value) => evMarker.add(Marker(
                      markerId: MarkerId(e.statId.toString()),
                      position: LatLng(e.lat!, e.lng!),
                      icon: BitmapDescriptor.fromBytes(value),
                      onTap: () => markertap(e))));
              break;
          }
        });
      }
    }
  }

  //마커 초기 셋팅
  setMarker() {
    // stationinfo.forEach((e) async {
    //   switch (e.count) {
    //     case 0:
    //       await getBytesFromAsset('assets/image/map/0.png', 100).then((value) =>
    //           evMarker.add(Marker(
    //               markerId: MarkerId(e.statId.toString()),
    //               position: LatLng(e.lat!, e.lng!),
    //               icon: BitmapDescriptor.fromBytes(value),
    //               onTap: () => markertap(e))));
    //       break;
    //     case 1:
    //       await getBytesFromAsset('assets/image/map/1.png', 100).then((value) =>
    //           evMarker.add(Marker(
    //               markerId: MarkerId(e.statId.toString()),
    //               position: LatLng(e.lat!, e.lng!),
    //               icon: BitmapDescriptor.fromBytes(value),
    //               onTap: () => markertap(e))));
    //       break;
    //     case 2:
    //       await getBytesFromAsset('assets/image/map/2.png', 100).then((value) =>
    //           evMarker.add(Marker(
    //               markerId: MarkerId(e.statId.toString()),
    //               position: LatLng(e.lat!, e.lng!),
    //               icon: BitmapDescriptor.fromBytes(value),
    //               onTap: () => markertap(e))));
    //       break;
    //     case 3:
    //       await getBytesFromAsset('assets/image/map/3.png', 100).then((value) =>
    //           evMarker.add(Marker(
    //               markerId: MarkerId(e.statId.toString()),
    //               position: LatLng(e.lat!, e.lng!),
    //               icon: BitmapDescriptor.fromBytes(value),
    //               onTap: () => markertap(e))));
    //       break;
    //     case 4:
    //       await getBytesFromAsset('assets/image/map/4.png', 100).then((value) =>
    //           evMarker.add(Marker(
    //               markerId: MarkerId(e.statId.toString()),
    //               position: LatLng(e.lat!, e.lng!),
    //               icon: BitmapDescriptor.fromBytes(value),
    //               onTap: () => markertap(e))));
    //       break;
    //     case 5:
    //       await getBytesFromAsset('assets/image/map/5.png', 100).then((value) =>
    //           evMarker.add(Marker(
    //               markerId: MarkerId(e.statId.toString()),
    //               position: LatLng(e.lat!, e.lng!),
    //               icon: BitmapDescriptor.fromBytes(value),
    //               onTap: () => markertap(e))));
    //       break;
    //     case 6:
    //       await getBytesFromAsset('assets/image/map/6.png', 100).then((value) =>
    //           evMarker.add(Marker(
    //               markerId: MarkerId(e.statId.toString()),
    //               position: LatLng(e.lat!, e.lng!),
    //               icon: BitmapDescriptor.fromBytes(value),
    //               onTap: () => markertap(e))));
    //       break;
    //     case 7:
    //       await getBytesFromAsset('assets/image/map/7.png', 100).then((value) =>
    //           evMarker.add(Marker(
    //               markerId: MarkerId(e.statId.toString()),
    //               position: LatLng(e.lat!, e.lng!),
    //               icon: BitmapDescriptor.fromBytes(value),
    //               onTap: () => markertap(e))));
    //       break;
    //     case 8:
    //       await getBytesFromAsset('assets/image/map/8.png', 100).then((value) =>
    //           evMarker.add(Marker(
    //               markerId: MarkerId(e.statId.toString()),
    //               position: LatLng(e.lat!, e.lng!),
    //               icon: BitmapDescriptor.fromBytes(value),
    //               onTap: () => markertap(e))));
    //       break;
    //     case 9:
    //       await getBytesFromAsset('assets/image/map/9.png', 100).then((value) =>
    //           evMarker.add(Marker(
    //               markerId: MarkerId(e.statId.toString()),
    //               position: LatLng(e.lat!, e.lng!),
    //               icon: BitmapDescriptor.fromBytes(value),
    //               onTap: () => markertap(e))));
    //       break;
    //     case 10:
    //       await getBytesFromAsset('assets/image/map/10.png', 100).then(
    //           (value) => evMarker.add(Marker(
    //               markerId: MarkerId(e.statId.toString()),
    //               position: LatLng(e.lat!, e.lng!),
    //               icon: BitmapDescriptor.fromBytes(value),
    //               onTap: () => markertap(e))));
    //       break;
    //     default:
    //       await getBytesFromAsset('assets/image/map/0.png', 100).then((value) =>
    //           evMarker.add(Marker(
    //               markerId: MarkerId(e.statId.toString()),
    //               position: LatLng(e.lat!, e.lng!),
    //               icon: BitmapDescriptor.fromBytes(value),
    //               onTap: () => markertap(e))));
    //       break;
    //   }
    // });
  }

  markertap(Stationinfo e) async {
    markerset();
    evstationinfo.clear();
    var response = await dio.get('/station/${e.statId}');
    if (response.statusCode == 200) {
      evstationinfo = (response.data['data']).map<Evstationinfo>((json) {
        return Evstationinfo.fromJson(json);
      }).toList();
    }
    evMarker.forEach((el) async {
      if (el.mapsId.value == e.statId) {
        //기존정보 저장
        clickmarker = el;
        //아이콘 확대
        await getBytesFromAsset('assets/image/map/0.png', 200).then((value) =>
            evMarker.add(Marker(
                markerId: MarkerId(el.mapsId.value),
                position: el.position,
                icon: BitmapDescriptor.fromBytes(value),
                onTap: () => markertap(e))));
      }
    });

    naviindex(0);
    // pcontroller.open();
    pcontroller.animatePanelToSnapPoint();
  }

  markerset() async {
    //지우고 다시 그리기
    if (clickmarker != null) {
      // evMarker.removeWhere(
      //     (item) => item.markerId.value == clickmarker.markerId.value);
      evMarker.remove(clickmarker);
      evMarker.add(clickmarker!);
    }
  }

  //근처충전소
  nearlystation() {
    naviindex(1);
    pcontroller.open();
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
    naviindex(2);
    pcontroller.open();
  }

  //즐겨찾기 추가
  addfavorited(String statid) async {
    print("${Statecontroller.to.loginId.value} and ${statid}");
    var response = await dio.post('/search/favorites', data: {
      'id': Statecontroller.to.loginId.value.toString(),
      'statId': statid,
    });
    if (response.statusCode == 201) {
      Get.snackbar("결과", "즐겨찾기 추가 성공");
    } else {
      Get.snackbar("결과", "즐겨찾기 추가 실패");
    }
  }

  //즐겨찾기 삭제
  delfavorited(String statid) async {
    var response = await dio.delete('/search/favorites', queryParameters: {
      'id': Statecontroller.to.loginId.value,
      'statId': statid,
    });
    if (response.statusCode == 200) {
      Get.snackbar("결과", "즐겨찾기 삭제 성공");
    } else {
      Get.snackbar("결과", "즐겨찾기 삭제 실패");
    }
    favoriteinfo.removeWhere((element) => element.statId == statid);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}
