class DoroJuso {
  String? roadAddr;
  String? roadAddrPart1;
  String? roadAddrPart2;
  String? jibunAddr;
  String? engAddr;
  String? zipNo;
  String? admCd;
  String? rnMgtSn;
  String? bdMgtSn;
  String? detBdNmList;
  String? bdNm;
  String? bdKdcd;
  String? siNm;
  String? sggNm;
  String? emdNm;
  String? liNm;
  String? rn;
  String? udrtYn;
  String? buldMnnm;
  String? buldSlno;
  String? mtYn;
  String? lnbrMnnm;
  String? lnbrSlno;
  String? emdNo;
  String? hstryYn;
  String? relJibun;
  String? hemdNm;

  DoroJuso(
      {this.roadAddr,
      this.roadAddrPart1,
      this.roadAddrPart2,
      this.jibunAddr,
      this.engAddr,
      this.zipNo,
      this.admCd,
      this.rnMgtSn,
      this.bdMgtSn,
      this.detBdNmList,
      this.bdNm,
      this.bdKdcd,
      this.siNm,
      this.sggNm,
      this.emdNm,
      this.liNm,
      this.rn,
      this.udrtYn,
      this.buldMnnm,
      this.buldSlno,
      this.mtYn,
      this.lnbrMnnm,
      this.lnbrSlno,
      this.emdNo,
      this.hstryYn,
      this.relJibun,
      this.hemdNm});

  DoroJuso.fromJson(Map<String, dynamic> json) {
    roadAddr = json['roadAddr'];
    roadAddrPart1 = json['roadAddrPart1'];
    roadAddrPart2 = json['roadAddrPart2'];
    jibunAddr = json['jibunAddr'];
    engAddr = json['engAddr'];
    zipNo = json['zipNo'];
    admCd = json['admCd'];
    rnMgtSn = json['rnMgtSn'];
    bdMgtSn = json['bdMgtSn'];
    detBdNmList = json['detBdNmList'];
    bdNm = json['bdNm'];
    bdKdcd = json['bdKdcd'];
    siNm = json['siNm'];
    sggNm = json['sggNm'];
    emdNm = json['emdNm'];
    liNm = json['liNm'];
    rn = json['rn'];
    udrtYn = json['udrtYn'];
    buldMnnm = json['buldMnnm'];
    buldSlno = json['buldSlno'];
    mtYn = json['mtYn'];
    lnbrMnnm = json['lnbrMnnm'];
    lnbrSlno = json['lnbrSlno'];
    emdNo = json['emdNo'];
    hstryYn = json['hstryYn'];
    relJibun = json['relJibun'];
    hemdNm = json['hemdNm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roadAddr'] = this.roadAddr;
    data['roadAddrPart1'] = this.roadAddrPart1;
    data['roadAddrPart2'] = this.roadAddrPart2;
    data['jibunAddr'] = this.jibunAddr;
    data['engAddr'] = this.engAddr;
    data['zipNo'] = this.zipNo;
    data['admCd'] = this.admCd;
    data['rnMgtSn'] = this.rnMgtSn;
    data['bdMgtSn'] = this.bdMgtSn;
    data['detBdNmList'] = this.detBdNmList;
    data['bdNm'] = this.bdNm;
    data['bdKdcd'] = this.bdKdcd;
    data['siNm'] = this.siNm;
    data['sggNm'] = this.sggNm;
    data['emdNm'] = this.emdNm;
    data['liNm'] = this.liNm;
    data['rn'] = this.rn;
    data['udrtYn'] = this.udrtYn;
    data['buldMnnm'] = this.buldMnnm;
    data['buldSlno'] = this.buldSlno;
    data['mtYn'] = this.mtYn;
    data['lnbrMnnm'] = this.lnbrMnnm;
    data['lnbrSlno'] = this.lnbrSlno;
    data['emdNo'] = this.emdNo;
    data['hstryYn'] = this.hstryYn;
    data['relJibun'] = this.relJibun;
    data['hemdNm'] = this.hemdNm;
    return data;
  }
}
