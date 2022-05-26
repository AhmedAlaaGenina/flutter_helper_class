/// packages
///  connectivity_plus: ^2.2.0
///  internet_connection_checker: ^0.0.1+3
///  open_settings: ^2.0.2
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:open_settings/open_settings.dart';

class ConnectivityProvider extends ChangeNotifier {
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  InternetConnectionStatus _internetConnectionStatus =
      InternetConnectionStatus.disconnected;

  /// Context for the main screen that holds all screens
  static GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  BuildContext? _connectivityDialogContext;

  bool firstTimeOpeningApp = true;
  final Connectivity _connectivity = Connectivity();
  final InternetConnectionChecker _internetConnectionChecker =
      InternetConnectionChecker();

  /// Used to get connection status at any point of time [none],[mobile], [wifi]
  ConnectivityResult get connectivityResult => _connectivityResult;

  /// Used to get internet status at any point of time [connected],[disconnected]
  InternetConnectionStatus get internetConnectionStatus =>
      _internetConnectionStatus;

  /// start point of class and call with provider
  void initialize() async {
    _internetConnectionChecker.checkInterval = const Duration(seconds: 2);
    await initConnectivity();
    if (_internetConnectionStatus == InternetConnectionStatus.disconnected)
      await listenToConnectionStatus();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _internetConnectionStatus = await _internetConnectionChecker.hasConnection
          ? InternetConnectionStatus.connected
          : InternetConnectionStatus.disconnected;
    } on PlatformException catch (e) {
      debugPrint(
          'Platform does not support queries about status :${e.message}');
      return;
    }
  }

  Future<void> listenToConnectionStatus() async {
    /// open stream to listen on change connectivity Status [connected],[disconnected]
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    /// open stream to listen on change in Internet Connection Status [none],[mobile], [wifi]
    _internetConnectionChecker.onStatusChange.listen(_updateInternetStatus);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectivityResult = result;
    if (result == ConnectivityResult.none) {
      showConnectivityDialog();
    } else {
      if (_connectivityDialogContext != null) {
        Navigator.of(_connectivityDialogContext!).pop();
      }
    }
    notifyListeners();
  }

  Future<void> _updateInternetStatus(InternetConnectionStatus status) async {
    _internetConnectionStatus = status;
    print(status);
    if (status == InternetConnectionStatus.connected) {
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

  void showSnackBar({required bool online}) {
    if (key.currentContext == null) return;
    ScaffoldMessenger.of(key.currentContext!).hideCurrentSnackBar();
    ScaffoldMessenger.of(key.currentContext!).showSnackBar(
      SnackBar(
        content: Text(
          online
              ? AppLocalizations.of(key.currentContext!)!.backOnline
              : AppLocalizations.of(key.currentContext!)!.youAraOffline,
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: online ? Colors.green : Colors.redAccent,
        duration:
            (!online) ? const Duration(days: 365) : const Duration(seconds: 4),
        action: (!online)
            ? SnackBarAction(
                label: AppLocalizations.of(key.currentContext!)!.tryAgain,
                onPressed: () async {
                  _updateInternetStatus(
                      await _internetConnectionChecker.connectionStatus);
                },
              )
            : null,
      ),
    );
  }

  void showConnectivityDialog() {
    if (key.currentContext == null) return;
    showDialog(
        context: key.currentContext!,
        barrierDismissible: false,
        builder: (context) {
          _connectivityDialogContext = context;
          return AlertDialog(
            title: Text(
                AppLocalizations.of(key.currentContext!)!.connectionDisabled,
                style: Theme.of(key.currentContext!).textTheme.bodyText1),
            content: Text(
                AppLocalizations.of(key.currentContext!)!
                    .pleaseEnableYourWifiOrMobileData,
                style: Theme.of(key.currentContext!).textTheme.bodyText1),
            actions: [
              TextButton(
                child: Text(AppLocalizations.of(key.currentContext!)!.wifi),
                onPressed: () {
                  OpenSettings.openWIFISetting();
                },
              ),
              TextButton(
                child:
                    Text(AppLocalizations.of(key.currentContext!)!.mobileData),
                onPressed: () {
                  OpenSettings.openDataUsageSetting();
                },
              )
            ],
          );
        });
  }
}
