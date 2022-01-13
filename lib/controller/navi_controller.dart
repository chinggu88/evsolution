
import 'dart:async';
import 'dart:convert';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:evsolution/controller/stats_controller.dart';
import 'package:evsolution/model/dorojuso.dart';
import 'package:evsolution/model/reverseGeocoding.dart';
import 'package:evsolution/model/routers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:evsolution/model/juso.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:evsolution/model/geocoding';

enum naviWidgetName {savesearch,resultsearch,getresult,evstationlist}

class Navicontroller extends GetxController {
  static Navicontroller get to => Get.find();
  var dio = Dio(BaseOptions(baseUrl: Statecontroller.to.serverUrl.value));
  
  RxString starttext = ''.obs;
  final currentPostion = LatLng(37.5646279797785,126.97756750354343).obs; 
  RxList<DoroJuso> jusolist = <DoroJuso>[].obs;
  RxSet<Marker> naviMarker = <Marker>{}.obs;
  final naviindex = 0.obs;
  RxSet<Polyline> routerlist = <Polyline>{}.obs;
  final storage = new FlutterSecureStorage();
  RxList<String> searchlist=<String>[].obs;
  
  void oninit() async {
    // await storage.delete(key: 'searchlist');
  
    getpostion();
    listsearch();
    
  }
  
  void onclose(){
    EasyDebounce.cancel('jusosearch');
    Navicontroller.to.naviindex(0);
    Navicontroller.to.jusolist.clear();
    Navicontroller.to.searchlist.clear();
    Navicontroller.to.routerlist.clear();
    Navicontroller.to.naviMarker.clear();
  }
  
  //현제위치 가져져와서 표시하기
  void getpostion() async{
    //현제위치
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    
    //주소추출
    jusolist.clear();
    var prams ={
      'version':'1',
      'format':'json',
      'callback':'result',
      'appKey':'l7xx71089ab0fff0470e97ab985297aa1343',
      'lon':position.longitude,
      'lat':position.latitude,
      'addressType':'A10',
    };


    var response = await Dio().get('https://apis.openapi.sk.com/tmap/geo/reversegeocoding',queryParameters:prams );
    if(response.statusCode == 200){
      Map<String,dynamic> responseMap = jsonDecode(response.toString());
      var temp = ReversGeocoding.fromJson(responseMap);
      
      if(temp.addressInfo!.buildingName.toString()==' '){
        starttext(temp.addressInfo!.buildingName.toString());
      }else{
        starttext(temp.addressInfo!.roadName.toString() +'-'+temp.addressInfo!.buildingIndex.toString());
      }
      
    }
    

  }


  //주소검색
  void getjuso(String text) {
    EasyDebounce.debounce(
          'jusosearch',                 
          Duration(milliseconds: 200),    
          () async {
              jusolist.clear();
              var prams ={
                'confmKey':'U01TX0FVVEgyMDIxMTIyMDAxMDk1NjExMjA0ODQ=',
                'currentPage':'1',
                'countPerPage':'15',
                'keyword':text,
                'resultType':'json',
              };


              var response = await Dio().get('https://www.juso.go.kr/addrlink/addrLinkApi.do',queryParameters:prams );
              if(response.statusCode == 200){
                List<DoroJuso> info = (response.data["results"]["juso"]).map<DoroJuso>((json) {
                  return DoroJuso.fromJson(json);
                }).toList();
                info.forEach((element) {
                  print(element.admCd);
                  jusolist.add(element);
                });
              }
              naviindex(1);
          }                
    );    
  }
  //주소위치로 이동
  void clicktojuso(Completer<GoogleMapController> mcontroller, SheetController sc, int i,BuildContext context) async{
    
    FocusScope.of(context).unfocus();
    EasyDebounce.cancel('jusosearch');
    //주소xy좌표구하기
    Geocoding? info = null;
    var params ={
                'version':'1',
                'format':'json',
                'callback':'result',
                'appKey':'l7xx71089ab0fff0470e97ab985297aa1343',
                'coordType':'WGS84GEO',
                'city_do':Navicontroller.to.jusolist[i].siNm,
                'gu_gun':Navicontroller.to.jusolist[i].sggNm,
                'dong':Navicontroller.to.jusolist[i].emdNm,
                'bunji':Navicontroller.to.jusolist[i].lnbrSlno.toString() != '0' ? Navicontroller.to.jusolist[i].lnbrMnnm.toString()+'-'+Navicontroller.to.jusolist[i].lnbrSlno.toString()
                : Navicontroller.to.jusolist[i].lnbrMnnm
              };
    var response = await Dio().get('https://apis.openapi.sk.com/tmap/geo/geocoding',queryParameters:params );
    if(response.statusCode == 200){
      info =Geocoding.fromJson(response.data["coordinateInfo"]);
    }
      
    
    
    // String juso = Navicontroller.to.jusolist[i].upperAddrName.toString() + Navicontroller.to.jusolist[i].middleAddrName.toString() + Navicontroller.to.jusolist[i].lowerAddrName.toString();
    
    double lat = double.parse(info!.lat.toString());
    double lon = double.parse(info!.lon.toString());
    
    
    if(!mcontroller.isCompleted)return;
    final cont = await mcontroller.future;
      cont.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(lat,lon),
        zoom: 14.0,
      ),
    ));
    //검색창축소
    sc.snapToExtent(0.3);
    //마커추가
    naviMarker.add(
    Marker(
      markerId: MarkerId('end'),
      position: LatLng(lat,lon),
      )
    );
    //검색리스트 추가
    innersaveresultjuso(Navicontroller.to.jusolist[i],lat,lon);
    //리스트초기화
    jusolist.clear();
    naviindex(2);

  }

  //화면이동시 marker이동
  void setMarker(CameraPosition position){
    naviMarker.clear();
    Navicontroller.to.naviMarker.add(
                Marker(
                  markerId: MarkerId('start'),
                  position: LatLng(position.target.latitude,position.target.longitude),
                  )
                );

    getpostion();
  }

  void searchStarttoEnd(Completer<GoogleMapController> mcontroller)async{
    
    double startx=0.0,starty=0.0,endx=0.0,endy=0.0;
       naviMarker.forEach((e) { 
         if(e.markerId == MarkerId('start')){
           startx = e.position.longitude;
           starty = e.position.latitude;
         }else if(e.markerId == MarkerId('end')){
           endx = e.position.longitude;
           endy = e.position.latitude;
         }
       });
      
      var prams ={
        "version":"1",
        "format":"json",
        "callack":"result",
        "appKey" : "l7xx71089ab0fff0470e97ab985297aa1343",
        "startX" : startx,
        "startY" : starty,
        "endX" : endx,
        "endY" : endy,
        "reqCoordType" : "WGS84GEO",
        "resCoordType" : "EPSG3857",
        "searchOption" : '0',
        "trafficInfo" : 'Y'
      };


    var response = await Dio().get('https://apis.openapi.sk.com/tmap/routes',queryParameters:prams );
    if(response.statusCode ==200){
      print(response.data["features"]);
        List list = jsonDecode(response.data["features"]);
        list.forEach((element) {
          print(element);
        });
      // List<features> info =(response.data["features"]).map<features>((json) {
      //     return features.fromJson(json);
      //   }).toList();
      //   info.forEach((element) {
      //     print(element.toJson()["geometry"]["type"]);
      //     if(element.toJson()["geometry"]["type"] == 'LineString'){

      //       List<GeometryList> temp =(element.toJson()["geometry"]).map<GeometryList>((json) {
      //         return GeometryList.fromJson(json);
      //       }).toList();
      //       temp.forEach((e) {
      //         print('lineString ${e.toString()}');
      //        });
      //     }
      //     print(element.toJson()["properties"]);
      //   });
    }
      // var response = await dio.post('/navigation?startY=${startx}&startX=${starty}&endY=${endx}&endX=${endy}');
      
      // if(response.statusCode == 200){
      //   List<LatLng> points=[];
      //   var temp = response.data.toString().replaceAll(']', '');
      //   temp = temp.replaceAll('[', '');
      //   temp = temp.replaceAll(' ', '');
      //    List output = temp.split('}');
         
      //    for(int i =0;i<output.length-1;i++){
      //      var element = output[i].toString();
      //      var result=element;
      //     if(element[0] == ','){
      //       result = element.toString().substring(1,element.length);
      //     }
      //      var e  = result.toString().replaceAll('{', '');
      //      var xy = e.split(',');
      //      var x = xy[1].toString().split(':');
      //      var y = xy[0].toString().split(':');
      //     points.add(LatLng(double.parse(x[1]),double.parse(y[1])));

      //    }
      //     //경로그리기
      //     routerlist.add(Polyline(
      //       polylineId: PolylineId('router'),
      //       points:points,
      //       color:Colors.red,
      //     ));

      //     //bound설정
      //     double swx=0.0,swy=0.0,nex=0.0,ney=0.0;
      //     startx < endx ? {swx =startx,nex =endx} : {swx =endx,nex =startx};
      //     starty < endy ? {swy =starty,ney =endy} : {swy =endy,ney =endy};
      //     LatLngBounds bound = LatLngBounds(southwest: LatLng(swy,swx), northeast: LatLng(ney,nex));
      //     print(bound);
      //     final cont = await mcontroller.future;
      //     cont.animateCamera(CameraUpdate.newLatLngBounds(bound, 100));

          
      // }
    
  }

  void listsearch() async {
    print(await storage.containsKey(key: 'searchlist'));
    if(await storage.containsKey(key: 'searchlist')){
      String? searchtext = await storage.read(key: 'searchlist');
      List<dynamic> setsearchlist = searchtext.toString().split(',');
      setsearchlist.forEach((element) { 
        Navicontroller.to.searchlist.add(element);
      });
    }
    print(Navicontroller.to.searchlist.length);
  }
  

  //검색결과 내부저장
  Future<void> innersaveresultjuso(DoroJuso i,double lat, double lon) async {
    var searchresult;
    List<dynamic> templist =[];
    templist.add(i.bdNm.toString()+'/'+i.roadAddrPart1.toString()+'/'+lat.toString()+'/'+lon.toString());
    if(await storage.containsKey(key: 'searchlist')){
      searchresult = await storage.read(key: 'searchlist');
      templist.addAll(searchresult.toString().split(','));
    }
    
    while(templist.length > 10){
      templist.removeAt(templist.length-1);
    }
    
    var temp = templist.toString().replaceAll('[', '');
    temp = temp.replaceAll('[', '');
    
    await storage.write(
        key: 'searchlist',
        value: temp,
        );
  }

  //검색결과삭제
  Future<void> innerdeleteresultjuso(int index) async {
    Navicontroller.to.searchlist.removeAt(index);
    await storage.delete(key: 'searchlist');
    if(Navicontroller.to.searchlist.length !=0){
      await storage.write(
        key: 'searchlist',
        value: Navicontroller.to.searchlist.join(','),
        );
    }
    
  }
}