import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_village/provider/auth_provider.dart';
import 'package:smart_village/theme/theme.dart';
import 'otp_Screen.dart';

class EnterNumberPage extends StatefulWidget {
  EnterNumberPage({Key key}) : super(key: key);
  static const routeName = "enter_number_page";
  @override
  _EnterNumberPageState createState() => _EnterNumberPageState();
}

class _EnterNumberPageState extends State<EnterNumberPage> {
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
    return SafeArea(
      child: Scaffold(
          body: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Enter Your 10 Digit Mobile Number".toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Themes.primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("+91 "),
                          SizedBox(width: 10),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.56,
                            child: TextFormField(
                              autofocus: true,
                              controller: _numberController,
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              decoration: InputDecoration(
                                hintText: "Number",
                                counterText: "",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              authProvider.setPhone = (_numberController.text);
              await authProvider.verifyPhoneNumber(context);
              if (authProvider.getAuthStatus.contains("send"))
                Navigator.pushNamed(context, OTPScreen.routeName);
            },
            child: Icon(Icons.arrow_forward_ios),
          )),
    );
  }
}
