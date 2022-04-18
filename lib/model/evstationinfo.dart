class Evstationinfo {
  String? addr;
  String? bnm;
  String? busiCall;
  String? busiId;
  String? busiNm;
  String? chgerId;
  String? chgerType;
  double? lat;
  double? lng;
  String? location;
  String? method;
  String? note;
  String? output;
  String? parkingFree;
  int? seq;
  String? stat;
  String? statId;
  String? statNm;
  String? useTime;
  String? zcode;

  Evstationinfo(
      {this.addr,
      this.bnm,
      this.busiCall,
      this.busiId,
      this.busiNm,
      this.chgerId,
      this.chgerType,
      this.lat,
      this.lng,
      this.location,
      this.method,
      this.note,
      this.output,
      this.parkingFree,
      this.seq,
      this.stat,
      this.statId,
      this.statNm,
      this.useTime,
      this.zcode});

  Evstationinfo.fromJson(Map<String, dynamic> json) {
    addr = json['addr'];
    bnm = json['bnm'];
    busiCall = json['busiCall'];
    busiId = json['busiId'];
    busiNm = json['busiNm'];
    chgerId = json['chgerId'];
    chgerType = json['chgerType'];
    lat = json['lat'];
    lng = json['lng'];
    location = json['location'];
    method = json['method'];
    note = json['note'];
    output = json['output'];
    parkingFree = json['parkingFree'];
    seq = json['seq'];
    stat = json['stat'];
    statId = json['statId'];
    statNm = json['statNm'];
    useTime = json['useTime'];
    zcode = json['zcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addr'] = this.addr;
    data['bnm'] = this.bnm;
    data['busiCall'] = this.busiCall;
    data['busiId'] = this.busiId;
    data['busiNm'] = this.busiNm;
    data['chgerId'] = this.chgerId;
    data['chgerType'] = this.chgerType;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['location'] = this.location;
    data['method'] = this.method;
    data['note'] = this.note;
    data['output'] = this.output;
    data['parkingFree'] = this.parkingFree;
    data['seq'] = this.seq;
    data['stat'] = this.stat;
    data['statId'] = this.statId;
    data['statNm'] = this.statNm;
    data['useTime'] = this.useTime;
    data['zcode'] = this.zcode;
    return data;
  }
}
