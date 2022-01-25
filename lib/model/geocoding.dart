class Geocoding {
  String? coordType;
  String? addressFlag;
  String? matchFlag;
  String? lat;
  String? lon;
  String? cityDo;
  String? guGun;
  String? eupMyun;
  String? legalDong;
  String? legalDongCode;
  String? adminDong;
  String? adminDongCode;
  String? ri;
  String? bunji;
  String? newMatchFlag;
  String? newLat;
  String? newLon;
  String? newRoadName;
  String? newBuildingIndex;
  String? newBuildingName;
  String? newBuildingCateName;
  String? remainder;

  Geocoding(
      {this.coordType,
      this.addressFlag,
      this.matchFlag,
      this.lat,
      this.lon,
      this.cityDo,
      this.guGun,
      this.eupMyun,
      this.legalDong,
      this.legalDongCode,
      this.adminDong,
      this.adminDongCode,
      this.ri,
      this.bunji,
      this.newMatchFlag,
      this.newLat,
      this.newLon,
      this.newRoadName,
      this.newBuildingIndex,
      this.newBuildingName,
      this.newBuildingCateName,
      this.remainder});

  Geocoding.fromJson(Map<String, dynamic> json) {
    coordType = json['coordType'];
    addressFlag = json['addressFlag'];
    matchFlag = json['matchFlag'];
    lat = json['lat'];
    lon = json['lon'];
    cityDo = json['city_do'];
    guGun = json['gu_gun'];
    eupMyun = json['eup_myun'];
    legalDong = json['legalDong'];
    legalDongCode = json['legalDongCode'];
    adminDong = json['adminDong'];
    adminDongCode = json['adminDongCode'];
    ri = json['ri'];
    bunji = json['bunji'];
    newMatchFlag = json['newMatchFlag'];
    newLat = json['newLat'];
    newLon = json['newLon'];
    newRoadName = json['newRoadName'];
    newBuildingIndex = json['newBuildingIndex'];
    newBuildingName = json['newBuildingName'];
    newBuildingCateName = json['newBuildingCateName'];
    remainder = json['remainder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['coordType'] = this.coordType;
    data['addressFlag'] = this.addressFlag;
    data['matchFlag'] = this.matchFlag;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['city_do'] = this.cityDo;
    data['gu_gun'] = this.guGun;
    data['eup_myun'] = this.eupMyun;
    data['legalDong'] = this.legalDong;
    data['legalDongCode'] = this.legalDongCode;
    data['adminDong'] = this.adminDong;
    data['adminDongCode'] = this.adminDongCode;
    data['ri'] = this.ri;
    data['bunji'] = this.bunji;
    data['newMatchFlag'] = this.newMatchFlag;
    data['newLat'] = this.newLat;
    data['newLon'] = this.newLon;
    data['newRoadName'] = this.newRoadName;
    data['newBuildingIndex'] = this.newBuildingIndex;
    data['newBuildingName'] = this.newBuildingName;
    data['newBuildingCateName'] = this.newBuildingCateName;
    data['remainder'] = this.remainder;
    return data;
  }
}
