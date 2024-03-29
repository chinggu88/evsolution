import 'dart:async';
import 'dart:developer';

import 'package:evsolution/controller/map_controller.dart';
import 'package:evsolution/model/evstationinfo.dart';
import 'package:evsolution/model/stationinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class map extends StatelessWidget {
  Completer<GoogleMapController> gcontroller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        snapPoint: 0.5,
        minHeight: 0,
        maxHeight: 500,
        controller: Mapcontroller.to.pcontroller,
        backdropEnabled: false,
        body: Obx(() {
          return Stack(children: [
            GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: Mapcontroller.to.currentPostion.value,
                  zoom: 14.4746,
                ),
                onMapCreated: (GoogleMapController controller) async {
                  gcontroller.complete(controller);
                  //현제위치
                  Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);
                  // final cont = await gcontroller.future;
                  // cont.moveCamera(cameraUpdate)
                  // cont.animateCamera(CameraUpdate.newCameraPosition(
                  controller.moveCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                      bearing: 0,
                      target: LatLng(position.latitude, position.longitude),
                      zoom: 14.0,
                    ),
                  ));
                },
                onCameraIdle: () => Mapcontroller.to.onCameraIdle(gcontroller),
                markers: Mapcontroller.to.evMarker.value,
                onTap: (LatLng pos) {
                  Mapcontroller.to.pcontroller.close();
                  Mapcontroller.to.markerset();
                },
                myLocationEnabled: true),
            Positioned(
              left: Get.size.width * 0.29,
              top: Get.size.height * 0.806,
              child: GestureDetector(
                onTap: () => Mapcontroller.to.nearlystation(),
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
            ),
            Positioned(
              top: Get.size.height * 0.15,
              right: Get.size.width * 0.044,
              child: GestureDetector(
                onTap: () => Mapcontroller.to.favoritestation(),
                child: Container(
                  width: Get.size.width * 0.094,
                  height: Get.size.width * 0.094,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x3f000000),
                        offset: Offset(1, 1),
                        blurRadius: 2,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: SvgPicture.asset('assets/image/map/favorite.svg'),
                ),
              ),
            ),
          ]);
        }),
        panel: Obx(() {
          switch (Mapcontroller.to.naviindex.value) {
            //마커 정보
            case 0:
              return Mapcontroller.to.evstationinfo.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(top: 10),
                      width: Get.size.width,
                      child: Row(
                        children: [
                          SizedBox(
                            width: Get.size.width * 0.058,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Mapcontroller.to.addfavorited(
                                          Mapcontroller
                                              .to.evstationinfo[0].statId
                                              .toString());
                                    },
                                    child: Container(
                                        color:
                                            1 == 1 ? Colors.red : Colors.amber,
                                        child: SvgPicture.asset(
                                            'assets/image/map/union.svg')),
                                  ),
                                  SizedBox(
                                    width: Get.size.width * 0.018,
                                  ),
                                  Container(
                                    width: Get.size.width * 0.8,
                                    child: Text(
                                      Mapcontroller.to.evstationinfo[0].statNm
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 22,
                                        fontFamily: 'Pretendard-SemiBold',
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Get.size.height * 0.01,
                              ),
                              Container(
                                width: Get.size.width * 0.8,
                                child: Text(
                                  Mapcontroller.to.evstationinfo[0].addr
                                      .toString(),
                                  style: TextStyle(
                                    color: Color(0xff545454),
                                    fontSize: 15,
                                    fontFamily: 'Pretendard-Medium',
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                height: Get.size.height * 0.031,
                              ),
                              Row(
                                children: [
                                  Container(
                                    width: Get.size.width * 0.45,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '충전요금',
                                            style: TextStyle(
                                              color: Color(0xff4a4a4a),
                                              fontSize: 16,
                                              fontFamily: 'Pretendard-Regular',
                                            ),
                                          ),
                                          SizedBox(
                                            height: Get.size.height * 0.004,
                                          ),
                                          Text(
                                            '350원/kWh',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Pretendard-Medium',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: Get.size.height * 0.02,
                                          ),
                                          Text(
                                            '운영시간',
                                            style: TextStyle(
                                              color: Color(0xff4a4a4a),
                                              fontSize: 16,
                                              fontFamily: 'Pretendard-Regular',
                                            ),
                                          ),
                                          SizedBox(
                                            height: Get.size.height * 0.004,
                                          ),
                                          Text(
                                            '24시간',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Pretendard-Medium',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ]),
                                  ),
                                  Container(
                                    width: Get.size.width * 0.45,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '주차요금',
                                            style: TextStyle(
                                              color: Color(0xff4a4a4a),
                                              fontSize: 16,
                                              fontFamily: 'Pretendard-Regular',
                                            ),
                                          ),
                                          SizedBox(
                                            height: Get.size.height * 0.004,
                                          ),
                                          Text(
                                            Mapcontroller.to.evstationinfo[0]
                                                        .parkingFree
                                                        .toString() ==
                                                    'Y'
                                                ? '주자무료'
                                                : '주차유료',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Pretendard-Medium',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: Get.size.height * 0.02,
                                          ),
                                          Text(
                                            '운영기관',
                                            style: TextStyle(
                                              color: Color(0xff4a4a4a),
                                              fontSize: 16,
                                              fontFamily: 'Pretendard-Regular',
                                            ),
                                          ),
                                          SizedBox(
                                            height: Get.size.height * 0.004,
                                          ),
                                          Text(
                                            '환경부',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: 'Pretendard-Medium',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ]),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Get.size.height * 0.029,
                              ),
                              Container(
                                width: Get.size.width * 0.884,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () => Get.toNamed('/freport'),
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: Get.size.width * 0.38,
                                        height: Get.size.height * 0.053,
                                        margin: EdgeInsets.only(
                                          left: 0.111,
                                          right: 0.111,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0xff0431a6),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          '고장제보',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: 'Pretendard-Regular',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: Get.size.width * 0.38,
                                      height: Get.size.height * 0.053,
                                      margin: EdgeInsets.only(
                                        left: 0.111,
                                        right: 0.111,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color(0xff0431a6),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '길안내',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontFamily: 'Pretendard-Regular',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Get.size.height * 0.035,
                              ),
                              Expanded(
                                child: Container(
                                    width: Get.size.width * 0.884,
                                    child: ListView.builder(
                                        itemCount: Mapcontroller
                                            .to.evstationinfo.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          Evstationinfo temp = Mapcontroller
                                              .to.evstationinfo[index];
                                          return Column(
                                            children: [
                                              Container(
                                                  width: Get.size.width * 0908,
                                                  height:
                                                      Get.size.height * 0.12,
                                                  // width: Get.size.width * 0.884,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Color(0xffb4b4b4),
                                                      width: 1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            7),
                                                  ),
                                                  child: tapinfo(temp)),
                                              SizedBox(
                                                height: Get.size.height * 0.008,
                                              )
                                            ],
                                          );
                                        })),
                              )
                              // Text(Mapcontroller.to.evinfo.toJson().value)
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(
                      child: Center(
                        child: Text('검색중...'),
                      ),
                    );
            //주변충전기
            case 1:
              return Column(
                children: [
                  Container(
                    height: Get.size.height * 0.05,
                    child: Row(
                      children: [
                        SizedBox(
                          width: Get.size.width * 0.044,
                        ),
                        Icon(Icons.star_border_sharp),
                        Text(
                          '즐겨찾는 충전소',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Pretendard-Regular',
                          ),
                        ),
                        SizedBox(
                          width: Get.size.width * 0.414,
                        ),
                        DropdownButton(
                          value: '거리순',
                          items: ['거리순', '가격순'].map((value) {
                            return DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (e) {},
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: Get.size.height * 0.011,
                    decoration: BoxDecoration(
                      color: Color(0xfff8f4f4),
                    ),
                  ),
                  Container(
                    width: Get.size.width,
                    height: Get.size.height * 0.55,
                    child: ListView.builder(
                        itemCount: Mapcontroller.to.stationinfo.length,
                        itemBuilder: (BuildContext context, int index) {
                          List<Stationinfo> temp =
                              Mapcontroller.to.stationinfo.toList();
                          return GestureDetector(
                            child: Column(
                              children: [
                                Container(
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: Get.size.width * 0.044,
                                                ),
                                                Icon(Icons.star_border_sharp),
                                                Text(
                                                  temp[index].statNm.toString(),
                                                  overflow:
                                                      TextOverflow.visible,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontFamily:
                                                        'Pretendard-Bold',
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: Get.size.width * 0.044,
                                              ),
                                              Container(
                                                width: Get.size.width * 0.7,
                                                child: Text(
                                                    temp[index].addr.toString(),
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily:
                                                          'Roboto-Regular',
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: Get.size.height * 0.042,
                                        width: Get.size.width * 0.2,
                                        margin: EdgeInsets.only(
                                          left: 0.059,
                                          right: 0.059,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(0xff0431a6),
                                            width: 1,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '상세보기',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Pretendard-Regular',
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              );
            //즐겨찾기 화면
            case 2:
              return Mapcontroller.to.favoriteinfo.length != 0
                  ? Column(
                      children: [
                        Container(
                          height: Get.size.height * 0.05,
                          child: Row(
                            children: [
                              SizedBox(
                                width: Get.size.width * 0.044,
                              ),
                              Icon(Icons.star_border_sharp),
                              Text(
                                '즐겨찾는 충전소',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Pretendard-Regular',
                                ),
                              ),
                              SizedBox(
                                width: Get.size.width * 0.414,
                              ),
                              DropdownButton(
                                value: '거리순',
                                items: ['거리순', '가격순'].map((value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (e) {},
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: Get.size.height * 0.011,
                          decoration: BoxDecoration(
                            color: Color(0xfff8f4f4),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: Mapcontroller.to.favoriteinfo.length,
                              itemBuilder: (BuildContext context, int index) {
                                List<Stationinfo> temp =
                                    Mapcontroller.to.favoriteinfo.toList();
                                return GestureDetector(
                                  child: Column(
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: Get.size.width *
                                                            0.044,
                                                      ),
                                                      Icon(Icons
                                                          .star_border_sharp),
                                                      Text(
                                                        temp[index]
                                                            .statNm
                                                            .toString(),
                                                        overflow: TextOverflow
                                                            .visible,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              'Pretendard-Bold',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: Get.size.width *
                                                          0.044,
                                                    ),
                                                    Container(
                                                      width:
                                                          Get.size.width * 0.5,
                                                      child: Text(
                                                          temp[index]
                                                              .addr
                                                              .toString(),
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'Roboto-Regular',
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () => Mapcontroller.to
                                                  .delfavorited(temp[index]
                                                      .statId
                                                      .toString()),
                                              child: Container(
                                                height: Get.size.height * 0.042,
                                                width: Get.size.width * 0.2,
                                                margin: EdgeInsets.only(
                                                  left: 0.059,
                                                  right: 0.059,
                                                ),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Color(0xff0431a6),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  '삭제',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontFamily:
                                                        'Pretendard-Regular',
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: Get.size.height * 0.042,
                                              width: Get.size.width * 0.2,
                                              margin: EdgeInsets.only(
                                                left: 0.059,
                                                right: 0.059,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Color(0xff0431a6),
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              alignment: Alignment.center,
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ],
                    )
                  : Expanded(
                      child: Center(child: Text("즐겨찾기 목록이 없습니다.")),
                    );
          }
          return Container(
            child: Text('검색결과가 없습니다.!'),
          );
        }),
      ),
    );
  }
}

//충전기타입에 따라 다르게 return
Widget tapinfo(Evstationinfo v) {
  switch (v.chgerType) {
    case "01":
      //DC차데모
      return Row(
    children: [
      SizedBox(
        width: Get.size.width * 0.034,
      ),
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(v.chgerType.toString()),
            Text(
              v.output.toString(),
              style: TextStyle(
                color: Color(0xff131313),
                fontFamily: 'Pretendard-Bold',
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            Text(
              v.stat.toString(),
              style: TextStyle(
                color: Color(0xff02845d),
                fontFamily: 'Pretendard-Medium',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            Text(
              '지하2층',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Pretendard-Regular',
              ),
            ),
          ],
        ),
      ),
      SizedBox(
        width: Get.size.width * 0.10,
      ),
      Container(
        width: Get.size.width * 0.14,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Get.size.width * 0.12,
              height: Get.size.width * 0.12,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color(0xff02845d),
                  width: 1,
                ),
              ),
              child: SvgPicture.asset('assets/image/map/connect_type2.svg'),
            ),
            Text(
              'DC차데모',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Pretendard-Regular',
              ),
            ),
          ],
        ),
      ),
      
    ],
  );
    case "02":
      //AC완속
      return Row(children: [Container()]);
    case "03":
      //DC차데모 + AC상
      return Row(
    children: [
      SizedBox(
        width: Get.size.width * 0.034,
      ),
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              v.output.toString(),
              style: TextStyle(
                color: Color(0xff131313),
                fontFamily: 'Pretendard-Bold',
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            Text(
              v.stat.toString(),
              style: TextStyle(
                color: Color(0xff02845d),
                fontFamily: 'Pretendard-Medium',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            Text(
              '지하2층',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Pretendard-Regular',
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: Container(
          width: Get.size.width * 0.14,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Get.size.width * 0.12,
                height: Get.size.width * 0.12,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xff02845d),
                    width: 1,
                  ),
                ),
                child: SvgPicture.asset('assets/image/map/connect_type2.svg'),
              ),
              Text(
                'DC차데모',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Pretendard-Regular',
                ),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        child: Container(
          width: Get.size.width * 0.14,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Get.size.width * 0.12,
                height: Get.size.width * 0.12,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xff02845d),
                    width: 1,
                  ),
                ),
                child: SvgPicture.asset('assets/image/map/connect_type3.svg'),
              ),
              Text(
                'AC상',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Pretendard-Regular',
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
    case "04":
      //DC콤보
       return Row(
    children: [
      SizedBox(
        width: Get.size.width * 0.034,
      ),
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              v.output.toString(),
              style: TextStyle(
                color: Color(0xff131313),
                fontFamily: 'Pretendard-Bold',
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            Text(
              v.stat.toString(),
              style: TextStyle(
                color: Color(0xff02845d),
                fontFamily: 'Pretendard-Medium',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            Text(
              '지하2층',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Pretendard-Regular',
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: Container(
          width: Get.size.width * 0.14,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Get.size.width * 0.12,
                height: Get.size.width * 0.12,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xff02845d),
                    width: 1,
                  ),
                ),
                child: SvgPicture.asset('assets/image/map/connect_type1.svg'),
              ),
              Text(
                'DC콤보',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Pretendard-Regular',
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
    case "05":
      //DC차데모 + DC콤보
       return Row(
    children: [
      SizedBox(
        width: Get.size.width * 0.034,
      ),
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              v.output.toString(),
              style: TextStyle(
                color: Color(0xff131313),
                fontFamily: 'Pretendard-Bold',
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            Text(
              v.stat.toString(),
              style: TextStyle(
                color: Color(0xff02845d),
                fontFamily: 'Pretendard-Medium',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            Text(
              '지하2층',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Pretendard-Regular',
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: Container(
          width: Get.size.width * 0.14,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Get.size.width * 0.12,
                height: Get.size.width * 0.12,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xff02845d),
                    width: 1,
                  ),
                ),
                child: SvgPicture.asset('assets/image/map/connect_type2.svg'),
              ),
              Text(
                'DC차데모',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Pretendard-Regular',
                ),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        child: Container(
          width: Get.size.width * 0.14,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Get.size.width * 0.12,
                height: Get.size.width * 0.12,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xff02845d),
                    width: 1,
                  ),
                ),
                child: SvgPicture.asset('assets/image/map/connect_type1.svg'),
              ),
              Text(
                'DC콤보',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Pretendard-Regular',
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
    case "06":
      //DC차데모 + AC상+ DC콤보
      return Row(
    children: [
      SizedBox(
        width: Get.size.width * 0.034,
      ),
      Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              v.output.toString(),
              style: TextStyle(
                color: Color(0xff131313),
                fontFamily: 'Pretendard-Bold',
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            Text(
              v.stat.toString(),
              style: TextStyle(
                color: Color(0xff02845d),
                fontFamily: 'Pretendard-Medium',
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            Text(
              '지하2층',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Pretendard-Regular',
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: Container(
          width: Get.size.width * 0.14,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Get.size.width * 0.12,
                height: Get.size.width * 0.12,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xff02845d),
                    width: 1,
                  ),
                ),
                child: SvgPicture.asset('assets/image/map/connect_type2.svg'),
              ),
              Text(
                'DC차데모',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Pretendard-Regular',
                ),
              ),
            ],
          ),
        ),
      ),
      Expanded(
        child: Container(
          width: Get.size.width * 0.14,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Get.size.width * 0.12,
                height: Get.size.width * 0.12,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xff02845d),
                    width: 1,
                  ),
                ),
                child: SvgPicture.asset('assets/image/map/connect_type3.svg'),
              ),
              Text(
                'AC상',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Pretendard-Regular',
                ),
              ),
            ],
          ),
        ),
      ),
      // SizedBox(
      //   width: Get.size.width * 0.074,
      // ),
      Expanded(
        child: Container(
          width: Get.size.width * 0.14,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: Get.size.width * 0.12,
                height: Get.size.width * 0.12,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xff02845d),
                    width: 1,
                  ),
                ),
                child: SvgPicture.asset('assets/image/map/connect_type1.svg'),
              ),
              Text(
                'DC콤보',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Pretendard-Regular',
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
    default:
      //알수없는 버전
      return Container(
        child: Center(child: Text('알수없는 타입입니다. \n관리자에게 연락주세요.')),
      );
  }
  
}
