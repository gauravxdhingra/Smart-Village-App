import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:smart_village/provider/location_provider.dart';
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
  bool _loading = true;
  bool _init = false;

  LocationProvider locationProvider;

  List homeTabItems = [];
  LocationData _locationData;
  String address = "";
  @override
  void didChangeDependencies() async {
    if (!_init) {
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
      locationProvider = Provider.of<LocationProvider>(context);
      _locationData = await locationProvider.getLocation();
      address = await locationProvider.geocoder(_locationData);

      setState(() {
        _init = true;
        _loading = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            // elevation: 0.1,
            expandedHeight: MediaQuery.of(context).size.height / 3,
            pinned: true,
            backgroundColor: Themes.primaryColor,
            // floating: true,
            leading: InkWell(
                onTap: () async {
                  locationProvider.geocoder(_locationData);
                },
                child: Icon(Icons.location_on_outlined)),
            title: Text(_loading ? "Get Location" : address),

            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              centerTitle: true,
              collapseMode: CollapseMode.pin,
              // title: Container(
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       Icon(Icons.location_city),
              //       Text("Delhi"),
              //     ],
              //   ),
              // ),
              background: Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                        "https://i.pinimg.com/564x/39/03/fe/3903fe18c342c0a1ed83917e283d1314.jpg"),
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
              //   background: Container(
              //       height: 200,
              //       width: double.infinity,
              //       color: Themes.primaryColor),
            ),
            stretch: true,
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
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: 400, width: 100),
          ),
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
              CachedNetworkImage(
                  imageUrl: imgUrl,
                  fit: BoxFit.contain,
                  color: Colors.blueGrey),
              Text(title),
              Text("")
            ],
          ),
        ),
      ),
    );
  }
}
