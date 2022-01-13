import 'dart:async';

import 'package:dio/dio.dart';
import 'package:evsolution/controller/stats_controller.dart';
import 'package:evsolution/model/stationinfo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Mapcontroller extends GetxController {
  static Mapcontroller get to => Get.find();
  var dio = Dio(BaseOptions(baseUrl: Statecontroller.to.serverUrl.value));
  
  PanelController pcontroller = new PanelController();
  final currentPostion = LatLng(37.55572584246962, 126.90891565210057).obs;
  RxSet<Marker> evMarker = <Marker>{}.obs;
  RxMap<String,dynamic> evinfo =<String,dynamic>{}.obs;
  List<Stationinfo> stationinfo=<Stationinfo>[].obs;
  RxDouble minsize = 0.0.obs;
  
  
  
  @override
  void onInit() async {
    super.onInit();
    evinfo['lat']=0.0;
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

        stationinfo.forEach((e) {
          evMarker.add(
            Marker(
              markerId: MarkerId(e.statId.toString()),
              position: LatLng(e.lat!,e.lng!),
              onTap: ()=>markertap(e)
              )
            );
        });
      }
    }
  }


  markertap(Stationinfo e) async {
    e.toJson().clear();
    e.toJson().forEach((key, value) { 
      evinfo[key]=value;
    });
    minsize(150.0);
  }

}