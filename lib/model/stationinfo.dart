class Stationinfo {
  String? addr;
  String? busiCall;
  String? busiId;
  String? busiNm;
  String? chgerId;
  String? chgerType;
  String? delDetail;
  String? delYn;
  double? lat;
  String? limitDetail;
  String? limitYn;
  double? lng;
  String? note;
  String? parkingFree;
  String? powerType;
  String? registry;
  int? seq;
  String? stat;
  String? statId;
  String? statNm;
  String? statUpdDt;
  String? useTime;
  String? zcode;


  Stationinfo(
      {this.addr,
      this.busiCall,
      this.busiId,
      this.busiNm,
      this.chgerId,
      this.chgerType,
      this.delDetail,
      this.delYn,
      this.lat,
      this.limitDetail,
      this.limitYn,
      this.lng,
      this.note,
      this.parkingFree,
      this.powerType,
      this.registry,
      this.seq,
      this.stat,
      this.statId,
      this.statNm,
      this.statUpdDt,
      this.useTime,
      this.zcode});

  Stationinfo.fromJson(Map<String, dynamic> json) {
    addr = json['addr'];
    busiCall = json['busiCall'];
    busiId = json['busiId'];
    busiNm = json['busiNm'];
    chgerId = json['chgerId'];
    chgerType = json['chgerType'];
    delDetail = json['delDetail'];
    delYn = json['delYn'];
    lat = json['lat'];
    limitDetail = json['limitDetail'];
    limitYn = json['limitYn'];
    lng = json['lng'];
    note = json['note'];
    parkingFree = json['parkingFree'];
    powerType = json['powerType'];
    registry = json['registry'];
    seq = json['seq'];
    stat = json['stat'];
    statId = json['statId'];
    statNm = json['statNm'];
    statUpdDt = json['statUpdDt'];
    useTime = json['useTime'];
    zcode = json['zcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addr'] = this.addr;
    data['busiCall'] = this.busiCall;
    data['busiId'] = this.busiId;
    data['busiNm'] = this.busiNm;
    data['chgerId'] = this.chgerId;
    data['chgerType'] = this.chgerType;
    data['delDetail'] = this.delDetail;
    data['delYn'] = this.delYn;
    data['lat'] = this.lat;
    data['limitDetail'] = this.limitDetail;
    data['limitYn'] = this.limitYn;
    data['lng'] = this.lng;
    data['note'] = this.note;
    data['parkingFree'] = this.parkingFree;
    data['powerType'] = this.powerType;
    data['registry'] = this.registry;
    data['seq'] = this.seq;
    data['stat'] = this.stat;
    data['statId'] = this.statId;
    data['statNm'] = this.statNm;
    data['statUpdDt'] = this.statUpdDt;
    data['useTime'] = this.useTime;
    data['zcode'] = this.zcode;
    return data;
  }
}
