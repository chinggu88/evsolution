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
  final currentPostion = LatLng(37.55572584246962, 126.90891565210057).obs;
  RxSet<Marker> evMarker = <Marker>{}.obs;
  RxMap<String, dynamic> evinfo = <String, dynamic>{}.obs;
  List<Stationinfo> stationinfo = <Stationinfo>[].obs;
  RxDouble minsize = 0.0.obs;

  @override
  void onInit() async {
    super.onInit();
     //현제위치
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentPostion(LatLng(position.latitude, position.longitude));
  }

  @override
  void onClose() async {
    super.onClose();
    evMarker.clear();
    stationinfo.clear();
    stationinfo.clear();
    minsize = 0.0.obs;
  }

  //화면이동
  void onCameraIdle(Completer<GoogleMapController> gcontroller) async {
    var response;
    evMarker.clear();

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

        stationinfo.forEach((e) async {
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

  markertap(Stationinfo e) async {
    e.toJson().clear();
    e.toJson().forEach((key, value) {
      evinfo[key] = value;
    });
    minsize(150.0);
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
