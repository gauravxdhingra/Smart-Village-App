import 'package:flutter/material.dart';
import 'package:smart_village/models/job.dart';

class PostAJob extends StatefulWidget {
  PostAJob({Key key}) : super(key: key);
  static const routeName = "post_a_job";
  @override
  _PostAJobState createState() => _PostAJobState();
}

class _PostAJobState extends State<PostAJob> {
  Job jobPosting = Job();
  submitJob() {}

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
                      }),
                  SizedBox(height: 10),
                  buildTextFormField(
                      labelText: "Job Description",
                      onChange: (val) {
                        jobPosting.desc = val;
                      }),
                  SizedBox(height: 10),
                  Container(
                    height: 150,
                    width: double.infinity,
                    child: Center(child: Text("Add an image")),
                  ),
                  SizedBox(height: 10),
                  buildTextFormField(
                    labelText: "Salary",
                    onChange: (val) {
                      jobPosting.salary = val;
                    },
                    inputType: TextInputType.numberWithOptions(),
                  ),
                  SizedBox(height: 10),
                  buildTextFormField(
                      labelText: "Job Location",
                      onChange: (val) {
                        jobPosting.location = val;
                      }),
                ],
              ),
            ),
          ),
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
