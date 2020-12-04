import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_village/models/job.dart';
import 'package:smart_village/provider/jobs_provider.dart';
import 'package:smart_village/theme/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PostAJob extends StatefulWidget {
  PostAJob({Key key}) : super(key: key);
  static const routeName = "post_a_job";
  @override
  _PostAJobState createState() => _PostAJobState();
}

class _PostAJobState extends State<PostAJob> {
  bool init = false;
  bool loading = true;
  Job jobPosting = Job();

  JobsProvider jobsProvider;

  List<String> jobType = ['Single Day', 'Custom Duration', 'Monthly Job'];
  int jobTypeIndex = 0;

  @override
  void didChangeDependencies() {
    if (!init) {
      jobsProvider = Provider.of<JobsProvider>(context);
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

  @override
  Widget build(BuildContext context) {
    print(jobPosting.salary);
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
                      }),
                  SizedBox(height: 10),
                  buildTextFormField(
                      labelText: "Hiring for",
                      onChange: (val) {
                        jobPosting.hiringParty = val;
                      }),
                  SizedBox(height: 10),
                  buildTextFormField(
                      labelText: "Job Description",
                      onChange: (val) {
                        jobPosting.desc = val;
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
                    labelText: "Salary",
                    onChange: (val) {
                      jobPosting.salary = val;
                      setState(() {});
                      print(val);
                    },
                    inputType: TextInputType.numberWithOptions(),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      dropdownButton(),
                      SizedBox(height: 10),
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
                      if (jobTypeIndex != 0)
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
                  SizedBox(height: 10),
                  buildTextFormField(
                      labelText: "Job Address",
                      onChange: (val) {
                        jobPosting.location = val;
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
                  SizedBox(height: 150),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await jobsProvider.submitJob(jobPosting);
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
        onChange(double.parse(val));
      },
      keyboardType: inputType ?? TextInputType.text,
    );
  }
}
