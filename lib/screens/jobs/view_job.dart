import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
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
  Box<String> appdata;
  double userLat = 0.0, userLong = 0.0;
  double dist = 0.0;

  @override
  void didChangeDependencies() async {
    if (!_init) {
      final args = ModalRoute.of(context).settings.arguments as Map;
      jobid = args["jobid"];
      jobsProvider = Provider.of<JobsProvider>(context);
      print(jobid);
      // jobsProvider.getJobById(jobid);
      job = args["job"];

      if (Hive.isBoxOpen("appdata"))
        appdata = Hive.box<String>("appdata");
      else {
        await Hive.openBox("appdata");
        appdata = Hive.box<String>("appdata");
      }
      print(appdata.toMap());
      userLat = double.parse(appdata.get("lat") ?? 0);
      userLong = double.parse(appdata.get("long") ?? 0);

      dist = Geolocator.distanceBetween(userLat, userLong, job.lat, job.long) /
          1000;

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
      body: _loading
          ? CircularProgressIndicator()
          : Stack(
              children: [
                CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      title: Text(job.title, overflow: TextOverflow.ellipsis),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.map),
                          onPressed: () async {
                            await MapsLauncher.launchCoordinates(
                                job.lat, job.long);
                          },
                        )
                      ],
                      expandedHeight: MediaQuery.of(context).size.height / 3,
                      pinned: true,
                      backgroundColor: Colors.blueGrey,
                      flexibleSpace: FlexibleSpaceBar(
                          titlePadding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          centerTitle: true,
                          collapseMode: CollapseMode.parallax,
                          background: Container(
                              height: 200,
                              child: Container(
                                child: job.imgUrl != "" && job.imgUrl != null
                                    ? CachedNetworkImage(
                                        imageUrl: job.imgUrl, fit: BoxFit.cover)
                                    // TODO Placeholder
                                    : Container(),
                              ))),
                      stretch: true,
                    ),
                    SliverPadding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          Text(job.title, style: TextStyle(fontSize: 30)),
                          Text(job.hiringParty, style: TextStyle(fontSize: 20)),
                          Text(timeago.format(DateTime.parse(job.postedAt)),
                              style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 10),
                          Text(dist.toStringAsFixed(1) + " Km Away",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black54)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(),
                              Text("\u{20B9} ${job.salary}",
                                  style: TextStyle(
                                      color: Themes.primaryColor,
                                      fontSize: 35,
                                      fontWeight: FontWeight.w300)),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(),
                              Text(
                                  job.jobTypeIndex == 0
                                      ? "/day  "
                                      : job.jobTypeIndex == 1
                                          ? "/contract  "
                                          : "/month  ",
                                  style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          jobHeading("Skills Required"),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              for (int i = 0; i < job.jobTags.length; i++)
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Themes.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Text(
                                        Constants.tagsToChips[(job.jobTags[i])],
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 20),
                          jobHeading("About The Job"),
                          Text(job.desc),
                          SizedBox(height: 25),
                          jobHeading("Type of Job"),
                          Text(job.jobTypeIndex == 0
                              ? "Single Day"
                              : job.jobTypeIndex == 1
                                  ? "Short Duration"
                                  : "Regular"),
                          SizedBox(height: 25),
                          jobHeading(job.jobTypeIndex == 0
                              ? "Job Date"
                              : job.jobTypeIndex == 1
                                  ? "Job Duration"
                                  : ""),
                          if (job.jobTypeIndex == 0)
                            Text(formatDate(
                                job.startDate, [d, '-', M, '-', yyyy])),
                          if (job.jobTypeIndex == 1)
                            Text(formatDate(
                                    job.startDate, [d, '-', M, '-', yyyy]) +
                                " to " +
                                formatDate(
                                    job.endDate, [d, '-', M, '-', yyyy])),
                          if (job.jobTypeIndex == 2) Text("Date: Regular Job"),
                          SizedBox(height: 25),
                          jobHeading("Timings"),
                          Text(
                              "${job.startTime.format(context)} - ${job.endTime.format(context)}"),
                          SizedBox(height: 25),
                          jobHeading("Location"),
                          Text(job.location),
                          FlatButton(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.map),
                                SizedBox(width: 10),
                                Text("Navigate"),
                              ],
                            ),
                            onPressed: () async {
                              await MapsLauncher.launchCoordinates(
                                  job.lat, job.long);
                            },
                          ),
                          SizedBox(height: 25),
                          jobHeading("Note"),
                          Text(job.specialNotes),
                          SizedBox(height: 200),
                        ]),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () async {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                                content: Row(
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(width: 20),
                                    Text("Loading")
                                  ],
                                ),
                              )); 
                      await jobsProvider.applyForJob(
                          candidateId: appdata.get("firebaseToken"),
                          candidateName: "ABC Candidate",
                          jobId: job.jobID,
                          jobTitle: job.title,
                          employerId: job.employerId);

                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Themes.primaryColor,
                        // borderRadius: BorderRadius.only(
                        //     topLeft: Radius.circular(15),
                        //     topRight: Radius.circular(15))
                      ),
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

  Padding jobHeading(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(text,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300)),
      );
}
