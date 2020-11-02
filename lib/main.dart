import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_village/provider/jobs_provider.dart';
import 'package:smart_village/screens/agriculture/agriculture_home.dart';
import 'package:smart_village/screens/courses/courses_home.dart';
import 'package:smart_village/screens/jobs/jobs_home.dart';
import 'package:smart_village/theme/theme.dart';

import 'screens/pageview/pageview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider.value(
        //   value: AuthProvider(),
        // ),
        ChangeNotifierProvider.value(
          value: JobsProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Themes.primaryColor,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routes: {
          '/': (context) => PageViewHome(),
          AgricultureHome.routeName: (context) => AgricultureHome(),
          JobsHome.routeName: (context) => JobsHome(),
          CoursesHome.routeName: (context) => CoursesHome(),
        },
      ),
    );
  }
}
