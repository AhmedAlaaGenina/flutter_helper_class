import 'dart:async';
import 'dart:developer';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shorebird_location/file_manager.dart';

// this class handles the location tracking in background
class LocationService {
  // Private constructor to prevent instantiation and enforce singleton pattern.
  LocationService._();

  static const String _isolateName = 'LocationIsolate';
  static final ReceivePort _receivePort = ReceivePort();
  static bool _isRunning = false;
  static LocationDto? _lastLocation;

  /// Initialize the location tracking service and setup port for communication with Isolate.
  static void initialize() {
    // Clear any previous port mappings to avoid conflicts.
    if (IsolateNameServer.lookupPortByName(_isolateName) != null) {
      IsolateNameServer.removePortNameMapping(_isolateName);
    }

    IsolateNameServer.registerPortWithName(_receivePort.sendPort, _isolateName);

    _receivePort.listen(_handleLocationUpdate);
    _initializeService();
  }

  /// Initializes the platform-specific background locator.
  static Future<void> _initializeService() async {
    log('Initializing location service...');
    await BackgroundLocator.initialize();
    log('Location service initialized.');

    _isRunning = await BackgroundLocator.isServiceRunning();
    log('Service running: $_isRunning');
  }

  /// Handles incoming location updates from the Isolate.
  static Future<void> _handleLocationUpdate(dynamic data) async {
    final locationDto = data != null ? LocationDto.fromJson(data) : null;

    if (locationDto != null) {
      await _updateNotification(locationDto);
      _lastLocation = locationDto;
      await FileManager.writeToLogFile(
          '------------\n${DateTime.now()}\n------------\n');
      await FileManager.writeToLogFile({'Location': _lastLocation}.toString());
    }

    log('_handleLocationUpdate: Received location: $locationDto');
  }

  /// Updates the notification with the current location data.
  static Future<void> _updateNotification(LocationDto location) async {
    await BackgroundLocator.updateNotificationText(
      title: "Location Update",
      msg: "Location received at ${DateTime.now()}",
      bigMsg: "Coordinates: ${location.latitude}, ${location.longitude}",
    );
  }

  /// Starts listening for location updates after checking permissions.
  static void startTracking() async {
    if (await _requestLocationPermission()) {
      await _registerLocationUpdates();
      _isRunning = await BackgroundLocator.isServiceRunning();
      _lastLocation = null;
    } else {
      log('Location permission denied.');
    }
  }

  /// Requests necessary location permissions from the user.
  static Future<bool> _requestLocationPermission() async {
    PermissionStatus status = await Permission.locationAlways.status;
    if (status.isGranted) return true;

    status = await Permission.locationAlways.request();

    if (status.isDenied || status.isPermanentlyDenied || !status.isGranted) {
      log('Location permission permanently denied.');
      // Optionally open app settings or handle further in-app prompts.
      return false;
    }

    return true;
  }

  /// Registers the location updates based on platform-specific settings.
  static Future<void> _registerLocationUpdates() async {
    await BackgroundLocator.registerLocationUpdate(
      LocationCallbackHandler.handleLocation,
      initCallback: LocationCallbackHandler.initCallback,
      initDataCallback: {},
      iosSettings: const IOSSettings(
        distanceFilter: 15,
        accuracy: LocationAccuracy.HIGH,
        showsBackgroundLocationIndicator: true,
      ),
      androidSettings: const AndroidSettings(
        interval: 5,
        distanceFilter: 0,
        client: LocationClient.google,
        androidNotificationSettings: AndroidNotificationSettings(
          notificationChannelName: 'Location Tracking',
          notificationTitle: 'Tracking Location',
          notificationMsg: 'Location tracking is active in the background.',
          notificationBigMsg:
              'This is required to keep features functional while the app is in the background.',
          notificationIconColor: Colors.grey,
          notificationTapCallback: LocationCallbackHandler.onNotificationTap,
        ),
      ),
    );
  }

  /// Stops the location tracking service and un registers the Isolate.
  static Future<void> stopTracking() async {
    IsolateNameServer.removePortNameMapping(_isolateName);
    await BackgroundLocator.unRegisterLocationUpdate();
    _isRunning = await BackgroundLocator.isServiceRunning();
    log('Location tracking stopped.');
  }
}

@pragma('vm:entry-point')
class LocationCallbackHandler {
  static const String _isolateName = 'LocationIsolate';

  /// Handles incoming location data and updates the UI or logic.
  @pragma('vm:entry-point')
  static Future<void> handleLocation(LocationDto locationDto) async {
    final SendPort sendPort = IsolateNameServer.lookupPortByName(_isolateName)!;
    sendPort.send(locationDto.toJson());
    log('Location callback executed.');
  }

  // Optional callbacks for initialization, disposal, and notification interaction.
  @pragma('vm:entry-point')
  static Future<void> initCallback(Map<dynamic, dynamic> params) async {
    log('Location tracking service initialized.');
  }

  @pragma('vm:entry-point')
  static Future<void> disposeCallback() async {
    log('Location tracking service disposed.');
  }

  @pragma('vm:entry-point')
  static Future<void> onNotificationTap() async {
    log('Notification clicked by the user.');
  }
}
