import 'dart:async';

import 'package:airplane_mode_checker/airplane_mode_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mobile_developer_test/config/routes/routes.dart';
import 'package:open_settings_plus/open_settings_plus.dart';

class ConnectivityChecker {
  factory ConnectivityChecker() => _instance;
  ConnectivityChecker._internal();
  static final ConnectivityChecker _instance = ConnectivityChecker._internal();
  static ConnectivityChecker get instance => _instance;

  /// Context for the main screen that holds all screens
  // static GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
  static final key = RouteConfigurations.parentNavigatorKey;

  /// Context for pop Connectivity Dialog
  BuildContext? _connectivityDialogContext;

  bool firstTimeOpeningApp = true;
  bool isDialogOpen = false;

  void initialize() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      /// Used to get internet status at any point of time [connected],[disconnected]
      InternetConnection().onStatusChange.listen(_updateInternetStatus);

      /// Used to get connection status at any point of time [none],[mobile], [wifi]
      /// [none] => not connect to [mobile], [wifi] not depended in internet
      Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
    } on PlatformException catch (e) {
      debugPrint(
          'Platform does not support queries about status :${e.message}');
      return;
    }
  }

  Future<void> _updateInternetStatus(InternetStatus status) async {
    print("InternetStatus: $status");
    switch (status) {
      case InternetStatus.connected:
        closeSnackBarDialogs();
        if (firstTimeOpeningApp) {
          firstTimeOpeningApp = false;
        } else {
          showSnackBar(online: true);
        }
        break;
      case InternetStatus.disconnected:
        await Future.delayed(const Duration(seconds: 7));
        status = await InternetConnection().internetStatus;
        if (!isDialogOpen && status == InternetStatus.disconnected) {
          showSnackBar(online: false);
          await showConnectivityDialog();
        }
        break;
      default:
        showSnackBar(online: false);
    }
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    print("ConnectionStatus: ${result.last}");
    if (result.contains(ConnectivityResult.none) && !isDialogOpen) {
      await showConnectivityDialog();
    } else {
      closeSnackBarDialogs();
    }
  }

  void closeSnackBarDialogs() {
    ScaffoldMessenger.of(key.currentContext!).hideCurrentSnackBar();
    if (_connectivityDialogContext != null && isDialogOpen) {
      // _connectivityDialogContext!.pop();
      Navigator.of(_connectivityDialogContext!).pop();
      isDialogOpen = false;
    }
  }

  Future<void> showConnectivityDialog() async {
    if (key.currentContext == null) return;
    final airplaneModeStatus =
        await AirplaneModeChecker.instance.checkAirplaneMode();
    await showDialog(
        context: key.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          isDialogOpen = true;
          _connectivityDialogContext = context;
          return AlertDialog(
            title: const Text("Connection Disabled"),
            content: const Text("Please enable your Wifi or Mobile Data"),
            actions: [
              TextButton(
                child: const Text("Wifi"),
                onPressed: () {
                  switch (OpenSettingsPlus.shared) {
                    case OpenSettingsPlusAndroid settings:
                      settings.wifi();
                    case OpenSettingsPlusIOS settings:
                      settings.wifi();
                    default:
                      throw Exception('Platform not supported');
                  }
                },
              ),
              TextButton(
                child: const Text("Mobile Data"),
                onPressed: () {
                  switch (OpenSettingsPlus.shared) {
                    case OpenSettingsPlusAndroid settings:
                      settings.dataUsage();
                    case OpenSettingsPlusIOS settings:
                      settings.cellular();
                    default:
                      throw Exception('Platform not supported');
                  }
                },
              ),
              if (airplaneModeStatus == AirplaneModeStatus.on)
                TextButton(
                  child: const Text("Disable Airplane"),
                  onPressed: () {
                    switch (OpenSettingsPlus.shared) {
                      case OpenSettingsPlusAndroid settings:
                        settings.airplaneMode();
                      case OpenSettingsPlusIOS settings:
                        settings.cellular();
                      default:
                        throw Exception('Platform not supported');
                    }
                  },
                ),
            ],
          );
        });
  }

  void showSnackBar({required bool online}) {
    if (key.currentContext == null) return;
    ScaffoldMessenger.of(key.currentContext!).hideCurrentSnackBar;
    ScaffoldMessenger.of(key.currentContext!).showSnackBar(
      SnackBar(
        content: Text(
          online ? "Back online" : "You ara offline",
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: online ? Colors.green : Colors.redAccent,
        duration:
            (!online) ? const Duration(days: 365) : const Duration(seconds: 4),
        action: (!online)
            ? SnackBarAction(
                label: "Try again",
                onPressed: () async {
                  ScaffoldMessenger.of(key.currentContext!).hideCurrentSnackBar;
                  _updateInternetStatus(
                      await InternetConnection().internetStatus);
                  _updateConnectionStatus(
                      await Connectivity().checkConnectivity());
                },
              )
            : null,
      ),
    );
  }
}
