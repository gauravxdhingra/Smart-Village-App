import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_village/models/job.dart';
import 'package:smart_village/provider/jobs_provider.dart';
import 'package:smart_village/theme/theme.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:maps_launcher/maps_launcher.dart';

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
  Job job;

  @override
  void didChangeDependencies() {
    if (!_init) {
      final args = ModalRoute.of(context).settings.arguments as Map;
      jobid = args["jobid"];
      jobsProvider = Provider.of<JobsProvider>(context);
      print(jobid);
      // jobsProvider.getJobById(jobid);
      job = args["job"];

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
      body: Stack(
        children: [
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                title: Text(job.title),
                actions: [
                  IconButton(
                    icon: Icon(Icons.map),
                    onPressed: () async {
                      await MapsLauncher.launchCoordinates(job.lat, job.long);
                    },
                  )
                ],
                expandedHeight: MediaQuery.of(context).size.height / 3,
                pinned: true,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                flexibleSpace: FlexibleSpaceBar(
                    titlePadding:
                        EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    centerTitle: true,
                    collapseMode: CollapseMode.parallax,
                    background: Hero(
                      tag: "job",
                      child: Container(
                          height: 200,
                          child: Container(
                            child: CachedNetworkImage(
                                imageUrl: job.imgUrl, fit: BoxFit.cover),
                          )),
                    )),
                stretch: true,
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Text(job.title),
                  Text(job.hiringParty),
                  Text(timeago.format(DateTime.parse(job.postedAt))),
                  // TODO Job Tags
                  SizedBox(height: 10),
                  Text(job.desc),
                  Text(job.jobTypeIndex == 0
                      ? "Single Day"
                      : job.jobTypeIndex == 1
                          ? "Duration"
                          : "Monthly"),
                  if (job.jobTypeIndex == 0) Text("Date: ${job.startDate}"),
                  if (job.jobTypeIndex == 1)
                    Text("Date: ${job.startDate} to ${job.endDate}"),
                  if (job.jobTypeIndex == 2) Text("Date: Monthly Job"),
                  Text(
                      "Timings: ${job.startTime.format(context)} - ${job.endTime.format(context)}"),
                  Text("Salary: ${job.salary}"),
                  Text("Address:" + job.location),
                  Text("Special Notes"),
                  Text(job.specialNotes),
                  Text(job.jobTags.toString()),
                ]),
              ),
            ],
          ),
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
