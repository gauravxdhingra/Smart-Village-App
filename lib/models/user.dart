import 'package:flutter/material.dart';

class User {
  String name;
  String gender;
  DateTime dob;
  String imgUrl;
  String education;
  String villageTown;
  String state;
  String address;
  int mobile;
  List skills;
  List languages;
  String firebaseId;

  User({
    this.name,
    this.gender,
    this.dob,
    this.imgUrl,
    this.education,
    this.villageTown,
    this.state,
    this.address,
    this.mobile,
    this.skills,
    this.languages,
    this.firebaseId,
  });
}
