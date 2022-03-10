import 'dart:async';

import 'package:evsolution/controller/navi_controller.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

class Navisearch extends StatelessWidget {
  Completer<GoogleMapController> mcontroller = Completer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SlidingSheet(
      body: Obx(() {
        return Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: Navicontroller.to.currentPostion.value,
                zoom: 14.4746,
              ),
              onMapCreated: (GoogleMapController controller) async {
                mcontroller.complete(controller);
                //위치이동
                //현제위치
                Position position = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high);
                //마커추가
                Navicontroller.to.naviMarker.add(Marker(
                  markerId: MarkerId('start'),
                  position: LatLng(position.latitude, position.longitude),
                ));
                final cont = await mcontroller.future;
                // cont.moveCamera(cameraUpdate)
                // cont.animateCamera(CameraUpdate.newCameraPosition(
                cont.moveCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(
                    bearing: 0,
                    target: LatLng(position.latitude, position.longitude),
                    zoom: 14.0,
                  ),
                ));
              },
              markers: Navicontroller.to.naviMarker.value,
              polylines: Navicontroller.to.routerlist.value,
            ),
            //경로상 충전소 위치
            Positioned(
                bottom: Get.size.height * 0.01,
                child: Opacity(
                  opacity: 0.0,
                  child: Container(
                    width: Get.size.width,
                    height: Get.size.width * 0.3,
                    // color: Colors.red,
                  ),
                )),
          ],
        );
      }),
      controller: Navicontroller.to.sc,
      elevation: 8.0,
      cornerRadius: 16,
      snapSpec: const SnapSpec(
        snap: true,
        snappings: [0.2, 0.9],
      ),
      builder: (context, state) {
        return Container(
            height: Get.size.height * 0.9,
            child: Column(
              children: [
                SizedBox(
                  height: Get.size.height * 0.01,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  height: Get.size.height * 0.069,
                  margin: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xffc4c4c4),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(53),
                  ),
                  child: TextFormField(
                    controller: Navicontroller.to.startcontroller,
                    onTap: () {
                      Navicontroller.to.sc.expand();
                      FocusScope.of(context).unfocus();
                      Navicontroller.to.naviindex(0);
                      Navicontroller.to.startcontroller.text = "";
                    },
                    onChanged: (data) {
                      if (data.length >= 2)
                        Navicontroller.to.getjuso(data, 'start');
                    },
                    onFieldSubmitted: (data) =>
                        Navicontroller.to.getjuso(data, 'start'),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Roboto-Regular',
                    ),
                    strutStyle: StrutStyle(),
                  ),
                ),
                SizedBox(
                  height: Get.size.height * 0.013,
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  height: Get.size.height * 0.069,
                  margin: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xffc4c4c4),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(53),
                  ),
                  child: TextFormField(
                    controller: Navicontroller.to.endcontroller,
                    onTap: () {
                      Navicontroller.to.sc.expand();
                      FocusScope.of(context).unfocus();
                      Navicontroller.to.naviindex(1);
                      Navicontroller.to.endcontroller.text = "";
                    },
                    onChanged: (data) {
                      if (data.length >= 2)
                        Navicontroller.to.getjuso(data, 'end');
                    },
                    onFieldSubmitted: (data) =>
                        Navicontroller.to.getjuso(data, 'end'),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontFamily: 'Roboto-Regular',
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.size.height * 0.01,
                ),
                Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: Color(0xfff8f4f4),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: Get.size.width * 0.083,
                    ),
                    Container(
                      height: Get.size.height * 0.047,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '최근경로',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Roboto-Regular',
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: Color(0xfff8f4f4),
                  ),
                ),
                //0:검색히스토리리스트(출발지) 1:검색히스토리리스트(도착지) 2:검색결과리스트(출발지) 3:검색결과리스트(도착지) 4:경로검색 5:경로상 충전소위치
                Row(
                  children: [
                    Obx(() {
                      switch (Navicontroller.to.naviindex.value) {
                        case 0:
                          return Navicontroller.to.searchliststart.length != 0
                              ? Container(
                                  height: Get.size.height * 0.66,
                                  width: Get.size.width,
                                  child: ListView.builder(
                                      itemCount: Navicontroller
                                          .to.searchliststart.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        List<String> temp = Navicontroller
                                            .to.searchliststart[index]
                                            .split('/');
                                        return GestureDetector(
                                          onTap: () {
                                            Navicontroller.to.clicktosearchlist(
                                                index, 'start', mcontroller);
                                            FocusScope.of(context).unfocus();
                                          },
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        Get.size.width * 0.083,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Container(
                                                          width:
                                                              Get.size.width *
                                                                  0.55,
                                                          child: Text(
                                                            temp[0],
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                          )),
                                                      Container(
                                                          width:
                                                              Get.size.width *
                                                                  0.55,
                                                          child: Text(
                                                            temp[1],
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                          )),
                                                    ],
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height:
                                                        Get.size.height * 0.044,
                                                    width:
                                                        Get.size.width * 0.22,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color:
                                                            Color(0xff0431a6),
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Text(
                                                      '상세보기',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'Pretendard-Regular',
                                                      ),
                                                    ),
                                                  ),
                                                  // IconButton(
                                                  //   onPressed: () {
                                                  //     Navicontroller.to
                                                  //         .innerdeleteresultjuso(
                                                  //             index);
                                                  //     FocusScope.of(context)
                                                  //         .unfocus();
                                                  //   },
                                                  //   icon: Icon(Icons.delete),
                                                  // ),
                                                ],
                                              ),
                                              Container(
                                                height: Get.size.height * 0.011,
                                              ),
                                              Container(
                                                height: Get.size.height * 0.005,
                                                decoration: BoxDecoration(
                                                  color: Color(0xfff8f4f4),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                )
                              : Container(
                                  height: Get.size.height * 0.6,
                                  width: Get.size.width * 0.817,
                                  child: Text('검색결과가 없습니다'),
                                );
                        case 1:
                          return Navicontroller.to.searchlistend.length != 0
                              ? Container(
                                  height: Get.size.height * 0.66,
                                  width: Get.size.width,
                                  child: ListView.builder(
                                      padding: const EdgeInsets.only(top: 0),
                                      itemCount: Navicontroller
                                          .to.searchlistend.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        List<String> temp = Navicontroller
                                            .to.searchlistend[index]
                                            .split('/');
                                        return GestureDetector(
                                          onTap: () {
                                            Navicontroller.to.clicktosearchlist(
                                                index, 'end', mcontroller);
                                            FocusScope.of(context).unfocus();
                                          },
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width:
                                                        Get.size.width * 0.083,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Container(
                                                          width:
                                                              Get.size.width *
                                                                  0.55,
                                                          child: Text(
                                                            temp[0],
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                          )),
                                                      Container(
                                                          width:
                                                              Get.size.width *
                                                                  0.55,
                                                          child: Text(
                                                            temp[1],
                                                            overflow:
                                                                TextOverflow
                                                                    .visible,
                                                          )),
                                                    ],
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height:
                                                        Get.size.height * 0.044,
                                                    width:
                                                        Get.size.width * 0.22,
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color:
                                                            Color(0xff0431a6),
                                                        width: 1,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                    child: Text(
                                                      '상세보기',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'Pretendard-Regular',
                                                      ),
                                                    ),
                                                  ),
                                                  // IconButton(
                                                  //   onPressed: () {
                                                  //     Navicontroller.to
                                                  //         .innerdeleteresultjuso(
                                                  //             index);
                                                  //     FocusScope.of(context)
                                                  //         .unfocus();
                                                  //   },
                                                  //   icon: Icon(Icons.delete),
                                                  // ),
                                                ],
                                              ),
                                              Container(
                                                height: Get.size.height * 0.011,
                                              ),
                                              Container(
                                                height: Get.size.height * 0.005,
                                                decoration: BoxDecoration(
                                                  color: Color(0xfff8f4f4),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                )
                              : Container(
                                  height: Get.size.height * 0.6,
                                  child: Text('검색결과가 없습니다'),
                                );
                        case 2:
                          return Container(
                            height: Get.size.height * 0.66,
                            width: Get.size.width,
                            child: ListView.builder(
                                padding: const EdgeInsets.only(top: 0),
                                itemCount:
                                    Navicontroller.to.jusoliststart.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () => Navicontroller.to.clicktojuso(
                                        index, context, 'start', mcontroller),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: Get.size.width * 0.083,
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                  height:
                                                      Get.size.height * 0.011,
                                                ),
                                                Container(
                                                    width:
                                                        Get.size.width * 0.55,
                                                    child: Text(
                                                      Navicontroller
                                                          .to
                                                          .jusoliststart[index]
                                                          .bdNm
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.visible,
                                                    )),
                                                Container(
                                                    width:
                                                        Get.size.width * 0.55,
                                                    child: Text(
                                                      Navicontroller
                                                          .to
                                                          .jusoliststart[index]
                                                          .roadAddrPart1
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.visible,
                                                    )),
                                              ],
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              height: Get.size.height * 0.044,
                                              width: Get.size.width * 0.22,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color(0xff0431a6),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '상세보기',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontFamily:
                                                      'Pretendard-Regular',
                                                ),
                                              ),
                                            ),
                                            // IconButton(
                                            //   onPressed: () {
                                            //     Navicontroller.to
                                            //         .innerdeleteresultjuso(
                                            //             index);
                                            //     FocusScope.of(context)
                                            //         .unfocus();
                                            //   },
                                            //   icon: Icon(Icons.delete),
                                            // ),
                                          ],
                                        ),
                                        Container(
                                          height: Get.size.height * 0.011,
                                        ),
                                        Container(
                                          height: Get.size.height * 0.005,
                                          decoration: BoxDecoration(
                                            color: Color(0xfff8f4f4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          );
                        case 3:
                          return Container(
                            height: Get.size.height * 0.66,
                            width: Get.size.width,
                            child: ListView.builder(
                                padding: const EdgeInsets.only(top: 0),
                                itemCount: Navicontroller.to.jusolistend.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () => Navicontroller.to.clicktojuso(
                                        index, context, 'end', mcontroller),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: Get.size.width * 0.083,
                                            ),
                                            Column(
                                              children: [
                                                Container(
                                                  height:
                                                      Get.size.height * 0.011,
                                                ),
                                                Container(
                                                    width:
                                                        Get.size.width * 0.55,
                                                    child: Text(
                                                      Navicontroller
                                                          .to
                                                          .jusolistend[index]
                                                          .bdNm
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.visible,
                                                    )),
                                                Container(
                                                    width:
                                                        Get.size.width * 0.55,
                                                    child: Text(
                                                      Navicontroller
                                                          .to
                                                          .jusolistend[index]
                                                          .roadAddrPart1
                                                          .toString(),
                                                      overflow:
                                                          TextOverflow.visible,
                                                    )),
                                              ],
                                            ),
                                            Container(
                                              alignment: Alignment.center,
                                              height: Get.size.height * 0.044,
                                              width: Get.size.width * 0.22,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color(0xff0431a6),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                '상세보기',
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontFamily:
                                                      'Pretendard-Regular',
                                                ),
                                              ),
                                            ),
                                            // IconButton(
                                            //   onPressed: () {
                                            //     Navicontroller.to
                                            //         .innerdeleteresultjuso(
                                            //             index);
                                            //     FocusScope.of(context)
                                            //         .unfocus();
                                            //   },
                                            //   icon: Icon(Icons.delete),
                                            // ),
                                          ],
                                        ),
                                        Container(
                                          height: Get.size.height * 0.011,
                                        ),
                                        Container(
                                          height: Get.size.height * 0.005,
                                          decoration: BoxDecoration(
                                            color: Color(0xfff8f4f4),
                                          ),
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
                              onPressed: () => Navicontroller.to
                                  .searchStarttoEnd(mcontroller),
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
                ),
              ],
            ));
      },
    ));
  }
}
