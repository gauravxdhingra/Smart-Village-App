import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';

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

  geocoder() async {
    final placemarks = await geocoding.placemarkFromCoordinates(
        _locationData.latitude, _locationData.longitude);
    geocoding.Placemark placemark = placemarks.first;
    print(placemark.locality);
  }

  get locationDataGetter {
    return _locationData;
  }
}
