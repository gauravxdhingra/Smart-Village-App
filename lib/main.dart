import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:smart_village/provider/healthcare_provider.dart';

import 'provider/auth_provider.dart';
import 'provider/jobs_provider.dart';
import 'provider/location_provider.dart';
import 'screens/agriculture/agriculture_home.dart';
import 'screens/auth/create_profile.dart';
import 'screens/auth/employer_signup.dart';
import 'screens/auth/enterNumber.dart';
import 'screens/auth/otp_Screen.dart';
import 'screens/auth/user_signup.dart';
import 'screens/courses/courses_home.dart';
import 'screens/healthcare/healthcare.dart';
import 'screens/jobs/jobs_home.dart';
import 'screens/jobs/post_a_job.dart';
import 'screens/jobs/search_jobs.dart';
import 'screens/jobs/view_job.dart';
import 'screens/notification_screen/notifications_screen.dart';
import 'screens/pageview/pageview.dart';
import 'screens/splash_screen/splash_screen.dart';
import 'theme/theme.dart';

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
          value: HealthCareProvider(),
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
          textTheme: GoogleFonts.openSansTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          // '/': (context) => PageViewHome(),
          // '/': (context) => JobsHome(),
          // '/': (context) => EmployerSignup(),
          '/': (context) => SplashScreen(),
          AgricultureHome.routeName: (context) => AgricultureHome(),
          JobsHome.routeName: (context) => JobsHome(),
          CoursesHome.routeName: (context) => CoursesHome(),
          CreateProfile.routeName: (context) => CreateProfile(),
          EmployerSignup.routeName: (context) => EmployerSignup(),
          EnterNumberPage.routeName: (context) => EnterNumberPage(),
          HealthCareScreen.routeName: (context) => HealthCareScreen(),
          NotificationScreen.routeName: (context) => NotificationScreen(),
          OTPScreen.routeName: (context) => OTPScreen(),
          PostAJob.routeName: (context) => PostAJob(),
          PageViewHome.routeName: (context) => PageViewHome(),
          SearchJobsPage.routeName: (context) => SearchJobsPage(),
          UserSignup.routeName: (context) => UserSignup(),
          ViewJobScreen.routeName: (context) => ViewJobScreen(),
        },
      ),
    );
  }
}
