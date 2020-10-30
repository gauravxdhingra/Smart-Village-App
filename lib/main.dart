import 'package:flutter/material.dart';
import 'package:smart_village/theme/theme.dart';

import 'screens/pageview/pageview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Themes.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => PageViewHome(),
      },
    );
  }
}
