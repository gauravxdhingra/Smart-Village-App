import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_village/models/job.dart';
import 'package:smart_village/provider/jobs_provider.dart';
import 'package:smart_village/theme/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Post A Job"),
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  Text("Post a job"),
                  SizedBox(height: 10),
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
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Themes.primaryColor),
                    height: 100,
                    width: double.infinity,
                    child: Center(child: Text("Add an image")),
                  ),
                  SizedBox(height: 10),
                  buildTextFormField(
                      labelText: "Job Description",
                      onChange: (val) {
                        jobPosting.desc = val;
                        print(jobPosting.hiringParty);
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
                      jobPosting.salary = val;
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
                        print(jobPosting);
                      },
                      inputType: TextInputType.multiline),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Themes.primaryColor),
                    height: 50,
                    width: double.infinity,
                    child: Center(child: Text("Chose on map")),
                  ),
                  SizedBox(height: 10),
                  buildTextFormField(
                      labelText: "Special Notes",
                      onChange: (val) {
                        jobPosting.specialNotes = val;
                        print(jobPosting.specialNotes);
                      },
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

  TextFormField buildTextFormField(
      {String labelText, Function onChange, TextInputType inputType}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
        contentPadding: EdgeInsets.all(15.0),
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.grey[200],
      ),
      onChanged: (val) {
        onChange(val);
      },
      keyboardType: inputType ?? TextInputType.text,
    );
  }
}
