import 'centers.dart';

class VaccineData {
  List<Centers> centers;

  VaccineData({this.centers});

  VaccineData.fromJson(Map<String, dynamic> json) {
    if (json['centers'] != null) {
      centers = [];
      json['centers'].forEach((v) {
        centers.add(new Centers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.centers != null) {
      data['centers'] = this.centers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
