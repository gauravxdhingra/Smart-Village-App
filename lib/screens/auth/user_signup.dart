import 'package:flutter/material.dart';
import 'package:smart_village/provider/auth_provider.dart';
import 'package:smart_village/screens/pageview/pageview.dart';
import '../../theme/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:place_picker/place_picker.dart';
import '../../apikey.dart';
import 'package:chips_choice/chips_choice.dart';

import '../../models/user.dart';

class UserSignup extends StatefulWidget {
  UserSignup({Key key}) : super(key: key);
  static const routeName = "";
  @override
  _UserSignupState createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {
  User user;
  AuthProvider authProvider;
  @override
  void initState() {
    user = User();
    authProvider = AuthProvider();
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

  String gender = "Male";
  dropdownButton() {
    return DropdownButton<String>(
      items: dropdownList,
      hint: Text(gender),
      onChanged: (value) {
        gender = value;
        user.gender = gender;
        setState(() {});
      },
    );
  }

  List<DropdownMenuItem<String>> dropdownList = [
    DropdownMenuItem<String>(value: "Male", child: Text("Male")),
    DropdownMenuItem<String>(value: "Female", child: Text("Female")),
    DropdownMenuItem<String>(value: "Other", child: Text("Other"))
  ];

  List<String> tags = [];
  List<String> options = [
    "Unskilled",
    "Agriculture",
    "Animal Husbandry",
    'Clerical',
    'Conruction',
    'Creative',
    'Factory',
    'Hospitality',
    'Labour',
    'Sales',
    'Sewing',
    "Other Skilled",
  ];

  Map skilltags = {
    "Unskilled": "unskilled",
    "Agriculture": "agriculture",
    "Animal Husbandry": "animalhusbandry",
    "Clerical": "clerical",
    "Conruction": "construction",
    "Creative": "creative",
    "Factory": "factory",
    "Hospitality": "hospitality",
    "Labour": "labour",
    "Sales": "sales",
    "Sewing": "sewing",
    "Other Skilled": "otherskilled",
  };

  List getJobTags(List labels) {
    List jobTags = [];
    labels.forEach((element) {
      jobTags.add(skilltags[element]);
    });
    return jobTags;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
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
                    labelText: "Name",
                    maxLines: 1,
                    onChange: (val) {
                      user.name = val;
                    }),

                SizedBox(height: 20),
                RaisedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => SfDateRangePicker(
                        view: user.dob == null
                            ? DateRangePickerView.decade
                            : DateRangePickerView.month,
                        headerStyle: DateRangePickerHeaderStyle(
                            textAlign: TextAlign.center),
                        onSelectionChanged: (args) {
                          DateTime date = args.value;
                          user.dob = date;
                          print(user.dob);
                          Navigator.pop(context);
                        },
                        maxDate: DateTime(DateTime.now().year - 13),
                        backgroundColor: Colors.white,
                        showNavigationArrow: true,
                        allowViewNavigation: true,
                        initialDisplayDate: user.dob,
                        initialSelectedDate: user.dob,
                      ),
                    );
                  },
                  child: Text("Date Of Birth"),
                ),
                Text("* Older than 14 Years of Age"),

                SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Gender"),
                    dropdownButton(),
                  ],
                ),

                SizedBox(height: 20),

                buildTextFormField(
                    labelText: "Education",
                    maxLines: 4,
                    inputType: TextInputType.multiline,
                    onChange: (val) {
                      user.education = val;
                    }),

                SizedBox(height: 10),

                buildTextFormField(
                    labelText: "Address",
                    maxLines: 3,
                    inputType: TextInputType.multiline,
                    controller: addressController,
                    onChange: (val) {
                      user.address = val;
                    }),

                SizedBox(height: 10),

                buildTextFormField(
                    labelText: "Village/Town",
                    maxLines: 1,
                    onChange: (val) {
                      user.villageTown = val;
                    }),

                SizedBox(height: 10),

                buildTextFormField(
                    labelText: "State",
                    maxLines: 1,
                    onChange: (val) {
                      user.state = val;
                    }),
                // TODO Handle Skills

                SizedBox(height: 20),

                ChipsChoice<String>.multiple(
                  value: tags,
                  onChanged: (val) => setState(() {
                    tags = val;
                    user.skills = getJobTags(tags);
                    print(user.skills);
                  }),
                  choiceItems: C2Choice.listFrom<String, String>(
                    source: options,
                    value: (i, v) => v,
                    label: (i, v) => v,
                  ),
                ),

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
                      user.lat = coords.latitude;
                      user.long = coords.longitude;
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

                SizedBox(height: 20),

                buildTextFormField(
                    labelText: "Languages",
                    maxLines: 1,
                    onChange: (val) {
                      user.languages = val;
                    }),

                SizedBox(height: 100),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.done),
          label: Text("Submit"),
          onPressed: () async {
            authProvider.userSignup(user, context);
            Navigator.pushNamed(context, PageViewHome.routeName);
          },
        ),
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
