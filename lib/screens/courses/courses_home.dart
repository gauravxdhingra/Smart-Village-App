import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';

class CoursesHome extends StatefulWidget {
  CoursesHome({Key key}) : super(key: key);
  static const routeName = "courses_home";
  @override
  _CoursesHomeState createState() => _CoursesHomeState();
}

class _CoursesHomeState extends State<CoursesHome> {
  bool init = true;

  launchURL() async {
    const url =
        'https://www.youtube.com/watch?v=cvxiSk5dH3U&list=PLBcBU_WV3EWfyEXxqBUpb--YZ_-3B7yyq';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Skill Development Courses"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    await launchURL();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.width * 0.67,
                    width: MediaQuery.of(context).size.width * 0.67,
                    child: Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width * 0.67,
                          width: MediaQuery.of(context).size.width * 0.67,
                          padding: EdgeInsets.all(2),
                          child: CachedNetworkImage(
                              imageUrl:
                                  "https://www.ladiestailorinpune.com/wp-content/uploads/2018/04/class-2.jpg",
                              fit: BoxFit.cover),
                        ),
                        Align(
                            alignment: Alignment.lerp(
                                Alignment.bottomCenter, Alignment.center, 0.1),
                            child: Text("BASIC STITCHING AND KNITTING COURSE",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width * 0.335,
                      width: MediaQuery.of(context).size.width * 0.33,
                      padding: EdgeInsets.all(2),
                      child: Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.width * 0.335,
                            width: MediaQuery.of(context).size.width * 0.33,
                            child: CachedNetworkImage(
                                imageUrl:
                                    "https://cdn01.alison-static.net/courses/712/alison_courseware_intro_712.jpg",
                                fit: BoxFit.cover),
                          ),
                          Align(
                              alignment: Alignment.lerp(Alignment.bottomCenter,
                                  Alignment.center, 0.1),
                              child: Text("BASIC ELECTRICIAN COURSE",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.width * 0.335,
                      width: MediaQuery.of(context).size.width * 0.33,
                      padding: EdgeInsets.all(2),
                      child: Stack(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.width * 0.335,
                            width: MediaQuery.of(context).size.width * 0.33,
                            child: CachedNetworkImage(
                                imageUrl:
                                    "https://futurevisioninstitutes.com/Uploadimage/a14dbanner.jpg",
                                fit: BoxFit.cover),
                          ),
                          Align(
                              alignment: Alignment.lerp(Alignment.bottomCenter,
                                  Alignment.center, 0.1),
                              child: Text("BASIC COMPUTER COURSE",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  height: MediaQuery.of(context).size.width * 0.33,
                  width: MediaQuery.of(context).size.width * 0.334,
                  padding: EdgeInsets.all(2),
                  child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width * 0.33,
                        width: MediaQuery.of(context).size.width * 0.334,
                        child: CachedNetworkImage(
                            imageUrl:
                                "https://zoetalentsolutions.com/wp-content/uploads/2020/02/Construction-Delay-Analysis-Masterclass.jpg",
                            fit: BoxFit.cover),
                      ),
                      Align(
                          alignment: Alignment.lerp(
                              Alignment.bottomCenter, Alignment.center, 0.1),
                          child: Text("BASIC CONSTRUCTION COURSE",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.width * 0.33,
                  width: MediaQuery.of(context).size.width * 0.334,
                  padding: EdgeInsets.all(2),
                  child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width * 0.33,
                        width: MediaQuery.of(context).size.width * 0.334,
                        child: CachedNetworkImage(
                            imageUrl:
                                "https://d3njjcbhbojbot.cloudfront.net/api/utilities/v1/imageproxy/https://coursera-course-photos.s3.amazonaws.com/9a/c5bf40083111e7b41913604a2bbf73/Screen-Shot-2017-03-11-at-9.02.52-AM.png?auto=format%2Ccompress&dpr=1",
                            fit: BoxFit.cover),
                      ),
                      Align(
                          alignment: Alignment.lerp(
                              Alignment.bottomCenter, Alignment.center, 0.1),
                          child: Text("BASIC CREATIVE COURSE",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.width * 0.33,
                  width: MediaQuery.of(context).size.width * 0.332,
                  padding: EdgeInsets.all(2),
                  child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.width * 0.33,
                        width: MediaQuery.of(context).size.width * 0.332,
                        child: CachedNetworkImage(
                            imageUrl:
                                "https://www.training.com.au/wp-content/uploads/Automotive-courses-image-resized.jpg",
                            fit: BoxFit.cover),
                      ),
                      Align(
                          alignment: Alignment.lerp(
                              Alignment.bottomCenter, Alignment.center, 0.1),
                          child: Text("BASIC MECHANIC COURSE",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 60),
            Text("More Courses".toUpperCase(), style: TextStyle(fontSize: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                FlatButton(
                  onPressed: () {},
                  child: Text("View All", style: TextStyle(color: Colors.blue)),
                )
              ],
            ),
            // SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              child: Card(
                child: Row(
                  children: [
                    CachedNetworkImage(
                        imageUrl:
                            "https://www.telegraph.co.uk/content/dam/wellbeing/2016/07/08/102678778_dictionary-WELLBEING_trans_NvBQzQNjv4BqRbhc5V7kUtrB_UgV-vALC47PRSMmxwY_k-xuJYNqXBk.jpg",
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Basic English Course",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis),
                          SizedBox(height: 10),
                          Text("Duration: 4 Weeks"),
                        ],
                      ),
                    ),
                    Container(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              child: Card(
                child: Row(
                  children: [
                    CachedNetworkImage(
                        imageUrl:
                            "https://base.imgix.net/files/base/ebm/industryweek/image/2020/03/Assembly_Line.5e7a1db962670.png?auto=format&fit=max&w=1200",
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Factory Operations\nCourse",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis),
                          SizedBox(height: 10),
                          Text("Duration: 9 Weeks"),
                        ],
                      ),
                    ),
                    Container(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
