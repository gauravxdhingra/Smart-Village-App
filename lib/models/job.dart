import 'package:flutter/material.dart';

class Job {
  String title;
  String hiringParty;
  String desc;
  String imgUrl;
  DateTime startDate;
  DateTime endDate;
  double salary;
  String location;
  double lat;
  double long;

  Job({
    this.title,
    this.hiringParty,
    this.desc,
    this.imgUrl,
    this.startDate,
    this.endDate,
    this.salary,
    this.location,
    this.lat = 0.0,
    this.long = 0.0,
  });
}
