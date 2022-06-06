/// flutter => 3.0.1 
/// packages
///  connectivity_plus: ^2.3.2
///  internet_connection_checker: ^0.0.1+4
///  open_settings: ^2.0.2
///  airplane_mode_checker: ^1.0.2
import 'dart:async';

import 'package:airplane_mode_checker/airplane_mode_checker.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:open_settings/open_settings.dart';

class ConnectivityProvider extends ChangeNotifier {
  ConnectivityResult? _connectivityType;
  InternetConnectionStatus? _internetConnectionStatus;

  /// Used to get connection status at any point of time [none],[mobile], [wifi]
  /// [none] => not connect to [mobile], [wifi] not depended in internet
  ConnectivityResult? get connectivityType => _connectivityType;

  /// Used to get internet status at any point of time [connected],[disconnected]
  InternetConnectionStatus? get internetConnectionStatus =>
      _internetConnectionStatus;

  final Connectivity _connectivity = Connectivity();
  final InternetConnectionChecker _internet = InternetConnectionChecker();

  /// Context for the main screen that holds all screens
  static GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  /// Context for pop Connectivity Dialog
  BuildContext? _connectivityDialogContext;

  bool firstTimeOpeningApp = true;
  bool isDialogOpen = false;

  void initialize() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _internet.onStatusChange.listen(_updateInternetStatus);
      _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    } on PlatformException catch (e) {
      debugPrint(
          'Platform does not support queries about status :${e.message}');
      return;
    }
  }

  Future<void> _updateInternetStatus(InternetConnectionStatus status) async {
    _internetConnectionStatus = status;
    print(status);
    if ((await AirplaneModeChecker.checkAirplaneMode() ==
            AirplaneModeStatus.on) &&
        !isDialogOpen) {
      showAirPlaneDialog();
    } else if (status == InternetConnectionStatus.connected) {
      if (firstTimeOpeningApp) {
        firstTimeOpeningApp = false;
      } else {
        showSnackBar(online: true);
      }
    } else {
      showSnackBar(online: false);
    }
    notifyListeners();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectivityType = result;
    print(result);
    if ((await AirplaneModeChecker.checkAirplaneMode() ==
            AirplaneModeStatus.on) &&
        !isDialogOpen &&
        result == ConnectivityResult.none) {
      showAirPlaneDialog();
    } else if (result == ConnectivityResult.none && !isDialogOpen) {
      showConnectivityDialog();
    } else {
      if (_connectivityDialogContext != null && isDialogOpen) {
        Navigator.of(_connectivityDialogContext!).pop();
        isDialogOpen = false;
      }
    }
    notifyListeners();
  }

  void showSnackBar({required bool online}) {
    if (key.currentContext == null) return;
    ScaffoldMessenger.of(key.currentContext!).hideCurrentSnackBar();
    ScaffoldMessenger.of(key.currentContext!).showSnackBar(SnackBar(
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
                _updateInternetStatus(await _internet.connectionStatus);
              },
            )
          : null,
    ));
  }

  void showConnectivityDialog() {
    if (key.currentContext == null) return;
    showDialog(
        context: key.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          _connectivityDialogContext = context;
          return AlertDialog(
            title: const Text("Connection Disabled"),
            content: const Text("Please enable your Wifi or Mobile Data"),
            actions: [
              TextButton(
                child: const Text("Wifi"),
                onPressed: () {
                  OpenSettings.openWIFISetting();
                },
              ),
              TextButton(
                child: const Text("Mobile Data"),
                onPressed: () {
                  OpenSettings.openDataUsageSetting();
                },
              )
            ],
          );
        });
    isDialogOpen = true;
  }

  void showAirPlaneDialog() {
    if (key.currentContext == null) return;
    showDialog(
        context: key.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          _connectivityDialogContext = context;
          return AlertDialog(
            title: const Text("Connection Disabled"),
            content: const Text("Please Disable AirPlane"),
            actions: [
              TextButton(
                child: const Text("Disable Airplane"),
                onPressed: () {
                  OpenSettings.openAirplaneModeSetting();
                },
              ),
            ],
          );
        });
    isDialogOpen = true;
  }
}
