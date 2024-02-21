import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';

// const GOOGLE_API_KEY = 'AIzaSyCvrYkbhs9PAMtEAaTwnXrFtQaBz-GS60Q';
const GOOGLE_API_KEY = 'AIzaSyBT30Wp2jPm5sw9DrP9qTge8SZgBsAO_wI';

class LocationHelper {
  LocationHelper._();

  static Location location = Location();

  static const double _distanceFilter = 1; // in meters
  static const int _updateInterval = 10; // in seconds

  /// Checks and requests location permissions if needed.
  static Future<bool> checkLocationPermission() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return false;
      }
    }
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  /// Retrieves the current device location.
  static Future<LocationData?> getCurrentLocation() async {
    bool havePermission = await checkLocationPermission();
    if (!havePermission) return null;
    return await location.getLocation();
  }

  /// Starts listening for location updates.
  static Future<void> startListeningLocationChanged(
      ValueChanged<LocationData> onChangeLocation) async {
    bool havePermission = await checkLocationPermission();
    if (!havePermission) return;
    location.enableBackgroundMode(enable: true);
    location.changeSettings(
        interval: _updateInterval, distanceFilter: _distanceFilter);
    location.onLocationChanged.listen(onChangeLocation);
  }

  /// Stops listening for location updates.
  static Future<void> stopListeningLocation() async {
    await location.enableBackgroundMode(enable: false);
  }

  /// Retrieves address information from coordinates.
  static Future<List<geo.Placemark>> getPlaceAddress({
    required double latitude,
    required double longitude,
  }) async {
    return await geo.placemarkFromCoordinates(latitude, longitude);
  }

  /// Retrieves coordinates from an address string.
  static Future<List<geo.Location>> getLocationAddress({
    required String address,
  }) async {
    return await geo.locationFromAddress(address);
  }
}
