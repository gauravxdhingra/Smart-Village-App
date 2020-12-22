import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/bg/weather_bg.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:smart_village/provider/location_provider.dart';
import 'package:smart_village/screens/agriculture/agri_data.dart';
import 'package:smart_village/theme/theme.dart';
import 'package:weather/weather.dart';

class AgricultureHome extends StatefulWidget {
  AgricultureHome({Key key}) : super(key: key);
  static const routeName = "agri_home";
  @override
  _AgricultureHomeState createState() => _AgricultureHomeState();
}

class _AgricultureHomeState extends State<AgricultureHome> {
  bool _loading = true;
  bool _init = false;

  LocationProvider locationProvider;
  Weather weather;

  @override
  void didChangeDependencies() async {
    if (!_init) {
      locationProvider = Provider.of<LocationProvider>(context);
      LocationData _locationData = locationProvider.locationDataGetter ??
          await locationProvider.getLocation();
      weather = await locationProvider.getWeather(_locationData);
      setState(() {
        _loading = false;
        _init = true;
      });
    }
    super.didChangeDependencies();
  }

  List farmingProcess = AgriData.farmingProcess;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agriculture"),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverList(
                    delegate: SliverChildListDelegate([
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, top: 15),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Icon(Icons.add,
                                            color: Colors.white, size: 35)),
                                    radius: 30,
                                    backgroundColor: Colors.blueGrey,
                                  ),
                                  SizedBox(height: 5),
                                  Text("Add Farm"),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Themes.primaryColor.withOpacity(0.1)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    // SizedBox(width: 10),
                                    AddedFarms(
                                      farmName: "Wheat Farm",
                                      farmImg:
                                          "https://cdn3.iconfinder.com/data/icons/3-education-glyph-black/614/Wheat-512.png",
                                    ),
                                    AddedFarms(
                                      farmName: "Rice Farm",
                                      farmImg:
                                          "https://icons.iconarchive.com/icons/google/noto-emoji-animals-nature/1024/22333-sheaf-of-rice-icon.png",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Adding all your farms and tracking them regularly helps you become a Smart Farmer",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: WeatherWidget(weather: weather),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  ExpandablePanel(
                    header: Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: Text("Steps In Farming Process",
                          style: TextStyle(fontSize: 20)),
                    ),
                    // collapsed: Center(
                    //   child: Text(
                    //     "Key to Smart Farming Practices",
                    //     softWrap: true,
                    //     maxLines: 2,
                    //     overflow: TextOverflow.ellipsis,
                    //   ),
                    // ),
                    expanded: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          for (int i = 0; i < farmingProcess.length; i++)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                      imageUrl: farmingProcess[i]["imgUrl"],
                                      fit: BoxFit.cover),
                                ),
                                SizedBox(height: 10),
                                Text(farmingProcess[i]["step"],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                                for (int j = 0;
                                    j < farmingProcess[i]["point"].length;
                                    j++)
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text("${j + 1}. " +
                                        farmingProcess[i]["point"][j]),
                                  ),
                                SizedBox(height: 50)
                              ],
                            ),
                        ],
                      ),
                    ),
                    tapHeaderToExpand: true,
                    hasIcon: true,
                  ),
                  SizedBox(height: 100),
                ]))
              ],
            ),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 50,
        color: Colors.black.withOpacity(0.09),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Icon(Icons.call),
                SizedBox(width: 5),
                Text("Call Expert")
              ],
            ),
            Row(
              children: [
                Icon(Icons.message),
                SizedBox(width: 5),
                Text("Ask An Expert")
              ],
            )
          ],
        ),
      ),
    );
  }
}

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({
    Key key,
    this.weather,
  }) : super(key: key);

  final Weather weather;

  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  Weather weather;
  @override
  void initState() {
    weather = widget.weather;
    print(weather.weatherIcon);
    super.initState();
  }

  TextStyle textStyle =
      TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WeatherBg(
          weatherType: WeatherType.foggy,
          width: MediaQuery.of(context).size.width,
          height: 220,
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      weather.areaName,
                      style: textStyle,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                children: [
                  CachedNetworkImage(
                      imageUrl:
                          "http://openweathermap.org/img/wn/${weather.weatherIcon}.png",
                      fit: BoxFit.cover,
                      color: Colors.white),
                  Text(
                    weather.temperature.celsius.toStringAsFixed(1) + " °C",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "/ " + weather.weatherMain,
                    style: textStyle,
                  ),
                ],
              ),
              Text(
                "Feels like: " +
                    weather.tempFeelsLike.celsius.toStringAsFixed(1) +
                    " °C",
                style: textStyle,
              ),
              Text(
                "Max: " +
                    weather.tempMax.celsius.toStringAsFixed(1) +
                    " °C" +
                    " / " +
                    "Min: " +
                    weather.tempMin.celsius.toStringAsFixed(1) +
                    " °C",
                style: textStyle,
              ),
              Text(
                "Humidity: " + weather.humidity.toStringAsFixed(1) + "%",
                style: textStyle,
              ),
              Text(
                "Wind: " +
                    weather.windSpeed.toStringAsFixed(1) +
                    "m/s" +
                    " (" +
                    weather.windDegree.toString() +
                    "°)",
                style: textStyle,
              ),
              Text(
                "Cloudiness: " +
                    weather.cloudiness.toStringAsFixed(1) +
                    " / Rain(3 hrs): " +
                    weather.rainLast3Hours.toStringAsFixed(1),
                style: textStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AddedFarms extends StatelessWidget {
  const AddedFarms({
    Key key,
    this.farmName,
    this.farmImg,
  }) : super(key: key);

  final String farmName;
  final String farmImg;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        child: Column(
          children: [
            CircleAvatar(
              child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: CachedNetworkImage(
                      imageUrl: farmImg, color: Colors.white)),
              radius: 30,
              backgroundColor: Colors.blueGrey,
            ),
            SizedBox(height: 5),
            Text(farmName),
          ],
        ),
      ),
    );
  }
}
