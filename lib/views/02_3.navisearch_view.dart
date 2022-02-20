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
                        FocusScope.of(context).unfocus();
                        Navicontroller.to.starttext('');
                        Navicontroller.to.naviindex(0);
                      },
                      onChanged: (data) {
                    if (data.length >= 2) Navicontroller.to.getjuso(data,'start');
                  },
                      onSubmitted: (data) => Navicontroller.to.getjuso(data,'start'),
                      decoration: InputDecoration(
                          labelText: Navicontroller.to.starttext.value),
                    );
                  },
                ),
                TextField(
                  onTap: () {
                    sc.expand();
                    FocusScope.of(context).unfocus();
                    Navicontroller.to.endtext('');
                    Navicontroller.to.naviindex(1);
                  },
                  onChanged: (data) {
                    if (data.length >= 2) Navicontroller.to.getjuso(data,'end');
                  },
                  onSubmitted: (data) => Navicontroller.to.getjuso(data,'end'),
                  decoration: InputDecoration(labelText: Navicontroller.to.endtext.value),
                ),
                //0:검색히스토리리스트(출발지) 1:검색히스토리리스트(도착지) 2:검색결과리스트(출발지) 3:검색결과리스트(도착지) 4:경로검색 5:경로상 충전소위치
                Obx(() {
                  switch (Navicontroller.to.naviindex.value) {
                    case 0:
                      return Navicontroller.to.searchliststart.length != 0
                          ? Container(
                              width: Get.size.width,
                              height: Get.size.height * 0.7,
                              child: ListView.builder(
                                  itemCount:
                                      Navicontroller.to.searchliststart.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    List<String> temp = Navicontroller
                                        .to.searchliststart[index]
                                        .split('/');
                                    return GestureDetector(
                                      onTap: () => Navicontroller.to
                                          .clicktosearchlist(
                                              mcontroller, sc, index,'start'),
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
                      return Navicontroller.to.searchlistend.length != 0
                          ? Container(
                              width: Get.size.width,
                              height: Get.size.height * 0.7,
                              child: ListView.builder(
                                  itemCount:
                                      Navicontroller.to.searchlistend.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    List<String> temp = Navicontroller
                                        .to.searchlistend[index]
                                        .split('/');
                                    return GestureDetector(
                                      onTap: () => Navicontroller.to
                                          .clicktosearchlist(
                                              mcontroller, sc, index,'start'),
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
                    case 2:
                      return Container(
                        width: Get.size.width,
                        height: Get.size.height * 0.7,
                        child: ListView.builder(
                            itemCount: Navicontroller.to.jusoliststart.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () => Navicontroller.to.clicktojuso(
                                    mcontroller, sc, index, context,'start'),
                                child: Column(
                                  children: [
                                    Text(Navicontroller.to.jusoliststart[index].bdNm
                                        .toString()),
                                    Text(Navicontroller
                                        .to.jusoliststart[index].roadAddrPart1
                                        .toString()),
                                    Container(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              );
                            }),
                      );
                    case 3:
                      return Container(
                        width: Get.size.width,
                        height: Get.size.height * 0.7,
                        child: ListView.builder(
                            itemCount: Navicontroller.to.jusolistend.length,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () => Navicontroller.to.clicktojuso(
                                    mcontroller, sc, index, context,'end'),
                                child: Column(
                                  children: [
                                    Text(Navicontroller.to.jusolistend[index].bdNm
                                        .toString()),
                                    Text(Navicontroller
                                        .to.jusolistend[index].roadAddrPart1
                                        .toString()),
                                    Container(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              );
                            }),
                      );
                    case 4:
                      return Container(
                        child: TextButton(
                          child: Text('경로검색하기'),
                          onPressed: () =>
                              Navicontroller.to.searchStarttoEnd(mcontroller),
                        ),
                      );

                    case 5:
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
