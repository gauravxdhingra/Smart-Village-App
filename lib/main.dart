import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider/jobs_provider.dart';
import 'screens/agriculture/agriculture_home.dart';
import 'screens/courses/courses_home.dart';
import 'screens/jobs/jobs_home.dart';
import 'screens/jobs/search_jobs.dart';
import 'screens/pageview/pageview.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => PageViewHome(),
          AgricultureHome.routeName: (context) => AgricultureHome(),
          JobsHome.routeName: (context) => JobsHome(),
          CoursesHome.routeName: (context) => CoursesHome(),
          SearchJobsPage.routeName: (context) => SearchJobsPage(),
        },
      ),
    );
  }
}
