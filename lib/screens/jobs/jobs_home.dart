import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:smart_village/provider/jobs_provider.dart';
import 'package:smart_village/provider/location_provider.dart';
import 'package:smart_village/screens/jobs/post_a_job.dart';
import 'package:smart_village/screens/jobs/search_jobs.dart';
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

  bool jobSeeker = true;

  JobsProvider jobsProvider;
  LocationProvider locationProvider;

  List jobs = [];
  LocationData _locationData;
  String address = "";

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
                slivers: [
                  SliverAppBar(
                    expandedHeight: MediaQuery.of(context).size.height / 3,
                    pinned: true,
                    backgroundColor: Themes.primaryColor,
                    title: Text("Jobs"),
                    flexibleSpace: FlexibleSpaceBar(
                        titlePadding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        centerTitle: true,
                        collapseMode: CollapseMode.pin,
                        background: Container(
                            height: 200,
                            decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            child: Container(
                                decoration:
                                    BoxDecoration(color: Colors.blueGrey)))),
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
                  SliverToBoxAdapter(
                    child: Container(
                      height: 60,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          // TODO Add Chips Using Skills
                          children: [],
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate([
                    // ListView.builder(
                    //   itemBuilder: (context, i) =>
                    for (int i = 0; i < jobs.length; i++)
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, top: 10, right: 10),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            leading: Container(
                              child: Image.network(jobs[i]["imgUrl"] == ""
                                  ? "https://cdn2.iconfinder.com/data/icons/people-icons-5/100/m-20-512.png"
                                  : jobs[i]["imgUrl"]),
                            ),
                            title: Text(
                              jobs[i]["title"],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(jobs[i]["hiringParty"]),
                                Text(jobs[i]["desc"]),
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
                              "\u20B9 ${jobs[i]["salary"]}",
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
                    //   itemCount: jobs.length,
                    // ),
                    RaisedButton(
                      onPressed: () async {
                        await refreshJobs();
                      },
                      child: Text("Refresh"),
                    )
                  ])),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 400, width: 100),
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
                child: Icon(Icons.sort),
              )
            : FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, PostAJob.routeName);
                },
                child: Icon(Icons.add),
              ),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 50,
          color: Themes.primaryColor,
          // Colors.black.withOpacity(0.09),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(children: [
                Icon(Icons.explore, color: Colors.white),
                SizedBox(width: 5),
                Text("Explore Jobs", style: TextStyle(color: Colors.white))
              ]),
              Container(width: 1, height: 30, color: Colors.white),
              Row(children: [
                Icon(Icons.check_box, color: Colors.white.withOpacity(0.7)),
                SizedBox(width: 5),
                Text("Applied Jobs", style: TextStyle(color: Colors.white))
              ])
            ],
          ),
        ),
      ),
    );
  }
}
