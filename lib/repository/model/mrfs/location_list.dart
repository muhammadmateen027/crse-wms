class LocationList {
  List<Location> locations;

  LocationList({this.locations});

  LocationList.fromJson(Map<String, dynamic> json) {
    if (json['success'] != null) {
      locations = new List<Location>();
      json['success'].forEach((v) {
        locations.add(new Location.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.locations != null) {
      data['success'] = this.locations.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Location {
  int id;
  String name;

  Location({this.id, this.name});

  Location.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

