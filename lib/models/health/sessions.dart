class Sessions {
  String sessionId;
  String date;
  int availableCapacity;
  int minAgeLimit;
  String vaccine;
  List<String> slots;

  Sessions(
      {this.sessionId,
      this.date,
      this.availableCapacity,
      this.minAgeLimit,
      this.vaccine,
      this.slots});

  Sessions.fromJson(Map<String, dynamic> json) {
    sessionId = json['session_id'];
    date = json['date'];
    availableCapacity = json['available_capacity'];
    minAgeLimit = json['min_age_limit'];
    vaccine = json['vaccine'];
    slots = json['slots'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['session_id'] = this.sessionId;
    data['date'] = this.date;
    data['available_capacity'] = this.availableCapacity;
    data['min_age_limit'] = this.minAgeLimit;
    data['vaccine'] = this.vaccine;
    data['slots'] = this.slots;
    return data;
  }
}
