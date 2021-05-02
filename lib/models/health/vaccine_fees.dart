class VaccineFees {
  String vaccine;
  String fee;

  VaccineFees({this.vaccine, this.fee});

  VaccineFees.fromJson(Map<String, dynamic> json) {
    vaccine = json['vaccine'];
    fee = json['fee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vaccine'] = this.vaccine;
    data['fee'] = this.fee;
    return data;
  }
}
