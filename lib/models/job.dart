import 'package:flutter/material.dart';

class Job {
  String title;
  String desc;
  String imgUrl;
  Duration duration;
  double salary;
  String location;
  double lat;
  double long;

  Job({
    this.title,
    this.desc,
    this.imgUrl,
    this.duration,
    this.salary,
    this.location,
    this.lat,
    this.long,
  });
}
