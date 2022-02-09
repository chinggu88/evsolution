import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:evsolution/controller/navi_controller.dart';
import 'package:evsolution/model/juso.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Navisearch extends StatelessWidget {
  Completer<GoogleMapController> mcontroller = Completer();
  SheetController sc = SheetController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlidingSheet(
      body: Obx(() {
        return GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: Navicontroller.to.currentPostion.value,
            zoom: 14.4746,
          ),
          onMapCreated: (GoogleMapController controller) async {
            mcontroller.complete(controller);
            //현제위치
            Position position = await Geolocator.getCurrentPosition(
                desiredAccuracy: LocationAccuracy.high);
            final cont = await mcontroller.future;
            cont.animateCamera(CameraUpdate.newCameraPosition(
              CameraPosition(
                bearing: 0,
                target: LatLng(position.latitude, position.longitude),
                zoom: 14.0,
              ),
            ));
            //마커추가
            Navicontroller.to.naviMarker.add(Marker(
              markerId: MarkerId('start'),
              position: LatLng(position.latitude, position.longitude),
            ));
          },
          markers: Navicontroller.to.naviMarker.value,
          polylines: Navicontroller.to.routerlist.value,
        );
      }),
      controller: sc,
      elevation: 8.0,
      cornerRadius: 16,
      snapSpec: const SnapSpec(
        snap: true,
        snappings: [0.2, 1.0],
      ),
      builder: (context, state) {
        return Container(
            height: 700,
            child: Column(
              children: [
                Obx(
                  () {
                    return TextField(
                      onTap: () {
                        sc.expand();
                      },
                      onSubmitted: (data) => Navicontroller.to.getjuso(data),
                      decoration: InputDecoration(
                          labelText: Navicontroller.to.starttext.value),
                    );
                  },
                ),
                TextField(
                  onTap: () {
                    sc.expand();
                    FocusScope.of(context).unfocus();
                  },
                  onChanged: (data) {
                    if (data.length >= 2) Navicontroller.to.getjuso(data);
                  },
                  onSubmitted: (data) => Navicontroller.to.getjuso(data),
                  decoration: InputDecoration(labelText: '도착지'),
                ),
                Obx(() {
                  switch (Navicontroller.to.naviindex.value) {
                    case 0:
                      return Navicontroller.to.searchlist.length != 0
                          ? Container(
                              width: Get.size.width,
                              height: Get.size.height * 0.7,
                              child: ListView.builder(
                                  itemCount:
                                      Navicontroller.to.searchlist.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    List<String> temp = Navicontroller
                                        .to.searchlist[index]
                                        .split('/');
                                    return GestureDetector(
                                      onTap: () => Navicontroller.to
                                          .clicktosearchlist(
                                              mcontroller, sc, index),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                children: [
                                                  Text(temp[0]),
                                                  Text(temp[1]),
                                                ],
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  Navicontroller.to
                                                      .innerdeleteresultjuso(
                                                          index);
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                },
                                                icon: Icon(Icons.delete),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            )
                          : Container(
                              height: Get.size.height * 0.7,
                              child: Text('검색결과가 없습니다'),
                            );

                    case 1:
                      return Container(
                        width: Get.size.width,
                        height: Get.size.height * 0.7,
                        child: ListView.builder(
                            itemCount: Navicontroller.to.jusolist.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () => Navicontroller.to.clicktojuso(
                                    mcontroller, sc, index, context),
                                child: Column(
                                  children: [
                                    Text(Navicontroller.to.jusolist[index].bdNm
                                        .toString()),
                                    Text(Navicontroller
                                        .to.jusolist[index].roadAddrPart1
                                        .toString()),
                                    Container(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              );
                            }),
                      );

                    case 2:
                      return Container(
                        child: TextButton(
                          child: Text('경로검색하기'),
                          onPressed: () =>
                              Navicontroller.to.searchStarttoEnd(mcontroller),
                        ),
                      );

                    case 3:
                      return Container(
                        child: Text('전기충전소 리스트'),
                      );
                  }
                  return Container();
                }),
              ],
            ));
      },
    ));
  }
}
