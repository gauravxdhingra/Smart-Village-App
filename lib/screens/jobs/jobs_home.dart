import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:smart_village/provider/jobs_provider.dart';
import 'package:smart_village/provider/location_provider.dart';
import 'package:smart_village/screens/jobs/post_a_job.dart';
import 'package:smart_village/screens/jobs/search_jobs.dart';
import 'package:smart_village/screens/jobs/view_job.dart';
import 'package:smart_village/theme/theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class JobsHome extends StatefulWidget {
  JobsHome({Key key}) : super(key: key);
  static const routeName = "jobs_home";
  @override
  _JobsHomeState createState() => _JobsHomeState();
}

class _JobsHomeState extends State<JobsHome> {
  bool _loading = true;
  bool _init = false;

  bool jobSeeker = false;

  JobsProvider jobsProvider;
  LocationProvider locationProvider;

  List jobs = [];
  LocationData _locationData;
  String address = "";

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

  @override
  void didChangeDependencies() async {
    if (!_init) {
      jobsProvider = Provider.of<JobsProvider>(context);
      locationProvider = Provider.of<LocationProvider>(context);
      _locationData = await locationProvider.getLocation();
      address = await locationProvider.geocoder(_locationData);
      jobs = await jobsProvider.getJobs();

      setState(() {
        _init = true;
        _loading = false;
      });
    }
    super.didChangeDependencies();
  }

  refreshJobs() async {
    setState(() {
      _loading = true;
    });
    jobs = await jobsProvider.getJobs();
    setState(() {
      _init = true;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                                  context, SearchJobsPage.routeName))
                    ],
                    stretch: true,
                  ),
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
                                    skillChips(skillChipsData.keys.elementAt(i),
                                        skillChipsData.values.elementAt(i)),
                                ],
                              ),
                            ),
                          ),
                          for (int i = 0; i < jobs.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 10, right: 10),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, ViewJobScreen.routeName,
                                        arguments: {"jobid": jobs[i]["id"]});
                                  },
                                  leading: Container(
                                    child: jobs[i]["imgUrl"] != null
                                        ? Image.network(jobs[i]["imgUrl"] == ""
                                            ? "https://cdn2.iconfinder.com/data/icons/people-icons-5/100/m-20-512.png"
                                            : jobs[i]["imgUrl"])
                                        : CircleAvatar(),
                                  ),
                                  title: Text(
                                    jobs[i]["title"] ?? "Title",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(jobs[i]["hiringParty"] ?? "Company"),
                                      Text(
                                          jobs[i]["desc"] ?? "Job Description"),
                                      Text(
                                        timeago.format(
                                          DateTime.parse(jobs[i]["postedAt"]),
                                          // jobs[i]["postedAt"].toDate()),
                                        ),
                                        style: TextStyle(color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  trailing: Text(
                                    "\u20B9 ${jobs[i]["salary"] ?? "0"}",
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  isThreeLine: true,
                                ),
                              ),
                            ),
                          RaisedButton(
                              onPressed: () async {
                                await refreshJobs();
                              },
                              child: Text("Refresh")),
                          Container(height: 400, width: 100)
                        ],
                      ),
                    ]),
                  ),
                ],
              ),
        floatingActionButton: jobSeeker
            ? FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                            child: Column(children: [Text("Filter Jobs")]),
                          ));
                },
                child: Icon(Icons.sort))
            : FloatingActionButton(
                onPressed: () =>
                    Navigator.pushNamed(context, PostAJob.routeName),
                child: Icon(Icons.add)),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 50,
          color: Themes.primaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(width: 5),
              Icon(Icons.explore, color: Colors.white),
              Text("Explore Jobs", style: TextStyle(color: Colors.white)),
              SizedBox(width: 5),
              Container(width: 0.7, height: 30, color: Colors.white),
              SizedBox(width: 5),
              Icon(Icons.check_box, color: Colors.white.withOpacity(0.7)),
              Text("Applied Jobs", style: TextStyle(color: Colors.white)),
              SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }

  Padding skillChips(skill, label) => Padding(
        padding: const EdgeInsets.only(right: 15),
        child: GestureDetector(
          onTap: () {},
          child: Container(
            decoration: BoxDecoration(
                color: Themes.primaryColor,
                borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(label, style: TextStyle(color: Colors.white)),
          ),
        ),
      );
}
