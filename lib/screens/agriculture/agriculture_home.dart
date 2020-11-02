import 'package:flutter/material.dart';
import 'package:flutter_weather_bg/bg/weather_bg.dart';
import 'package:flutter_weather_bg/flutter_weather_bg.dart';
import 'package:smart_village/theme/theme.dart';

class AgricultureHome extends StatefulWidget {
  AgricultureHome({Key key}) : super(key: key);
  static const routeName = "agri_home";
  @override
  _AgricultureHomeState createState() => _AgricultureHomeState();
}

class _AgricultureHomeState extends State<AgricultureHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agriculture"),
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 20),
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
                                child: Icon(Icons.add),
                              ),
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
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Themes.primaryColor.withOpacity(0.1)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // SizedBox(width: 10),
                            AddedFarms(
                              farmName: "Wheat Farm",
                              farmImg:
                                  "https://lh3.googleusercontent.com/proxy/vjM--YsZ3INzTcTm5fP_L-eQVJaZbnxZWPKWnT2CLrTZiUJX4WP4KPelA99KLsiiKsZw_CIMGkoAlZgP1ffyFsEeXGQv8Ho",
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
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Container(height: 170, width: 70, color: Colors.blue),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: WeatherBg(
                    weatherType: WeatherType.thunder,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
              ),
            )
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
                child: Image.network(farmImg, color: Colors.white),
              ),
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
