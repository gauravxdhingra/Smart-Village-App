import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_village/provider/auth_provider.dart';
import 'package:smart_village/screens/jobs/jobs_home.dart';

class CreateProfile extends StatefulWidget {
  CreateProfile({Key key}) : super(key: key);
  static const routeName = "create_profile";
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  AuthProvider authProvider;
  bool init = false;

  TextEditingController _numberController = TextEditingController();

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
        title: Text("About You"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Form(
            child: Column(
          children: [
            Text("Skills Form to be updated through firebase"),
            Text("Skip For Now"),
            Text("Your Firebase Token" + authProvider.firebaseToken),
          ],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, JobsHome.routeName);
        },
        child: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
