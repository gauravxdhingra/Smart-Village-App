import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/employer.dart';
import '../models/user.dart' as user;

class AuthProvider with ChangeNotifier {
  String phoneNumber = "", verificationId = "";
  String otp = "", authStatus = "";
  final databaseReference = FirebaseFirestore.instance;

  Box<String> appdata;

  set setPhone(phone) => this.phoneNumber = phone;
  String get getAuthStatus => authStatus;
  set setAuthStatus(String authst) => this.authStatus = authst;
  String get firebaseToken => FirebaseAuth.instance.currentUser.uid;

  Future<void> verifyPhoneNumber(BuildContext context) async {
    await handleHive();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91" + phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) async {
        authStatus = ("Your account is successfully verified");
        print(authStatus);

        await appdata.put("phoneNumber", phoneNumber);
        print(appdata.get("phoneNumber"));
        notifyListeners();
      },
      verificationFailed: (
          // AuthException
          authException) {
        authStatus = "Authentication failed";
        print(authStatus);
        notifyListeners();
      },
      codeSent: (String verId, [int forceCodeResent]) {
        verificationId = verId;
        print(verId);
        authStatus = "OTP has been successfully send";
        print(authStatus);
        notifyListeners();
        // TODO DIALOG
        // otpDialogBox(context).then((value) {});
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
        authStatus = "TIMEOUT";
        print(authStatus);
        notifyListeners();
      },
    );
  }

  Future<void> signIn(String otp) async {
    print(verificationId);
    await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    ));

    await handleHive();
    authStatus = ("Your account is successfully verified");
    print(FirebaseAuth.instance.currentUser.uid);
    appdata.put("firebaseToken", FirebaseAuth.instance.currentUser.uid);
  }

  userSignup(user.User user, context) async {
    await handleHive();
    print(appdata.get("phoneNumber"));
    if (appdata.get("firebaseToken") != null)
      await databaseReference
          .collection('users')
          .doc(appdata.get("firebaseToken"))
          .set({
        "name": user.name,
        "applied": [],
        "gender": user.gender,
        "dob": user.dob.toIso8601String(),
        "imgUrl": user.imgUrl ??
            "https://i.pinimg.com/originals/51/f6/fb/51f6fb256629fc755b8870c801092942.png",
        "education": user.education,
        "villageTown": user.villageTown,
        "state": user.state,
        "address": user.address,
        "mobile": appdata.get("phoneNumber"),
        "skills": user.skills,
        "languages": user.languages,
        "firebaseId": appdata.get("firebaseToken"),
      });
    await appdata.put("userType", "user");
    return;
  }

  employerSignup(Employer employer, context) async {
    await handleHive();
    if (appdata.get("firebaseToken") != null)
      await databaseReference
          .collection('users')
          .doc(appdata.get("firebaseToken"))
          .set({
        "companyName": employer.companyName,
        "applied": [],
        "address": employer.address,
        "lat": employer.lat,
        "long": employer.long,
        "govt": employer.govt,
        "companyContact": employer.companyContact,
        "personalNumber": employer.personalNumber,
        "state": employer.state,
        "imgUrl": employer.imgUrl ??
            "https://static.thenounproject.com/png/88781-200.png",
        "mobile": appdata.get("phoneNumber"),
        "firebaseId": appdata.get("firebaseToken"),
      });
    await appdata.put("userType", "employer");
    return;
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  handleHive() async {
    if (Hive.isBoxOpen("appdata"))
      appdata = Hive.box<String>("appdata");
    else {
      await Hive.openBox("appdata");
      appdata = Hive.box<String>("appdata");
    }
  }
}
