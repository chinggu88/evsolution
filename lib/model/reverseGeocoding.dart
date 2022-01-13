class ReversGeocoding {
  AddressInfo? addressInfo;

  ReversGeocoding({this.addressInfo});

  ReversGeocoding.fromJson(Map<String, dynamic> json) {
    addressInfo = json['addressInfo'] != null
        ? new AddressInfo.fromJson(json['addressInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.addressInfo != null) {
      data['addressInfo'] = this.addressInfo!.toJson();
    }
    return data;
  }
}

class AddressInfo {
  String? fullAddress;
  String? addressType;
  String? cityDo;
  String? guGun;
  String? eupMyun;
  String? adminDong;
  String? adminDongCode;
  String? legalDong;
  String? legalDongCode;
  String? ri;
  String? bunji;
  String? roadName;
  String? buildingIndex;
  String? buildingName;
  String? mappingDistance;
  String? roadCode;

  AddressInfo(
      {this.fullAddress,
      this.addressType,
      this.cityDo,
      this.guGun,
      this.eupMyun,
      this.adminDong,
      this.adminDongCode,
      this.legalDong,
      this.legalDongCode,
      this.ri,
      this.bunji,
      this.roadName,
      this.buildingIndex,
      this.buildingName,
      this.mappingDistance,
      this.roadCode});

  AddressInfo.fromJson(Map<String, dynamic> json) {
    fullAddress = json['fullAddress'];
    addressType = json['addressType'];
    cityDo = json['city_do'];
    guGun = json['gu_gun'];
    eupMyun = json['eup_myun'];
    adminDong = json['adminDong'];
    adminDongCode = json['adminDongCode'];
    legalDong = json['legalDong'];
    legalDongCode = json['legalDongCode'];
    ri = json['ri'];
    bunji = json['bunji'];
    roadName = json['roadName'];
    buildingIndex = json['buildingIndex'];
    buildingName = json['buildingName'];
    mappingDistance = json['mappingDistance'];
    roadCode = json['roadCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullAddress'] = this.fullAddress;
    data['addressType'] = this.addressType;
    data['city_do'] = this.cityDo;
    data['gu_gun'] = this.guGun;
    data['eup_myun'] = this.eupMyun;
    data['adminDong'] = this.adminDong;
    data['adminDongCode'] = this.adminDongCode;
    data['legalDong'] = this.legalDong;
    data['legalDongCode'] = this.legalDongCode;
    data['ri'] = this.ri;
    data['bunji'] = this.bunji;
    data['roadName'] = this.roadName;
    data['buildingIndex'] = this.buildingIndex;
    data['buildingName'] = this.buildingName;
    data['mappingDistance'] = this.mappingDistance;
    data['roadCode'] = this.roadCode;
    return data;
  }
}
