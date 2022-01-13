import 'dart:async';

import 'package:evsolution/controller/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class map extends StatelessWidget {
  Completer<GoogleMapController> gcontroller = Completer();

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_new
    return new Scaffold(body: Obx(() {
      return Stack(children: [
        GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: Mapcontroller.to.currentPostion.value,
            zoom: 14.4746,
          ),
          onMapCreated: (GoogleMapController controller) {
              gcontroller.complete(controller);
            
          },
          onCameraIdle: ()=>Mapcontroller.to.onCameraIdle(gcontroller),
          markers: Mapcontroller.to.evMarker.value,
          onTap: (LatLng pos) {
            Mapcontroller.to.minsize(0.0);
          },
        ),
        SlidingUpPanel(
            minHeight: Mapcontroller.to.minsize.value,
            panel: Column(
              children: [
                Text('test'),
                Text(Mapcontroller.to.evinfo['statNm'].toString()),
                Text(Mapcontroller.to.evinfo['businNm'].toString()),
                Text(Mapcontroller.to.evinfo['stat'].toString())
                // Text(Mapcontroller.to.evinfo.toJson().value)
              ],
            ))
      ]);
    }));
  }
}
