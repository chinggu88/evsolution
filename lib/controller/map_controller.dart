import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:evsolution/controller/stats_controller.dart';
import 'package:evsolution/model/stationinfo.dart';
import 'package:flutter/material.dart';
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
  RxMap<String, dynamic> evinfo = <String, dynamic>{}.obs;
  List<Stationinfo> stationinfo = <Stationinfo>[].obs;
  Marker? clickmarker;

  final naviindex = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    //현제위치
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPostion(LatLng(position.latitude, position.longitude));
    print('currentPostion ${currentPostion}');
  }

  @override
  void onClose() async {
    super.onClose();
    evMarker.clear();
    stationinfo.clear();
    evinfo.clear();
  }

  //화면이동
  void onCameraIdle(Completer<GoogleMapController> gcontroller) async {
    var response;
    if (!gcontroller.isCompleted) return;
    final cont = await gcontroller.future;
    LatLngBounds ragion = await cont.getVisibleRegion();
    if (ragion != null) {
      response = await dio.post('/station/evstation', data: {
        'minx': ragion.northeast.latitude.toString(),
        'miny': ragion.southwest.longitude.toString(),
        'maxx': ragion.southwest.latitude.toString(),
        'maxy': ragion.northeast.longitude.toString()
      });
      if (response.statusCode == 200) {
        stationinfo = (response.data).map<Stationinfo>((json) {
          return Stationinfo.fromJson(json);
        }).toList();

        //기존마커리스트와 새로운 마커리스트에서 새로 추가된 마커만 마커그리기
        //1.기존마커리스트에서 새로운 마커리스트와 겹치지 않는 마커 지우기
        int evindex = 0;
        Set<String> rmindex = {};
        print('1 : evMarker foreach start');
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
        print('2 : rmindex foreach start');
        rmindex.forEach((e) {
          // evMarker.remove(e);
          evMarker.removeWhere((element) => element.markerId.value == e);
        });

        //2.새로운마커리스트에서 기존마커리스트와 중복되지 않는 리스트 마커 그리기
        int stationindex = 0;
        Set<Stationinfo> tempstation = <Stationinfo>{};
        print('3 : stationinfo foreach start');
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
        print('4 : tempstation foreach start');
        tempstation.forEach((e) async {
          switch (e.count) {
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
    stationinfo.forEach((e) async {
      switch (e.count) {
        case 0:
          await getBytesFromAsset('assets/image/map/0.png', 100).then((value) =>
              evMarker.add(Marker(
                  markerId: MarkerId(e.statId.toString()),
                  position: LatLng(e.lat!, e.lng!),
                  icon: BitmapDescriptor.fromBytes(value),
                  onTap: () => markertap(e))));
          break;
        case 1:
          await getBytesFromAsset('assets/image/map/1.png', 100).then((value) =>
              evMarker.add(Marker(
                  markerId: MarkerId(e.statId.toString()),
                  position: LatLng(e.lat!, e.lng!),
                  icon: BitmapDescriptor.fromBytes(value),
                  onTap: () => markertap(e))));
          break;
        case 2:
          await getBytesFromAsset('assets/image/map/2.png', 100).then((value) =>
              evMarker.add(Marker(
                  markerId: MarkerId(e.statId.toString()),
                  position: LatLng(e.lat!, e.lng!),
                  icon: BitmapDescriptor.fromBytes(value),
                  onTap: () => markertap(e))));
          break;
        case 3:
          await getBytesFromAsset('assets/image/map/3.png', 100).then((value) =>
              evMarker.add(Marker(
                  markerId: MarkerId(e.statId.toString()),
                  position: LatLng(e.lat!, e.lng!),
                  icon: BitmapDescriptor.fromBytes(value),
                  onTap: () => markertap(e))));
          break;
        case 4:
          await getBytesFromAsset('assets/image/map/4.png', 100).then((value) =>
              evMarker.add(Marker(
                  markerId: MarkerId(e.statId.toString()),
                  position: LatLng(e.lat!, e.lng!),
                  icon: BitmapDescriptor.fromBytes(value),
                  onTap: () => markertap(e))));
          break;
        case 5:
          await getBytesFromAsset('assets/image/map/5.png', 100).then((value) =>
              evMarker.add(Marker(
                  markerId: MarkerId(e.statId.toString()),
                  position: LatLng(e.lat!, e.lng!),
                  icon: BitmapDescriptor.fromBytes(value),
                  onTap: () => markertap(e))));
          break;
        case 6:
          await getBytesFromAsset('assets/image/map/6.png', 100).then((value) =>
              evMarker.add(Marker(
                  markerId: MarkerId(e.statId.toString()),
                  position: LatLng(e.lat!, e.lng!),
                  icon: BitmapDescriptor.fromBytes(value),
                  onTap: () => markertap(e))));
          break;
        case 7:
          await getBytesFromAsset('assets/image/map/7.png', 100).then((value) =>
              evMarker.add(Marker(
                  markerId: MarkerId(e.statId.toString()),
                  position: LatLng(e.lat!, e.lng!),
                  icon: BitmapDescriptor.fromBytes(value),
                  onTap: () => markertap(e))));
          break;
        case 8:
          await getBytesFromAsset('assets/image/map/8.png', 100).then((value) =>
              evMarker.add(Marker(
                  markerId: MarkerId(e.statId.toString()),
                  position: LatLng(e.lat!, e.lng!),
                  icon: BitmapDescriptor.fromBytes(value),
                  onTap: () => markertap(e))));
          break;
        case 9:
          await getBytesFromAsset('assets/image/map/9.png', 100).then((value) =>
              evMarker.add(Marker(
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
          await getBytesFromAsset('assets/image/map/0.png', 100).then((value) =>
              evMarker.add(Marker(
                  markerId: MarkerId(e.statId.toString()),
                  position: LatLng(e.lat!, e.lng!),
                  icon: BitmapDescriptor.fromBytes(value),
                  onTap: () => markertap(e))));
          break;
      }
    });
  }

  markertap(Stationinfo e) async {
    markerset();
    e.toJson().clear();
    e.toJson().forEach((key, value) {
      evinfo[key] = value;
    });

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
    naviindex(2);
    pcontroller.open();
  }

  //즐겨찾기
  favoritestation() {
    naviindex(1);
    pcontroller.open();
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
