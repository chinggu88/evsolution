class routers {
  String? type;
  List<Features>? features;

  routers({this.type, this.features});

  routers.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if (json['features'] != null) {
      features = <Features>[];
      json['features'].forEach((v) {
        features!.add(new Features.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.features != null) {
      data['features'] = this.features!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Features {
  String? type;
  Geometry? geometry;
  Properties? properties;

  Features({this.type, this.geometry, this.properties});

  Features.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    properties = json['properties'] != null
        ? new Properties.fromJson(json['properties'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.geometry != null) {
      data['geometry'] = this.geometry!.toJson();
    }
    if (this.properties != null) {
      data['properties'] = this.properties!.toJson();
    }
    return data;
  }
}

class Geometry {
  String? type;
  dynamic? coordinates;
  //List<List<double>> , List<double>
  Geometry({this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}

class Properties {
  int? totalDistance;
  int? totalTime;
  int? totalFare;
  int? taxiFare;
  int? index;
  int? pointIndex;
  String? name;
  String? description;
  String? nextRoadName;
  int? turnType;
  String? pointType;
  int? lineIndex;
  int? distance;
  int? time;
  int? roadType;
  int? facilityType;

  Properties(
      {this.totalDistance,
      this.totalTime,
      this.totalFare,
      this.taxiFare,
      this.index,
      this.pointIndex,
      this.name,
      this.description,
      this.nextRoadName,
      this.turnType,
      this.pointType,
      this.lineIndex,
      this.distance,
      this.time,
      this.roadType,
      this.facilityType});

  Properties.fromJson(Map<String, dynamic> json) {
    totalDistance = json['totalDistance'];
    totalTime = json['totalTime'];
    totalFare = json['totalFare'];
    taxiFare = json['taxiFare'];
    index = json['index'];
    pointIndex = json['pointIndex'];
    name = json['name'];
    description = json['description'];
    nextRoadName = json['nextRoadName'];
    turnType = json['turnType'];
    pointType = json['pointType'];
    lineIndex = json['lineIndex'];
    distance = json['distance'];
    time = json['time'];
    roadType = json['roadType'];
    facilityType = json['facilityType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalDistance'] = this.totalDistance;
    data['totalTime'] = this.totalTime;
    data['totalFare'] = this.totalFare;
    data['taxiFare'] = this.taxiFare;
    data['index'] = this.index;
    data['pointIndex'] = this.pointIndex;
    data['name'] = this.name;
    data['description'] = this.description;
    data['nextRoadName'] = this.nextRoadName;
    data['turnType'] = this.turnType;
    data['pointType'] = this.pointType;
    data['lineIndex'] = this.lineIndex;
    data['distance'] = this.distance;
    data['time'] = this.time;
    data['roadType'] = this.roadType;
    data['facilityType'] = this.facilityType;
    return data;
  }
}
