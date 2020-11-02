import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_village/screens/agriculture/agriculture_home.dart';
import 'package:smart_village/screens/courses/courses_home.dart';
import 'package:smart_village/screens/jobs/jobs_home.dart';
import 'package:smart_village/theme/theme.dart';

class Homepage extends StatefulWidget {
  Homepage({Key key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List homeTabItems = [];

  @override
  void didChangeDependencies() {
    homeTabItems = [
      {
        "title": "Agriculture",
        "imgUrl":
            "https://cdn2.iconfinder.com/data/icons/food-solid-icons-volume-2/128/054-512.png",
        "onPress": () {
          Navigator.pushNamed(context, AgricultureHome.routeName);
        },
      },
      {
        "title": "Jobs",
        "imgUrl":
            "https://cdn2.iconfinder.com/data/icons/people-icons-5/100/m-20-512.png",
        "onPress": () {
          Navigator.pushNamed(context, JobsHome.routeName);
        },
      },
      {
        "title": "Courses",
        "imgUrl":
            "https://i.pinimg.com/originals/ec/ff/cc/ecffccbdfb3381f5edf994d45913f737.png",
        "onPress": () {
          Navigator.pushNamed(context, CoursesHome.routeName);
        },
      },
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            // title: Text(headline),
            // elevation: 0.1,
            expandedHeight: MediaQuery.of(context).size.height / 3,

            pinned: true,
            // backgroundColor: Colors.white,
            // leading: IconButton(
            //   icon: Icon(
            //     Icons.arrow_back_ios,
            //     color: Colors.white,
            //   ),
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            // ),
            // floating: true,
            title: Container(
              height: 40,
              width: double.infinity,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
              // title: Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(3),
              //     color: Colors.black38,
              //   ),
              //   padding: EdgeInsets.symmetric(
              //     vertical: 3,
              //     horizontal: 6,
              //   ),
              //   child: Text(
              //     "Atmanirbhar Gaon".toUpperCase(),
              //     style: TextStyle(
              //       fontSize: 15,
              //     ),
              //     maxLines: 2,
              //     overflow: TextOverflow.ellipsis,
              //     softWrap: true,
              //     textAlign: TextAlign.center,
              //   ),
              // ),
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
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.0))),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: 2 / 2.6),
                delegate:
                    SliverChildBuilderDelegate((BuildContext context, int i) {
                  return HomeTabs(
                    title: homeTabItems[i]["title"],
                    imgUrl: homeTabItems[i]["imgUrl"],
                    onPress: homeTabItems[i]["onPress"],
                  );
                }, childCount: 3)),
          )
        ],
      ),
    );
  }
}

class HomeTabs extends StatelessWidget {
  const HomeTabs({
    Key key,
    this.title,
    this.imgUrl,
    this.onPress,
  }) : super(key: key);
  final String title;
  final String imgUrl;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Card(
        child: InkWell(
          onTap: onPress,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(imgUrl,
                  fit: BoxFit.contain, color: Colors.blueGrey),
              Text(title),
              Text("")
            ],
          ),
        ),
      ),
    );
  }
}
