import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_village/provider/auth_provider.dart';
import 'package:smart_village/screens/jobs/jobs_home.dart';
import 'package:smart_village/screens/pageview/pageview.dart';
import 'package:smart_village/theme/theme.dart';
import '../auth/user_signup.dart';
import '../auth/employer_signup.dart';

class CreateProfile extends StatefulWidget {
  CreateProfile({Key key}) : super(key: key);
  static const routeName = "create_profile";
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  AuthProvider authProvider;
  bool init = false;

  // TextEditingController _numberController = TextEditingController();

  @override
  void didChangeDependencies() {
    if (!init) authProvider = Provider.of<AuthProvider>(context);
    setState(() {
      init = true;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, UserSignup.routeName);
                },
                child: Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(color: Themes.primaryColor),
                  child: Center(child: Text("Get Started")),
                ),
              )),
          Align(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, EmployerSignup.routeName);
                },
                child: Container(
                  child: Text("Register as an employer\n"),
                ),
              )),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // Navigator.pushNamed(context, JobsHome.routeName);
      //     Navigator.pushNamed(context, PageViewHome.routeName);
      //   },
      //   child: Icon(Icons.arrow_forward_ios),
      // ),
    );
  }
}
