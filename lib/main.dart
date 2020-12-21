import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:smart_village/provider/auth_provider.dart';
import 'package:smart_village/provider/location_provider.dart';
import 'package:smart_village/screens/auth/enterNumber.dart';
import 'package:smart_village/screens/auth/otp_Screen.dart';
import 'package:smart_village/screens/jobs/post_a_job.dart';
import 'screens/auth/create_profile.dart';

import 'provider/jobs_provider.dart';

import 'screens/agriculture/agriculture_home.dart';
import 'screens/courses/courses_home.dart';
import 'screens/jobs/jobs_home.dart';
import 'screens/jobs/search_jobs.dart';
import 'screens/notification_screen/notifications_screen.dart';
import 'screens/pageview/pageview.dart';
import 'screens/splash_screen/splash_screen.dart';
import 'theme/theme.dart';
import 'screens/jobs/view_job.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox<String>('appdata');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProvider.value(
          value: LocationProvider(),
        ),
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
          // '/': (context) => PageViewHome(),
          // '/': (context) => JobsHome(),
          // '/': (context) => EnterNumberPage(),
          '/': (context) => SplashScreen(),
          AgricultureHome.routeName: (context) => AgricultureHome(),
          JobsHome.routeName: (context) => JobsHome(),
          CoursesHome.routeName: (context) => CoursesHome(),
          CreateProfile.routeName: (context) => CreateProfile(),
          PostAJob.routeName: (context) => PostAJob(),
          NotificationScreen.routeName: (context) => NotificationScreen(),
          OTPScreen.routeName: (context) => OTPScreen(),
          PageViewHome.routeName: (context) => PageViewHome(),
          SearchJobsPage.routeName: (context) => SearchJobsPage(),
          ViewJobScreen.routeName: (context) => ViewJobScreen(),
        },
      ),
    );
  }
}
