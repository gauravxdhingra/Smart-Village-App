import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:smart_village/theme/theme.dart';

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
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Enter OTP".toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Themes.primaryColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w300),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: PinCodeTextField(
                        appContext: context,
                        length: 6,
                        obscureText: false,
                        controller: _otpController,
                        animationType: AnimationType.scale,
                        cursorColor: Colors.black,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.underline,
                          fieldHeight: 50,
                          fieldWidth: 40,
                          inactiveColor: Themes.primaryColor.withOpacity(0.35),
                          // Theme.of(context).scaffoldBackgroundColor,
                          activeColor: Themes.primaryColor,
                          disabledColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          // selectedColor: Themes.primaryColor,
                          activeFillColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          inactiveFillColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          selectedFillColor:
                              Theme.of(context).scaffoldBackgroundColor,
                        ),
                        keyboardType: TextInputType.number,
                        animationDuration: Duration(milliseconds: 300),
                        enableActiveFill: true,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        // errorAnimationController: errorController,
                        // controller: textEditingController,
                        onCompleted: (v) async {
                          print("Completed");
                          authProvider.signIn(_otpController.text);
                          print(authProvider.getAuthStatus);
                          if (authProvider.getAuthStatus.contains("verified"))
                            Navigator.pushNamed(
                                context, CreateProfile.routeName);
                        },
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            // currentText = value;
                          });
                        },
                        // beforeTextPaste: (text) {
                        //   print("Allowing to paste $text");
                        //   //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //   //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        //   return true;
                        // },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            authProvider.signIn(_otpController.text);
            print(authProvider.getAuthStatus);
            if (authProvider.getAuthStatus.contains("verified"))
              Navigator.pushNamed(context, CreateProfile.routeName);
          },
          child: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }
}
