import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:smart_village/models/job.dart';
import 'package:smart_village/provider/jobs_provider.dart';
import 'package:smart_village/theme/theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class SearchJobsPage extends StatefulWidget {
  SearchJobsPage({Key key}) : super(key: key);
  static const routeName = "search_jobs_page";
  @override
  _SearchJobsPageState createState() => _SearchJobsPageState();
}

class _SearchJobsPageState extends State<SearchJobsPage> {
  JobsProvider jobsProvider;
  List<Job> jobs = [];

  @override
  void didChangeDependencies() {
    jobsProvider = Provider.of<JobsProvider>(context);
    Map args = ModalRoute.of(context).settings.arguments as Map;
    jobs = args["jobs"];
    // jobs = jobsProvider.jobsListGetter;
    // print(jobs);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Themes.primaryColor),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: "Search",
            enabledBorder: InputBorder.none,
            border: InputBorder.none,
          ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: Container(
                  child: CachedNetworkImage(
                      imageUrl:
                          "https://cdn2.iconfinder.com/data/icons/people-icons-5/100/m-20-512.png")),
              title: Text(
                jobs[i].title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(jobs[i].hiringParty),
                  Text(jobs[i].desc),
                  Text(
                    timeago.format(DateTime.parse(jobs[i].postedAt)),
                    style: TextStyle(color: Colors.grey),
                  )
                ],
              ),
              trailing: Text(
                "\u20B9 ${jobs[i].salary}",
                style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              isThreeLine: true,
            ),
          ),
        ),
        itemCount: jobs.length,
      ),
    );
  }
}
