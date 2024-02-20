import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fashion/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

// const GOOGLE_API_KEY = 'AIzaSyCvrYkbhs9PAMtEAaTwnXrFtQaBz-GS60Q';
const GOOGLE_API_KEY = 'AIzaSyBT30Wp2jPm5sw9DrP9qTge8SZgBsAO_wI';

class LocationHelper {
  static Future<LocationData?> getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
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

  static Future<Marker> generateLocationMarkerPreview({
    required double latitude,
    required double longitude,
  }) async {
    final Uint8List customMarker = await getBytesFromAsset(
      path: Assets.images.marker.path,
      width: 72,
    );
    return Marker(
      markerId: const MarkerId('Marker'),
      position: LatLng(latitude, longitude),
      icon: BitmapDescriptor.fromBytes(customMarker),
    );
  }

  // set custom marker with width
  static Future<Uint8List> getBytesFromAsset({
    required String path,
    required int width,
  }) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  // set custom marker without width
  BitmapDescriptor setCustomMarkerIcon(String path) {
    BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;

    BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, path)
        .then((icon) => sourceIcon = icon);

    return sourceIcon;
  }

  static Future<List<geo.Placemark>> getPlaceAddress({
    required double latitude,
    required double longitude,
  }) async {
    List<geo.Placemark> placeMarks =
        await geo.placemarkFromCoordinates(latitude, longitude);
    return placeMarks;
  }

  static Future<List<geo.Location>> getLocationAddress({
    required String address,
  }) async {
    List<geo.Location> locations = await geo.locationFromAddress(address);
    return locations;
  }
}
