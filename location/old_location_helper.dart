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
      if (permissionGranted == PermissionStatus.deniedForever) {
        _showPermissionDialog();
        return false;
      } else if (permissionGranted != PermissionStatus.granted) {
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

  // Check if location service is enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await location.serviceEnabled();
  }

  // Request location service
  static Future<bool> requestLocationService() async {
    return await location.requestService();
  }

  // Check location permission status
  static Future<PermissionStatus> checkLocationPermission() async {
    return await location.hasPermission();
  }

  // Request location permission
  static Future<PermissionStatus> requestLocationPermission() async {
    return await location.requestPermission();
  }

  /// Retrieves address information from coordinates.
  static Future<List<geo.Placemark>> getFullPlaceAddress({
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

  // Reverse geocode to get address from coordinates
  static Future<String> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) async {
    List<geo.Placemark> placemarks =
        await geo.placemarkFromCoordinates(latitude, longitude);
    if (placemarks.isNotEmpty) {
      geo.Placemark place = placemarks[0];
      return '${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
    }
    return 'No address available';
  }

  // Show permission dialog
  static void _showPermissionDialog() {
    showDialog(
      context: RouteConfigurations.parentNavigatorKey.currentState!.context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Needed'),
          content: const Text(
            'This app needs location permission to function properly.\nPlease grant the permission.',
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                context.pop();
              },
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                context.pop();
                AppSettings.openAppSettings(type: AppSettingsType.location);
              },
            ),
          ],
        );
      },
    );
  }
}
