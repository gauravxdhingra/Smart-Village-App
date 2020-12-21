import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_village/provider/jobs_provider.dart';
import 'package:smart_village/theme/theme.dart';

class ViewJobScreen extends StatefulWidget {
  ViewJobScreen({Key key}) : super(key: key);
  static const routeName = "show_jobs_screen";
  @override
  _ViewJobScreenState createState() => _ViewJobScreenState();
}

class _ViewJobScreenState extends State<ViewJobScreen> {
  bool _loading = true;
  bool _init = false;

  var jobid = "";
  JobsProvider jobsProvider;

  @override
  void didChangeDependencies() {
    if (!_init) {
      final args = ModalRoute.of(context).settings.arguments as Map;
      jobid = args["jobid"];
      jobsProvider = Provider.of<JobsProvider>(context);
      print(jobid);
      jobsProvider.getJobById(jobid);
      setState(() {
        _loading = false;
        _init = true;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () {},
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: Themes.primaryColor,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: Center(
                  child: Text("Apply",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
