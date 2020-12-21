import 'package:flutter/material.dart';

class Employer {
  String companyName;
  String imgUrl;
  String address;
  double lat;
  double long;
  bool govt;
  String companyContact;
  String personalNumber;
  String state;
  String firebaseId;

  Employer({
    this.companyName,
    this.imgUrl,
    this.address,
    this.lat,
    this.long,
    this.govt,
    this.companyContact,
    this.personalNumber,
    this.state,
    this.firebaseId,
  });
}
