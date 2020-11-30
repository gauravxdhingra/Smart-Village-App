import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_village/provider/jobs_provider.dart';
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

  JobsProvider jobsProvider;

  List jobs = [];

  @override
  void didChangeDependencies() async {
    if (!_init) {
      jobsProvider = Provider.of<JobsProvider>(context);
      jobs = await jobsProvider.getJobs();
      setState(() {
        _init = true;
        _loading = false;
      });
    }

    super.didChangeDependencies();
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
                    // elevation: 0.1,
                    expandedHeight: MediaQuery.of(context).size.height / 3,
                    pinned: true,
                    backgroundColor: Themes.primaryColor,
                    // floating: true,
                    leading: InkWell(
                        onTap: () async {
                          // locationProvider.geocoder(_locationData);
                        },
                        child: Icon(Icons.location_on_outlined)),
                    title: Text("Get Location"),

                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      centerTitle: true,
                      collapseMode: CollapseMode.pin,
                      background: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          image: DecorationImage(
                            image: NetworkImage(
                              "https://i.pinimg.com/564x/39/03/fe/3903fe18c342c0a1ed83917e283d1314.jpg",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.0))),
                        ),
                      ),
                    ),
                    actions: [
                      IconButton(
                          icon: Icon(Icons.search),
                          onPressed: _loading
                              ? null
                              : () {
                                  Navigator.pushNamed(
                                      context, SearchJobsPage.routeName);
                                })
                    ],
                    stretch: true,
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
                              child: Image.network(
                                  "https://cdn2.iconfinder.com/data/icons/people-icons-5/100/m-20-512.png"),
                            ),
                            title: Text(
                              jobs[i]["title"],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(jobs[i]["postedBy"]),
                                Text(jobs[i]["desc"]),
                                Text(
                                  timeago.format(jobs[i]["postedAt"].toDate()),
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                            trailing: Text(
                              "\u20B9 ${jobs[i]["pay"]}",
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
                  ])),
                  SliverToBoxAdapter(
                    child: SizedBox(height: 400, width: 100),
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, PostAJob.routeName);
          },
          child: Icon(Icons.add),
        ),
        bottomNavigationBar: Container(
          width: double.infinity,
          height: 50,
          color: Colors.black.withOpacity(0.09),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [Icon(Icons.sort), Text("Sort By")],
              ),
              Row(
                children: [
                  Icon(Icons.filter),
                  SizedBox(width: 5),
                  Text("Filter By")
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
