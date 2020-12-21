import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:smart_village/screens/auth/enterNumber.dart';
import 'package:smart_village/screens/pageview/pageview.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  Box<String> appdata;
  @override
  void initState() {
    if (Hive.isBoxOpen("appdata")) appdata = Hive.box<String>("appdata");
    var init = appdata.get("firebaseToken");
    // if (init == null) {
    //   appdata.put("init", "true");
    // }
    print(init);
    Timer(
        Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) =>
                init != null ? PageViewHome() : EnterNumberPage())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
      ),
    );
  }
}
