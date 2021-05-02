import 'sessions.dart';
import 'vaccine_fees.dart';

class Centers {
  int centerId;
  String name;
  String stateName;
  String districtName;
  String blockName;
  int pincode;
  int lat;
  int long;
  String from;
  String to;
  String feeType;
  List<Sessions> sessions;
  List<VaccineFees> vaccineFees;

  Centers(
      {this.centerId,
      this.name,
      this.stateName,
      this.districtName,
      this.blockName,
      this.pincode,
      this.lat,
      this.long,
      this.from,
      this.to,
      this.feeType,
      this.sessions,
      this.vaccineFees});

  Centers.fromJson(Map<String, dynamic> json) {
    centerId = json['center_id'];
    name = json['name'];
    stateName = json['state_name'];
    districtName = json['district_name'];
    blockName = json['block_name'];
    pincode = json['pincode'];
    lat = json['lat'];
    long = json['long'];
    from = json['from'];
    to = json['to'];
    feeType = json['fee_type'];
    if (json['sessions'] != null) {
      sessions = [];
      json['sessions'].forEach((v) {
        sessions.add(new Sessions.fromJson(v));
      });
    }
    if (json['vaccine_fees'] != null) {
      vaccineFees = [];
      json['vaccine_fees'].forEach((v) {
        vaccineFees.add(new VaccineFees.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['center_id'] = this.centerId;
    data['name'] = this.name;
    data['state_name'] = this.stateName;
    data['district_name'] = this.districtName;
    data['block_name'] = this.blockName;
    data['pincode'] = this.pincode;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['from'] = this.from;
    data['to'] = this.to;
    data['fee_type'] = this.feeType;
    if (this.sessions != null) {
      data['sessions'] = this.sessions.map((v) => v.toJson()).toList();
    }
    if (this.vaccineFees != null) {
      data['vaccine_fees'] = this.vaccineFees.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
