import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_village/models/job.dart';
import 'package:smart_village/provider/jobs_provider.dart';
import 'package:smart_village/theme/theme.dart';
import 'package:smart_village/util/constants.dart';
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
                    background: Container(
                        height: 200,
                        child: Container(
                          child: job.imgUrl != "" || job.imgUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: job.imgUrl, fit: BoxFit.cover)
                              // TODO Placeholder
                              : Container(),
                        ))),
                stretch: true,
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Text(job.title, style: TextStyle(fontSize: 30)),
                  Text(job.hiringParty, style: TextStyle(fontSize: 20)),
                  Text(timeago.format(DateTime.parse(job.postedAt)),
                      style: TextStyle(color: Colors.grey)),
                  Row(
                    children: [
                      for (int i = 0; i < job.jobTags.length; i++)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: Themes.primaryColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Text(Constants.tagsToChips[(job.jobTags[i])],
                              style: TextStyle(color: Colors.white)),
                        ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text("Rs. ${job.salary}"),
                  SizedBox(height: 10),
                  Text("About The Job"),
                  Text(job.desc),
                  SizedBox(height: 10),
                  Text("Type of Job"),
                  Text(job.jobTypeIndex == 0
                      ? "Single Day"
                      : job.jobTypeIndex == 1
                          ? "Short Duration"
                          : "Regular"),
                  SizedBox(height: 10),
                  Text(job.jobTypeIndex == 0
                      ? "Job Date"
                      : job.jobTypeIndex == 1
                          ? "Job Duration"
                          : ""),
                  if (job.jobTypeIndex == 0)
                    Text(formatDate(job.startDate, [d, '-', M, '-', yyyy])),
                  if (job.jobTypeIndex == 1)
                    Text(formatDate(job.startDate, [d, '-', M, '-', yyyy]) +
                        " to " +
                        formatDate(job.endDate, [d, '-', M, '-', yyyy])),
                  if (job.jobTypeIndex == 2) Text("Date: Regular Job"),
                  SizedBox(height: 10),
                  Text("Timings"),
                  Text(
                      "${job.startTime.format(context)} - ${job.endTime.format(context)}"),
                  SizedBox(height: 10),
                  Text("Location"),
                  Text(job.location),
                  SizedBox(height: 10),
                  Text("Note:"),
                  Text(job.specialNotes),
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
