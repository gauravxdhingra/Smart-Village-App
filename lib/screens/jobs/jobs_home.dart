import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:smart_village/models/job.dart';
import 'package:smart_village/provider/jobs_provider.dart';
import 'package:smart_village/provider/location_provider.dart';
import 'package:smart_village/screens/jobs/post_a_job.dart';
import 'package:smart_village/screens/jobs/search_jobs.dart';
import 'package:smart_village/screens/jobs/view_job.dart';
import 'package:smart_village/theme/theme.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:hive/hive.dart';
import 'package:geolocator/geolocator.dart';

class JobsHome extends StatefulWidget {
  JobsHome({Key key}) : super(key: key);
  static const routeName = "jobs_home";
  @override
  _JobsHomeState createState() => _JobsHomeState();
}

class _JobsHomeState extends State<JobsHome> {
  bool _loading = true;
  bool _init = false;

  bool secondView = false;
  bool jobSeeker = false;
  bool loading2 = true;

  JobsProvider jobsProvider;
  LocationProvider locationProvider;

  List<Job> jobs = [];
  LocationData _locationData;
  String address = "";

  List<Job> filterJobs = [];
  String selectedTag = "all";

  Map skillChipsData = {
    "all": "All",
    "skilled": "Skilled",
    "unskilled": "Unskilled",
    "agriculture": "Agriculture",
    "animalhusbandry": "Animal Husbandry",
    "clerical": "Clerical",
    "construction": "Conruction",
    "creative": "Creative",
    "factory": "Factory",
    "hospitality": "Hospitality",
    "labour": "Labour",
    "sales": "Sales",
    "sewing": "Sewing",
    "otherskilled": "Other Skilled",
  };

  Box<String> appdata;

  double userLat = 0.0, userLong = 0.0;
  Map dist = {};

  @override
  void didChangeDependencies() async {
    if (!_init) {
      jobsProvider = Provider.of<JobsProvider>(context);
      locationProvider = Provider.of<LocationProvider>(context);
      _locationData = await locationProvider.getLocation();
      address = await locationProvider.geocoder(_locationData);
      jobs = await jobsProvider.getJobs();
      if (Hive.isBoxOpen("appdata"))
        appdata = Hive.box<String>("appdata");
      else {
        await Hive.openBox("appdata");
        appdata = Hive.box<String>("appdata");
      }
      userLat = double.parse(appdata.get("lat") ?? 0);
      userLong = double.parse(appdata.get("long") ?? 0);
      if (appdata.get("userType") == "user") jobSeeker = true;
      if (appdata.get("userType") == "employer") jobSeeker = false;
      sortJobs();
      saveDist();

      setState(() {
        _init = true;
        _loading = false;
      });
    }
    super.didChangeDependencies();
  }

  double getDist(checkLat, checkLong) {
    final double distance =
        Geolocator.distanceBetween(userLat, userLong, checkLat, checkLong);
    print(distance);
    return distance;
  }

  sortJobs() {
    jobs.sort(
        (a, b) => getDist(a.lat, a.long).compareTo(getDist(b.lat, b.long)));
  }

  saveDist() {
    jobs.forEach((ele) {
      dist[ele.jobID] = getDist(ele.lat, ele.long) / 1000;
    });
  }

  List appliedJobIds = [];
  List<Job> appliedJobs = [];

  getAppliedJobs() async {
    setState(() {
      loading2 = true;
    });
    appliedJobIds = [];
    appliedJobs = [];
    List appJobsTemp =
        await jobsProvider.getAppliedJobsByUser(appdata.get("firebaseToken"));

    appJobsTemp.forEach((ele) {
      appliedJobIds.add(ele["jobId"]);
    });
    print(appliedJobIds);
    jobs.forEach((ele) {
      if (appliedJobIds.contains(ele.jobID)) appliedJobs.add(ele);
    });
    setState(() {
      loading2 = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(jobSeeker);
    return SafeArea(
      child: Scaffold(
        body: _loading
            ? Container(child: Center(child: CircularProgressIndicator()))
            : CustomScrollView(
                physics: BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height / 3,
                    pinned: true,
                    backgroundColor: Colors.blueGrey,
                    title: Text("Jobs"),
                    flexibleSpace: FlexibleSpaceBar(
                        titlePadding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        centerTitle: true,
                        collapseMode: CollapseMode.pin,
                        background: Container(height: 200, child: Container())),
                    actions: [
                      IconButton(
                          icon: Icon(Icons.search),
                          onPressed: _loading
                              ? null
                              : () => Navigator.pushNamed(
                                  context, SearchJobsPage.routeName,
                                  arguments: {"jobs": jobs}))
                    ],
                    stretch: true,
                  ),
                  if (!secondView)
                    SliverList(
                      delegate: SliverChildListDelegate([
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 60,
                              width: double.infinity,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  // TODO Add Chips Using Skills
                                  children: [
                                    SizedBox(width: 10),
                                    for (int i = 0;
                                        i < skillChipsData.length;
                                        i++)
                                      skillChips(
                                          skillChipsData.keys.elementAt(i),
                                          skillChipsData.values.elementAt(i)),
                                  ],
                                ),
                              ),
                            ),
                            if (filterJobs.isEmpty)
                              for (int i = 0; i < jobs.length; i++)
                                jobsListBuilder(context, i, jobs)
                            else
                              for (int i = 0; i < filterJobs.length; i++)
                                jobsListBuilder(context, i, filterJobs),
                            Container(height: 400, width: 100)
                          ],
                        ),
                      ]),
                    )
                  else
                    SliverList(
                        delegate: SliverChildListDelegate([
                      if (loading2)
                        Container(
                          height: 500,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 15),
                              child: Text("Applied Jobs",
                                  style: TextStyle(fontSize: 20)),
                            ),
                            if (appliedJobs.length == 0)
                              Text("No Jobs Applied!")
                            else
                              for (int i = 0; i < appliedJobs.length; i++)
                                jobsListBuilder(context, i, appliedJobs),
                          ],
                        ),
                    ]))
                ],
              ),
        // TODO REVERSE
        floatingActionButton: !jobSeeker
            ? FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                            child: Column(children: [Text("Filter Jobs")]),
                          ));
                },
                child: Icon(Icons.sort))
            : FloatingActionButton(
                heroTag: null,
                onPressed: () =>
                    Navigator.pushNamed(context, PostAJob.routeName),
                child: Icon(Icons.add)),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 60,
          color: Themes.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 5),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    secondView = false;
                  });
                  // await getAppliedJobs();
                },
                child: Row(
                  children: [
                    Icon(Icons.explore,
                        color: secondView
                            ? Colors.white.withOpacity(0.5)
                            : Colors.white),
                    SizedBox(width: 5),
                    Text("Explore Jobs",
                        style: TextStyle(
                            color: secondView
                                ? Colors.white.withOpacity(0.5)
                                : Colors.white)),
                  ],
                ),
              ),
              Container(width: 0.7, height: 30, color: Colors.white),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    secondView = true;
                  });
                  await getAppliedJobs();
                },
                child: Row(
                  children: [
                    Icon(Icons.check_box,
                        color: !secondView
                            ? Colors.white.withOpacity(0.5)
                            : Colors.white),
                    SizedBox(width: 5),
                    jobSeeker
                        ? Text("Applied Jobs",
                            style: TextStyle(
                                color: !secondView
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.white))
                        : Text("Published Jobs",
                            style: TextStyle(
                                color: !secondView
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.white)),
                  ],
                ),
              ),
              SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }

  Padding jobsListBuilder(BuildContext context, int i, List<Job> jobsList) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Card(
        child: ListTile(
          onTap: () {
            Navigator.pushNamed(context, ViewJobScreen.routeName,
                arguments: {"jobid": jobsList[i].jobID, "job": jobsList[i]});
          },
          leading: Container(
            child: jobsList[i].imgUrl != null
                ? CachedNetworkImage(
                    imageUrl: jobsList[i].imgUrl == ""
                        ? "https://cdn2.iconfinder.com/data/icons/people-icons-5/100/m-20-512.png"
                        : jobsList[i].imgUrl,
                    fit: BoxFit.cover,
                    height: 90,
                    width: 80)
                : CircleAvatar(),
          ),
          title: Text(
            jobsList[i].title ?? "Title",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(jobsList[i].hiringParty ?? "Company"),
              Text(jobsList[i].desc ?? "Job Description"),
              Text(dist[jobsList[i].jobID].toStringAsFixed(1) + " Km Away"),
              Text(timeago.format(DateTime.parse(jobsList[i].postedAt)),
                  style: TextStyle(color: Colors.grey)),
            ],
          ),
          trailing: Text("\u20B9 ${jobsList[i].salary ?? "0"}",
              style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          isThreeLine: true,
        ),
      ),
    );
  }

  Padding skillChips(skill, label) => Padding(
        padding: const EdgeInsets.only(right: 15),
        child: InkWell(
          onTap: () {
            filterJobs = [];
            String tag = skillChipsData.keys.firstWhere(
                (k) => skillChipsData[k] == label,
                orElse: () => null);
            selectedTag = tag ?? "all";
            print("1 " + jobs.length.toString());
            print("1 " + jobs.length.toString());

            if (tag != "all") {
              print(tag);
              filterJobs = [];
              jobs.forEach((ele) {
                if (ele.jobTags != null) if (ele.jobTags.contains(tag)) {
                  filterJobs.add(ele);
                }
              });
              print(filterJobs.length);
            } else {
              filterJobs = jobs;
            }

            setState(() {});
          },
          child: Container(
            decoration: BoxDecoration(
                color: label == skillChipsData[selectedTag]
                    ? Themes.primaryColor
                    : Colors.grey,
                borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(label, style: TextStyle(color: Colors.white)),
          ),
        ),
      );
}
