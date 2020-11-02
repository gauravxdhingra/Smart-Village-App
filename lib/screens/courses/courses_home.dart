import 'package:flutter/material.dart';

class CoursesHome extends StatefulWidget {
  CoursesHome({Key key}) : super(key: key);
  static const routeName = "courses_home";
  @override
  _CoursesHomeState createState() => _CoursesHomeState();
}

class _CoursesHomeState extends State<CoursesHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Courses"),
      ),
    );
  }
}
