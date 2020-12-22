import 'package:flutter/material.dart';
import '../../theme/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:place_picker/place_picker.dart';
import '../../apikey.dart';
import 'package:chips_choice/chips_choice.dart';

import '../../models/employer.dart';

class EmployerSignup extends StatefulWidget {
  EmployerSignup({Key key}) : super(key: key);
  static const routeName = "employer_signup";
  @override
  _EmployerSignupState createState() => _EmployerSignupState();
}

class _EmployerSignupState extends State<EmployerSignup> {
  Employer employer;
  @override
  void initState() {
    employer = Employer();
    super.initState();
  }

  File _image;
  final picker = ImagePicker();
  String locationAddress = "";

  TextEditingController addressController = TextEditingController();

  Future getImage(String src) async {
    final pickedFile = await picker.getImage(
        source: src == "cam" ? ImageSource.camera : ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  choseImageSrc() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Pick Image Source"),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                ListTile(
                    leading: Icon(Icons.camera),
                    title: Text("Camera"),
                    onTap: () async {
                      Navigator.pop(context);
                      getImage("cam");
                    }),
                ListTile(
                    leading: Icon(Icons.photo),
                    title: Text("Gallery"),
                    onTap: () async {
                      Navigator.pop(context);
                      getImage("gal");
                    })
              ]),
              actions: [
                FlatButton(
                    child: Text("Cancel"),
                    onPressed: () => Navigator.pop(context))
              ],
            ));
  }

  bool govt = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register as an Employer"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  await choseImageSrc();
                },
                child: Stack(
                  children: [
                    CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.black12,
                        backgroundImage:
                            _image == null ? null : FileImage(_image)),
                    Positioned(
                        right: 18,
                        bottom: 18,
                        child: Icon(Icons.edit, color: Colors.white)),
                  ],
                ),
              ),
              SizedBox(height: 5),
              _image == null
                  ? Text('No image selected.')
                  : FlatButton(
                      child: Text("Remove"),
                      onPressed: () {
                        _image = null;
                        setState(() {});
                      }),
              SizedBox(height: 20),
              buildTextFormField(
                  labelText: "Company Name",
                  maxLines: 1,
                  onChange: (val) {
                    employer.companyName = val;
                  }),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() => govt = false);
                      employer.govt = govt;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: govt ? Colors.grey : Themes.primaryColor),
                      padding:
                          EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                      child: Text("Private Firm"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() => govt = true);
                      employer.govt = govt;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: !govt ? Colors.grey : Themes.primaryColor),
                      padding:
                          EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                      child: Text("Govt Firm"),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              buildTextFormField(
                  labelText: "Company Contact",
                  maxLines: 1,
                  inputType: TextInputType.number,
                  onChange: (val) {
                    employer.companyContact = val;
                  }),
              SizedBox(height: 20),
              buildTextFormField(
                  labelText: "Company Address",
                  maxLines: 3,
                  inputType: TextInputType.multiline,
                  controller: addressController,
                  onChange: (val) {
                    employer.address = val;
                  }),
              SizedBox(height: 10),
              buildTextFormField(
                  labelText: "State",
                  maxLines: 1,
                  onChange: (val) {
                    employer.state = val;
                  }),
              SizedBox(height: 20),
              InkWell(
                  onTap: () async {
                    Future<LatLng> showPlacePicker() async {
                      LocationResult result =
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PlacePicker(
                                    ApiKey.mapsApiKey,
                                    // displayLocation: customLocation,
                                  )));
                      locationAddress = result.formattedAddress;
                      print(result.formattedAddress);
                      return result.latLng;
                    }

                    LatLng coords = await showPlacePicker();
                    employer.lat = coords.latitude;
                    employer.long = coords.longitude;
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Themes.primaryColor),
                    height: 50,
                    width: double.infinity,
                    child: Center(child: Text("Select Location on Map")),
                  )),
              SizedBox(height: 20),
              if (locationAddress != "")
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(locationAddress)),
                    FlatButton(
                      child: Text("Replace Address"),
                      onPressed: () {
                        addressController.text = locationAddress;
                        locationAddress = "";
                        setState(() {});
                      },
                    ),
                  ],
                ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.done),
        label: Text("Submit"),
        onPressed: () {
          // TODO HANDLE SIGNUP
        },
      ),
    );
  }

  Container buildTextFormField(
      {String labelText,
      Function onChange,
      TextInputType inputType = TextInputType.text,
      int maxLines = 1,
      controller}) {
    return Container(
      decoration: BoxDecoration(
          color: Themes.primaryColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10)),
      child: TextFormField(
          controller: controller ?? null,
          decoration: InputDecoration(
              labelText: labelText,
              contentPadding: EdgeInsets.all(15.0),
              border: InputBorder.none),
          onChanged: (val) => onChange(val),
          maxLines: maxLines,
          keyboardType: inputType ?? TextInputType.text),
    );
  }
}
