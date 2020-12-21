import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_village/models/job.dart';
import 'package:smart_village/provider/jobs_provider.dart';
import 'package:smart_village/theme/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:place_picker/place_picker.dart';

import '../../apikey.dart';

class PostAJob extends StatefulWidget {
  PostAJob({Key key}) : super(key: key);
  static const routeName = "post_a_job";
  @override
  _PostAJobState createState() => _PostAJobState();
}

class _PostAJobState extends State<PostAJob> {
  bool init = false;
  bool loading = true;
  Job jobPosting;

  JobsProvider jobsProvider;

  List<String> jobType = ['Single Day', 'Custom Duration', 'Monthly Job'];
  int jobTypeIndex = 0;
  TimeOfDay startTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 18, minute: 0);

  @override
  void didChangeDependencies() {
    if (!init) {
      jobsProvider = Provider.of<JobsProvider>(context);
      jobPosting = Job();
      jobPosting.startTime = startTime;
      jobPosting.endTime = endTime;
    }
    setState(() {
      init = true;
      loading = false;
    });
    super.didChangeDependencies();
  }

  // TODO IMAGE UPLOAD

  File _image;
  final picker = ImagePicker();

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
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: Icon(Icons.camera),
                    title: Text("Camera"),
                    onTap: () async {
                      Navigator.pop(context);
                      getImage("cam");
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo),
                    title: Text("Gallery"),
                    onTap: () async {
                      Navigator.pop(context);
                      getImage("gal");
                    },
                  ),
                ],
              ),
              actions: [
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  }

  // Future<void> retrieveLostData() async {
  //   final LostData response = await picker.getLostData();
  //   if (response.isEmpty) {
  //     return;
  //   }
  //   if (response.file != null) {
  //     setState(() {
  //       if (response.type == RetrieveType.video) {
  //         _handleVideo(response.file);
  //       } else {
  //         _handleImage(response.file);
  //       }
  //     });
  //   } else {
  //     _handleError(response.exception);
  //   }
  // }

  dropdownButton() {
    return DropdownButton<String>(
      items: jobType.map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(value),
        );
      }).toList(),
      hint: Text(jobType[jobTypeIndex]),
      onChanged: (value) {
        jobTypeIndex = jobType.indexOf(value);
        setState(() {});
      },
    );
  }

  List<String> tags = [];
  List<String> options = [
    "Skilled",
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
    "All": "all",
    "Skilled": "skilled",
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

  String jobTitle = "";
  String hiringParty = "";
  String imgUrl = "";
  String jobDesc = "";
  double salary = 0.0;
  DateTime startDate;
  DateTime endDate;
  String jobAddress = "";
  double lat = 0.0;
  double long = 0.0;
  String specialNotes = "";
  TextEditingController addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Post A Job"),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Form(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  // Text("Post a job"),
                  SizedBox(height: 15),
                  buildTextFormField(
                      labelText: "Job Title",
                      onChange: (val) {
                        jobPosting.title = val;
                        print(jobPosting.title);
                      }),
                  SizedBox(height: 10),
                  buildTextFormField(
                      labelText: "Hiring for",
                      onChange: (val) {
                        jobPosting.hiringParty = val;
                        print(jobPosting.hiringParty);
                      }),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      await choseImageSrc();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Themes.primaryColor),
                      height: 100,
                      width: double.infinity,
                      child: Center(child: Text("Add an image")),
                    ),
                  ),
                  SizedBox(height: 10),
                  _image == null
                      ? Text('No image selected.')
                      : Image.file(_image),
                  if (_image != null)
                    FlatButton(
                      child: Text("Remove"),
                      onPressed: () {
                        _image = null;
                        setState(() {});
                      },
                    ),
                  SizedBox(height: 20),
                  buildTextFormField(
                      labelText: "Job Description",
                      maxLines: 5,
                      inputType: TextInputType.multiline,
                      onChange: (val) {
                        jobPosting.desc = val;
                        print(jobPosting.desc);
                      }),
                  SizedBox(height: 10),
                  // TODO Choice

                  ChipsChoice<String>.multiple(
                    value: tags,
                    onChanged: (val) => setState(() {
                      tags = val;
                      jobPosting.jobTags = getJobTags(tags);
                      print(jobPosting.jobTags);
                    }),
                    choiceItems: C2Choice.listFrom<String, String>(
                      source: options,
                      value: (i, v) => v,
                      label: (i, v) => v,
                    ),
                  ),

                  SizedBox(height: 10),
                  buildTextFormField(
                    labelText: "Salary",
                    onChange: (val) {
                      jobPosting.salary = double.parse(val);
                      print(jobPosting.salary);
                    },
                    inputType: TextInputType.numberWithOptions(),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      dropdownButton(),
                      // SizedBox(height: 10),
                      if (jobTypeIndex == 0)
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                child: SfDateRangePicker(
                                  onSelectionChanged: (args) {
                                    if (args.value is DateTime) {
                                      DateTime date = args.value;
                                      jobPosting.startDate = date;
                                      print(date.toString());
                                    }
                                  },
                                  backgroundColor: Colors.white,
                                  selectionMode:
                                      DateRangePickerSelectionMode.single,
                                  enablePastDates: false,
                                ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Themes.primaryColor),
                            height: 50,
                            width: 130,
                            child: Center(child: Text("Select Date")),
                          ),
                        ),
                      if (jobTypeIndex == 1)
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                child: SfDateRangePicker(
                                  onSelectionChanged: (args) {
                                    PickerDateRange range = args.value;
                                    print(range.startDate.toString() +
                                        "   " +
                                        range.endDate.toString());
                                    jobPosting.startDate = range.startDate;
                                    jobPosting.endDate = range.endDate;
                                  },
                                  backgroundColor: Colors.white,
                                  selectionMode:
                                      DateRangePickerSelectionMode.range,
                                  enablePastDates: false,
                                ));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Themes.primaryColor),
                            height: 50,
                            width: 130,
                            child: Center(child: Text("Select Duration")),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            showPicker(
                              context: context,
                              value: startTime,
                              onChange: (pickedTime) {
                                setState(() {
                                  print(pickedTime);
                                  jobPosting.startTime = pickedTime;
                                  startTime = pickedTime;
                                });
                              },
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Themes.primaryColor),
                          height: 50,
                          width: 130,
                          child: Center(child: Text("Starting Time")),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            showPicker(
                              context: context,
                              value: endTime,
                              onChange: (pickedTime) {
                                setState(() {
                                  print(pickedTime);
                                  jobPosting.endTime = pickedTime;
                                  endTime = pickedTime;
                                });
                              },
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Themes.primaryColor),
                          height: 50,
                          width: 130,
                          child: Center(child: Text("Ending Time")),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(startTime.format(context).toString()),
                      Text(endTime.format(context).toString()),
                    ],
                  ),
                  SizedBox(height: 10),
                  buildTextFormField(
                      labelText: "Job Address",
                      onChange: (val) {
                        jobPosting.location = val;
                        print(jobPosting.location);
                      },
                      maxLines: 3,
                      inputType: TextInputType.multiline,
                      controller: addressController),
                  SizedBox(height: 10),
                  InkWell(
                      onTap: () async {
                        Future<LatLng> showPlacePicker() async {
                          LocationResult result = await Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (context) => PlacePicker(
                                        ApiKey.mapsApiKey,
                                        // displayLocation: customLocation,
                                      )));
                          jobAddress = result.formattedAddress;
                          print(result.formattedAddress);
                          return result.latLng;
                        }

                        LatLng coords = await showPlacePicker();

                        jobPosting.lat = coords.latitude;
                        jobPosting.long = coords.longitude;
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
                  SizedBox(height: 10),
                  if (jobAddress != "")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(jobAddress)),
                        FlatButton(
                          child: Text("Replace Address"),
                          onPressed: () {
                            addressController.text = jobAddress;
                            jobAddress = "";
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  SizedBox(height: 20),
                  buildTextFormField(
                      labelText: "Special Notes",
                      onChange: (val) {
                        jobPosting.specialNotes = val;
                        print(jobPosting.specialNotes);
                      },
                      maxLines: 2,
                      inputType: TextInputType.multiline),
                  SizedBox(height: 150),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            // TODO SUBMIT
            await jobsProvider.submitJob(jobPosting, context);
            Navigator.pop(context);
          },
          label: Text("Submit"),
          icon: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }

  Container buildTextFormField(
      {String labelText,
      Function onChange,
      TextInputType inputType,
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
