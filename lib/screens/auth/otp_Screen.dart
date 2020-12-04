import '../../provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'create_profile.dart';

class OTPScreen extends StatefulWidget {
  OTPScreen({Key key}) : super(key: key);
  static const routeName = "otp_screen";
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  AuthProvider authProvider;
  bool init = false;
  TextEditingController _otpController = TextEditingController();

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
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Enter OTP"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.56,
                        child: TextFormField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: InputDecoration(
                            hintText: "OTP",
                            counterText: "",
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () async {
                          authProvider.signIn(_otpController.text);
                          print(authProvider.getAuthStatus);
                          if (authProvider.getAuthStatus.contains("verified"))
                            Navigator.pushNamed(
                                context, CreateProfile.routeName);
                        },
                        child: Text("Go"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
