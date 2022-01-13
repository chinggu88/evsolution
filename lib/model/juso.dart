class Juso {
  SearchPoiInfo? searchPoiInfo;

  Juso({this.searchPoiInfo});

  Juso.fromJson(Map<String, dynamic> json) {
    searchPoiInfo = json['searchPoiInfo'] != null
        ? new SearchPoiInfo.fromJson(json['searchPoiInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.searchPoiInfo != null) {
      data['searchPoiInfo'] = this.searchPoiInfo!.toJson();
    }
    return data;
  }
}

class SearchPoiInfo {
  String? totalCount;
  String? count;
  String? page;
  Pois? pois;

  SearchPoiInfo({this.totalCount, this.count, this.page, this.pois});

  SearchPoiInfo.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    count = json['count'];
    page = json['page'];
    pois = json['pois'] != null ? new Pois.fromJson(json['pois']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    data['count'] = this.count;
    data['page'] = this.page;
    if (this.pois != null) {
      data['pois'] = this.pois!.toJson();
    }
    return data;
  }
}

class Pois {
  List<Poi>? poi;

  Pois({this.poi});

  Pois.fromJson(Map<String, dynamic> json) {
    if (json['poi'] != null) {
      poi = <Poi>[];
      json['poi'].forEach((v) {
        poi!.add(new Poi.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.poi != null) {
      data['poi'] = this.poi!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Poi {
  String? id;
  String? pkey;
  String? navSeq;
  String? collectionType;
  String? name;
  String? telNo;
  String? frontLat;
  String? frontLon;
  String? noorLat;
  String? noorLon;
  String? upperAddrName;
  String? middleAddrName;
  String? lowerAddrName;
  String? detailAddrName;
  String? mlClass;
  String? firstNo;
  String? secondNo;
  String? roadName;
  String? firstBuildNo;
  String? secondBuildNo;
  String? radius;
  String? bizName;
  String? upperBizName;
  String? middleBizName;
  String? lowerBizName;
  String? detailBizName;
  String? rpFlag;
  String? parkFlag;
  String? detailInfoFlag;
  String? desc;
  String? dataKind;
  NewAddressList? newAddressList;
  EvChargers? evChargers;

  Poi(
      {this.id,
      this.pkey,
      this.navSeq,
      this.collectionType,
      this.name,
      this.telNo,
      this.frontLat,
      this.frontLon,
      this.noorLat,
      this.noorLon,
      this.upperAddrName,
      this.middleAddrName,
      this.lowerAddrName,
      this.detailAddrName,
      this.mlClass,
      this.firstNo,
      this.secondNo,
      this.roadName,
      this.firstBuildNo,
      this.secondBuildNo,
      this.radius,
      this.bizName,
      this.upperBizName,
      this.middleBizName,
      this.lowerBizName,
      this.detailBizName,
      this.rpFlag,
      this.parkFlag,
      this.detailInfoFlag,
      this.desc,
      this.dataKind,
      this.newAddressList,
      this.evChargers});

  Poi.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pkey = json['pkey'];
    navSeq = json['navSeq'];
    collectionType = json['collectionType'];
    name = json['name'];
    telNo = json['telNo'];
    frontLat = json['frontLat'];
    frontLon = json['frontLon'];
    noorLat = json['noorLat'];
    noorLon = json['noorLon'];
    upperAddrName = json['upperAddrName'];
    middleAddrName = json['middleAddrName'];
    lowerAddrName = json['lowerAddrName'];
    detailAddrName = json['detailAddrName'];
    mlClass = json['mlClass'];
    firstNo = json['firstNo'];
    secondNo = json['secondNo'];
    roadName = json['roadName'];
    firstBuildNo = json['firstBuildNo'];
    secondBuildNo = json['secondBuildNo'];
    radius = json['radius'];
    bizName = json['bizName'];
    upperBizName = json['upperBizName'];
    middleBizName = json['middleBizName'];
    lowerBizName = json['lowerBizName'];
    detailBizName = json['detailBizName'];
    rpFlag = json['rpFlag'];
    parkFlag = json['parkFlag'];
    detailInfoFlag = json['detailInfoFlag'];
    desc = json['desc'];
    dataKind = json['dataKind'];
    newAddressList = json['newAddressList'] != null
        ? new NewAddressList.fromJson(json['newAddressList'])
        : null;
    evChargers = json['evChargers'] != null
        ? new EvChargers.fromJson(json['evChargers'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pkey'] = this.pkey;
    data['navSeq'] = this.navSeq;
    data['collectionType'] = this.collectionType;
    data['name'] = this.name;
    data['telNo'] = this.telNo;
    data['frontLat'] = this.frontLat;
    data['frontLon'] = this.frontLon;
    data['noorLat'] = this.noorLat;
    data['noorLon'] = this.noorLon;
    data['upperAddrName'] = this.upperAddrName;
    data['middleAddrName'] = this.middleAddrName;
    data['lowerAddrName'] = this.lowerAddrName;
    data['detailAddrName'] = this.detailAddrName;
    data['mlClass'] = this.mlClass;
    data['firstNo'] = this.firstNo;
    data['secondNo'] = this.secondNo;
    data['roadName'] = this.roadName;
    data['firstBuildNo'] = this.firstBuildNo;
    data['secondBuildNo'] = this.secondBuildNo;
    data['radius'] = this.radius;
    data['bizName'] = this.bizName;
    data['upperBizName'] = this.upperBizName;
    data['middleBizName'] = this.middleBizName;
    data['lowerBizName'] = this.lowerBizName;
    data['detailBizName'] = this.detailBizName;
    data['rpFlag'] = this.rpFlag;
    data['parkFlag'] = this.parkFlag;
    data['detailInfoFlag'] = this.detailInfoFlag;
    data['desc'] = this.desc;
    data['dataKind'] = this.dataKind;
    if (this.newAddressList != null) {
      data['newAddressList'] = this.newAddressList!.toJson();
    }
    if (this.evChargers != null) {
      data['evChargers'] = this.evChargers!.toJson();
    }
    return data;
  }
}

class NewAddressList {
  List<NewAddress>? newAddress;

  NewAddressList({this.newAddress});

  NewAddressList.fromJson(Map<String, dynamic> json) {
    if (json['newAddress'] != null) {
      newAddress = <NewAddress>[];
      json['newAddress'].forEach((v) {
        newAddress!.add(new NewAddress.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.newAddress != null) {
      data['newAddress'] = this.newAddress!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewAddress {
  String? centerLat;
  String? centerLon;
  String? frontLat;
  String? frontLon;
  String? roadName;
  String? bldNo1;
  String? bldNo2;
  String? roadId;
  String? fullAddressRoad;

  NewAddress(
      {this.centerLat,
      this.centerLon,
      this.frontLat,
      this.frontLon,
      this.roadName,
      this.bldNo1,
      this.bldNo2,
      this.roadId,
      this.fullAddressRoad});

  NewAddress.fromJson(Map<String, dynamic> json) {
    centerLat = json['centerLat'];
    centerLon = json['centerLon'];
    frontLat = json['frontLat'];
    frontLon = json['frontLon'];
    roadName = json['roadName'];
    bldNo1 = json['bldNo1'];
    bldNo2 = json['bldNo2'];
    roadId = json['roadId'];
    fullAddressRoad = json['fullAddressRoad'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['centerLat'] = this.centerLat;
    data['centerLon'] = this.centerLon;
    data['frontLat'] = this.frontLat;
    data['frontLon'] = this.frontLon;
    data['roadName'] = this.roadName;
    data['bldNo1'] = this.bldNo1;
    data['bldNo2'] = this.bldNo2;
    data['roadId'] = this.roadId;
    data['fullAddressRoad'] = this.fullAddressRoad;
    return data;
  }
}

class EvChargers {
  List<dynamic>? evCharger;

  EvChargers({this.evCharger});

  EvChargers.fromJson(Map<String, dynamic> json) {
    if (json['evCharger'] != null) {
      evCharger = <dynamic>[];
      json['evCharger'].forEach((v) {
        evCharger!.add(EvChargers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.evCharger != null) {
      data['evCharger'] = this.evCharger!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class Address{
//   Common? common;
//   List<Juso>? jusoList;

//   Address({
//     this.common,
//     this.jusoList,
//   });

//   factory Address.formJson(Map<String,dynamic> json){
//     final results = json['results'];
//     final common = Common.fromJson(results['common']);
//     List<Juso> jusoList = [];
//     if(results['juso'] != null){
//       final jusoJsonList = results['juso'] as List;
//       jusoList = jusoJsonList.map((item) => Juso.fromJson(item)).toList();
//     }

//     return Address(
//       common: common,
//       jusoList: jusoList,
//     );
//   }
// }

// class Common{
//   String? errorMessage;
//   String? countPerPage;
//   String? totalCount;
//   String? errorCode;
//   String? currentPage;

//   Common({
//     this.errorMessage,
//     this.countPerPage,
//     this.totalCount,
//     this.errorCode,
//     this.currentPage
//   });

//   factory Common.fromJson(Map<String, dynamic> json){
//     return Common(
//       errorMessage: json['errorMessage'],
//       countPerPage: json['countPerPage'],
//       totalCount: json['totalCount'],
//       errorCode: json['errorCode'],
//       currentPage: json['currentPage'],
//     );
//   }
// }

// class Juso{
//   String? detBdNmList, engAddr, rn;
//   String? emdNm, zipNo, roadAddrPart2;
//   String? emdNo, sggNm, jibunAddr;
//   String? siNm, roadAddrPart1, bdNm;
//   String? admCd, udrtYn, lnbrMnnm;
//   String roadAddr, lnbrSlno, buldMnnm;
//   String bdKdcd, liNm, rnMgtSn;
//   String mtYn, bdMgtSn, buldSlno;

//   Juso({
//     this.detBdNmList, this.engAddr, this.rn,
//     this.emdNm, this.zipNo, this.roadAddrPart2,
//     this.emdNo, this.sggNm, this.jibunAddr,
//     this.siNm, this.roadAddrPart1, this.bdNm,
//     this.admCd, this.udrtYn, this.lnbrMnnm,
//     this.roadAddr, this.lnbrSlno, this.buldMnnm,
//     this.bdKdcd, this.liNm, this.rnMgtSn,
//     this.mtYn, this.bdMgtSn, this.buldSlno
//   });

//   factory Juso.fromJson(Map<String, dynamic> json){

//     return Juso(
//       detBdNmList: json["detBdNmList"],engAddr: json["engAddr"],rn: json["rn"],
//       emdNm: json["emdNm"],zipNo: json["zipNo"],roadAddrPart2: json["roadAddrPart2"],
//       emdNo: json["emdNo"],sggNm: json["sggNm"],jibunAddr: json["jibunAddr"],
//       siNm: json["siNm"],roadAddrPart1: json["roadAddrPart1"],bdNm: json["bdNm"],
//       admCd: json["admCd"],udrtYn: json["udrtYn"],lnbrMnnm: json["lnbrMnnm"],
//       roadAddr: json["roadAddr"],lnbrSlno: json["lnbrSlno"],buldMnnm: json["buldMnnm"],
//       bdKdcd: json["bdKdcd"],liNm: json["liNm"],rnMgtSn: json["rnMgtSn"],
//       mtYn: json["mtYn"],bdMgtSn: json["bdMgtSn"],buldSlno: json["buldSlno"],
//     );
//   }
// }
// [출처] [Flutter] 행정안전부 API를 이용한 주소검색-1|작성자 공중잡기