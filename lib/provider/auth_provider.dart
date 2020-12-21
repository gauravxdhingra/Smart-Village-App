import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class AuthProvider with ChangeNotifier {
  String phoneNumber = "", verificationId = "";
  String otp = "", authStatus = "";

  Box<String> appdata;

  set setPhone(phone) => this.phoneNumber = phone;
  String get getAuthStatus => authStatus;
  set setAuthStatus(String authst) => this.authStatus = authst;
  String get firebaseToken => FirebaseAuth.instance.currentUser.uid;

  Future<void> verifyPhoneNumber(BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91" + phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) {
        authStatus = ("Your account is successfully verified");
        print(authStatus);
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

    if (Hive.isBoxOpen("appdata"))
      appdata = Hive.box<String>("appdata");
    else {
      await Hive.openBox("appdata");
      appdata = Hive.box<String>("appdata");
    }

    authStatus = ("Your account is successfully verified");
    print(FirebaseAuth.instance.currentUser.uid);
    appdata.put("firebaseToken", FirebaseAuth.instance.currentUser.uid);
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
