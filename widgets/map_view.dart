import 'dart:async';

import 'package:fashion/core/helpers/helpers.dart';
import 'package:fashion/core/widgets/widgets.dart';
import 'package:fashion/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapView extends StatefulWidget {
  final LatLng? initialLocation;

  const MapView({
    super.key,
    this.initialLocation,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  CameraPosition? _initialCameraPosition;
  LocationData? _locationData;
  LatLng? _pickedLocations;
  String? _mapStyle;
  @override
  void initState() {
    super.initState();
    rootBundle.loadString(Assets.json.mapStyle).then((string) {
      _mapStyle = string;
    });
    initLocation();
  }

  Future<void> initLocation() async {
    if (widget.initialLocation != null) {
      await initMap(
        latitude: widget.initialLocation!.latitude,
        longitude: widget.initialLocation!.longitude,
      );
    } else {
      _locationData = await LocationHelper.getCurrentLocation();
      if (_locationData == null) return;
      await initMap(
        latitude: _locationData!.latitude!,
        longitude: _locationData!.longitude!,
      );
    }
  }

  Future<void> initMap({
    required double latitude,
    required double longitude,
  }) async {
    setState(() {
      _initialCameraPosition = LocationHelper.generateLocationImagePreview(
        latitude: latitude,
        longitude: longitude,
      );
    });
  }

  Future<void> _selectLocation(LatLng position) async {
    setState(() {
      _pickedLocations = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: _initialCameraPosition == null
            ? const Center(child: CircularProgressIndicator.adaptive())
            : Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: _initialCameraPosition!,
                    style: _mapStyle,
                    onMapCreated: (GoogleMapController controller) {
                      if (!_controller.isCompleted) {
                        _controller.complete(controller);
                      }
                    },
                    onCameraMove: (position) async {
                      await _selectLocation(position.target);
                    },
                    zoomControlsEnabled: false,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 48.h),
                      child: Assets.icons.marker.svg(),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 38.h, horizontal: 16.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomTextFormField(
                          controller: TextEditingController(),
                          hintText: 'Search Places..',
                          height: 49.h,
                          isCollapsed: true,
                          hintFontSize: 20.sp,
                          hintFontWeight: FontWeight.w500,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 12.w),
                          onChange: (value) {},
                          suffix: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Assets.icons.search.svg(),
                          ),
                          haveShadow: true,
                          backgroundColor: Colors.white,
                          radius: 6.r,
                          borderColor: Colors.white,
                        ),
                        CustomButtonText(
                          title: 'Select location',
                          width: double.infinity,
                          radius: 6.r,
                          height: 54.h,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w800,
                          onPressed: _pickedLocations == null
                              ? null
                              : () =>
                                  Navigator.of(context).pop(_pickedLocations),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
