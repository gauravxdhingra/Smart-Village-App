import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';
import 'package:weather/weather.dart';

class LocationProvider with ChangeNotifier {
  Location location = new Location();
  LocationData _locationData;

  Future<LocationData> getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  Future<String> geocoder(LocationData _locationDataa) async {
    final placemarks = await geocoding.placemarkFromCoordinates(
        _locationDataa.latitude, _locationDataa.longitude);
    geocoding.Placemark placemark = placemarks.first;
    print(placemark.subLocality + ", " + placemark.subAdministrativeArea);
    return placemark.subLocality + ", " + placemark.subAdministrativeArea;
  }

  Future<Weather> getWeather(LocationData _locationDataa) async {
    // 68cb03985d06f7afdf42838b85203879
    WeatherFactory wf = new WeatherFactory("68cb03985d06f7afdf42838b85203879");
    Weather w = await wf.currentWeatherByLocation(
        _locationDataa.latitude, _locationDataa.longitude);
    return w;
  }

  get locationDataGetter {
    return _locationData;
  }
}
