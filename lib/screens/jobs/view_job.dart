import 'package:flutter/material.dart';

class ViewJobScreen extends StatefulWidget {
  ViewJobScreen({Key key}) : super(key: key);
  static const routeName = "show_jobs_screen";
  @override
  _ViewJobScreenState createState() => _ViewJobScreenState();
}

class _ViewJobScreenState extends State<ViewJobScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
    ));
  }
}
