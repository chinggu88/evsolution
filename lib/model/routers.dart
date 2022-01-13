class features {
  String? type;
  Geometry? geometry;
  Properties? properties;

  features({this.type, this.geometry, this.properties});

  features.fromJson(Map<String, dynamic> json) {
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
  List<double>? coordinates;

  Geometry({this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    coordinates = json['coordinates'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }
}
class GeometryList {
	String? type;
	List<List<double>>? coordinates;

	GeometryList({this.type, this.coordinates});

	GeometryList.fromJson(Map<String, dynamic> json) {
		type = json['type'];
		if (json['coordinates'] != null) {
			coordinates = <List<double>>[];
			json['coordinates'].forEach((v) { coordinates!.add(v); });
		}
	}

	// Map<String, dynamic> toJson() {
	// 	final Map<String, dynamic> data = new Map<String, dynamic>();
	// 	data['type'] = this.type;
	// 	if (this.coordinates != null) {
  //     data['coordinates'] = this.coordinates!.map((v) => v.toJson()).toList();
  //   }
	// 	return data;
	// }
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
      this.pointType});

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
    return data;
  }
}
