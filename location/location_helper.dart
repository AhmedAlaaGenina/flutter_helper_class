import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

const GOOGLE_API_KEY = 'AIzaSyBT30Wp2jPm5sw9DrP9qTge8SZgBsAO_wI';

class LocationHelper {
  static Future<LocationData?> getCurrentLocation() async {
    Location location = Location();
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

    return await location.getLocation();
  }

  static CameraPosition generateLocationImagePreview({
    required double latitude,
    required double longitude,
  }) {
    return CameraPosition(
      target: LatLng(latitude, longitude),
      zoom: 16,
    );
  }

  static Marker generateLocationMarkerPreview({
    required double latitude,
    required double longitude,
  }) {
    return Marker(
      markerId: const MarkerId('Marker'),
      position: LatLng(latitude, longitude),
    );
  }

  static Future<List<geo.Placemark>> getPlaceAddress({
    required double latitude,
    required double longitude,
  }) async {
    List<geo.Placemark> placeMarks =
        await geo.placemarkFromCoordinates(latitude, longitude);
    return placeMarks;
  }
}
