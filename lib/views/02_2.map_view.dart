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
          onCameraIdle: () => Mapcontroller.to.onCameraIdle(gcontroller),
          markers: Mapcontroller.to.evMarker.value,
          onTap: (LatLng pos) {
            Mapcontroller.to.minsize(0.0);
          },
        ),
        Positioned(
          left: Get.size.width * 0.29,
          top: Get.size.height * 0.806,
          child: Container(
            width: Get.size.width * 0.442,
            height: Get.size.height * 0.062,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(46),
            ),
            child: Text(
              '주변 충전소 ${Mapcontroller.to.evMarker.length}개',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Pre-Regular',
              ),
            ),
          ),
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
