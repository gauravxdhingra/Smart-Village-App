import 'package:flutter/material.dart';

class EnterNumberPage extends StatefulWidget {
  EnterNumberPage({Key key}) : super(key: key);
  static const routeName = "enter_number_page";
  @override
  _EnterNumberPageState createState() => _EnterNumberPageState();
}

class _EnterNumberPageState extends State<EnterNumberPage> {
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
                  Text("Enter your 10 digit mobile number"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          decoration: InputDecoration(
                            hintText: "Number",
                            counterText: "",
                          ),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {},
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
