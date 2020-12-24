import 'package:flutter/material.dart';
// import 'package:day_night_time_picker/day_night_time_picker.dart';

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
  TimeOfDay startTime;
  TimeOfDay endTime;
  int jobTypeIndex;
  List jobTags;
  String specialNotes;
  String jobID;
  String postedAt;
  String employerId;

  Job({
    this.title = "",
    this.hiringParty = "",
    this.desc = "",
    this.imgUrl = "",
    this.startDate,
    this.endDate,
    this.salary = 0.0,
    this.location = "",
    this.lat = 0.0,
    this.long = 0.0,
    this.startTime,
    this.endTime,
    this.jobTypeIndex = 0,
    this.jobTags,
    this.specialNotes,
    this.jobID = "",
    this.postedAt = "",
    this.employerId = "",
  });
}
