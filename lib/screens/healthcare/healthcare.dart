import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:provider/provider.dart';
import 'package:toggle_bar/toggle_bar.dart';

import '../../models/health/centers.dart';
import '../../models/health/vaccine_data.dart';
import '../../provider/healthcare_provider.dart';
import '../../provider/location_provider.dart';
import '../../theme/theme.dart';

class HealthCareScreen extends StatefulWidget {
  HealthCareScreen({Key key}) : super(key: key);
  static const routeName = "healthcare_screen";
  @override
  _HealthCareScreenState createState() => _HealthCareScreenState();
}

class _HealthCareScreenState extends State<HealthCareScreen> {
  bool _loading = true;
  bool _init = false;

  HealthCareProvider healthcareProvider;
  LocationProvider locationProvider;

  List<Centers> vaccinationCenters = [];

  PageController _pageController = new PageController();

  @override
  void didChangeDependencies() async {
    if (!_init) {
      healthcareProvider = Provider.of<HealthCareProvider>(context);
      locationProvider = Provider.of<LocationProvider>(context);
      String pincode = locationProvider.getPincode;
      VaccineData vaccineData =
          await healthcareProvider.getVaccinationSessions(pincode);
      vaccinationCenters = vaccineData.centers;
      setState(() {
        _init = true;
        _loading = false;
      });
    }
    super.didChangeDependencies();
  }

  showVaccinationDetails(Centers center) {
    showStickyFlexibleBottomSheet(
      minHeight: 0,
      initHeight: 0.75,
      maxHeight: 0.9,
      headerHeight: 20,
      context: context,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      headerBuilder: (BuildContext context, double offset) {
        return Container();
      },
      builder: (BuildContext context, double offset) {
        return SliverChildListDelegate(
          <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    center.centerId.toString(),
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  SizedBox(height: 10),
                  Text(center.name,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  Text(center.blockName +
                      ", " +
                      center.districtName +
                      ", " +
                      center.stateName),
                  Text(DateFormat('hh:mm a')
                          .format(DateTime.parse("2020-05-01 " + center.from)) +
                      "  -  " +
                      DateFormat('hh:mm a')
                          .format(DateTime.parse("2020-05-01 " + center.to))),
                  SizedBox(height: 10),
                  Text(center.feeType,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red)),
                ],
              ),
            ),
            SizedBox(height: 20),
            Divider(color: Colors.grey, height: 0.5),
            SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text("Vaccination Slots:",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey))),
            SizedBox(height: 20),
            for (int i = 0; i < center.sessions.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(center.sessions[i].date,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17)),
                        Text("")
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Name of the Vaccine:"),
                        Text(center.sessions[i].vaccine == ""
                            ? "Unspecified"
                            : center.sessions[i].vaccine),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Minimum Age Limit:"),
                        Text(center.sessions[i].minAgeLimit.toString()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Available Capacity:"),
                        Text(center.sessions[i].availableCapacity.toString()),
                      ],
                    ),
                    Row(children: [Text("Sessions:"), Text("")]),
                    for (int j = 0; j < center.sessions[i].slots.length; j++)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(""),
                          Text(center.sessions[i].slots[j]),
                        ],
                      ),
                    SizedBox(height: 40),
                  ],
                ),
              )
          ],
        );
      },
      anchors: [0, 0.5, 1],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("COVID-19")),
      body: Stack(
        children: [
          PageView(
            children: [
              !_loading
                  ? Padding(
                      padding:
                          const EdgeInsets.only(top: 70, left: 10, right: 10),
                      child: ListView.builder(
                          itemBuilder: (context, i) => ListTile(
                                title: Text(vaccinationCenters[i].name),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(vaccinationCenters[i].blockName +
                                        ", " +
                                        vaccinationCenters[i].districtName +
                                        ", " +
                                        vaccinationCenters[i].stateName),
                                    Text(DateFormat('hh:mm a').format(
                                            DateTime.parse("2020-05-01 " +
                                                vaccinationCenters[i].from)) +
                                        " - " +
                                        DateFormat('hh:mm a').format(
                                            DateTime.parse("2020-05-01 " +
                                                vaccinationCenters[i].to))),
                                    Text(vaccinationCenters[i].feeType),
                                  ],
                                ),
                                trailing: IconButton(
                                    icon: Icon(Icons.navigation),
                                    color: Colors.blue,
                                    onPressed: () {
                                      MapsLauncher.launchCoordinates(
                                          vaccinationCenters[i].lat.toDouble(),
                                          vaccinationCenters[i]
                                              .long
                                              .toDouble());
                                    }),
                                isThreeLine: true,
                                dense: true,
                                leading: Text(
                                  vaccinationCenters[i].centerId.toString(),
                                  style: TextStyle(color: Colors.grey),
                                ),
                                onTap: () {
                                  showVaccinationDetails(vaccinationCenters[i]);
                                },
                              ),
                          itemCount: vaccinationCenters.length,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics()),
                    )
                  : Center(child: CircularProgressIndicator()),
              Container(
                child: Text("2"),
              ),
            ],
            controller: _pageController,
            onPageChanged: (i) => _pageController.jumpToPage(i),
            physics: NeverScrollableScrollPhysics(),
          ),
          ToggleBar(
              labels: ["Vaccination", "Test Centers"],
              backgroundColor: Colors.grey.withOpacity(0.8),
              selectedTabColor: Themes.primaryColor,
              onSelectionUpdated: (index) => _pageController.jumpToPage(index)),
        ],
      ),
    );
  }
}
