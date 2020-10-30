import 'package:flutter/material.dart';
import 'package:smart_village/screens/homepage/homepage.dart';

class PageViewHome extends StatefulWidget {
  PageViewHome({Key key}) : super(key: key);

  @override
  _PageViewHomeState createState() => _PageViewHomeState();
}

class _PageViewHomeState extends State<PageViewHome> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          children: [
            Homepage(),
          ],
        ),
      ),
    );
  }
}
