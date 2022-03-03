class Stationinfo {
  double? lat;
  double? lng;
  String? busiId;
  String? businNm;
  String? statId;
  String? statUpdDt;
  String? stat;
  int? count;
  String? statNm;
  String? addr;
  String? parkingFree;
  Stationinfo({
    this.lat,
    this.lng,
    this.busiId,
    this.businNm,
    this.statId,
    this.statUpdDt,
    this.stat,
    this.count,
    this.statNm,
    this.addr,
    this.parkingFree,
  });

  Stationinfo.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
    busiId = json['busiId'];
    businNm = json['businNm'];
    statId = json['statId'];
    statUpdDt = json['statUpdDt'];
    stat = json['stat'];
    statNm = json['statNm'];
    count = json['count'];
    addr = json['addr'];
    parkingFree = json['parkingFree'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['busiId'] = this.busiId;
    data['businNm'] = this.businNm;
    data['statId'] = this.statId;
    data['statUpdDt'] = this.statUpdDt;
    data['stat'] = this.stat;
    data['statNm'] = this.statNm;
    data['count'] = this.count;
    data['addr'] = this.addr;
    data['parkingFree'] = this.parkingFree;
    return data;
  }

  String setMarkerinfo(int count) {
    switch (count) {
      case 0:
        return "asset/marker/0.PNG";
      case 1:
        return "asset/marker/1.PNG";
      case 2:
        return "asset/marker/2.PNG";
      case 3:
        return "asset/marker/3.PNG";
      default:
        return "asset/marker/4.PNG";
    }
  }
}
