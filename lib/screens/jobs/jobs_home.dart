import 'package:flutter/material.dart';

class JobsHome extends StatefulWidget {
  JobsHome({Key key}) : super(key: key);
  static const routeName = "jobs_home";
  @override
  _JobsHomeState createState() => _JobsHomeState();
}

class _JobsHomeState extends State<JobsHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jobs"),
        actions: [IconButton(icon: Icon(Icons.search), onPressed: () {})],
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
    );
  }
}
