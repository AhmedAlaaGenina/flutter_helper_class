import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';
import 'package:sanad_rewards/main.dart';
import 'package:sanad_rewards/utils/helpers/print/print.dart';

// How to use this class?

// 1. Initialization
// Call `ConnectivityChecker.instance.initialize()` in your main function or app initialization code.
// in MyApp or your main widget, use `ConnectivityChecker.instance.dispose()` in the dispose method.
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }
//   @override
//   void dispose() {
//     ConnectivityChecker.instance.dispose();
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       navigatorKey: navigatorKey, // Make sure this is defined in main.dart
//       home: HomeScreen(),
//       // rest of your app configuration
//     );
//   }
// }

/// Context for the main screen that holds all screens
// static GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
// static final key = RouteConfigurations.parentNavigatorKey;

// =========================================>

/// 2. Basic Connectivity Checking
// Check current connection status
// Future<void> someFunction() async {
//   bool isOnline = await ConnectivityChecker.instance.isConnected();
//   if (isOnline) {
//     // Proceed with online operations
//   } else {
//     // Handle offline state
//   }
// }

// Check if connected to a network (WiFi/cellular)
// Future<void> checkNetworkAvailability() async {
//   bool hasNetwork = await ConnectivityChecker.instance.isNetworkAvailable();
//   if (hasNetwork) {
//     // Connected to WiFi or cellular, but might not have internet
//   } else {
//     // No network connection at all
//   }
// }

// =========================================>

/// 3. Manual Connection Testing
// Manually check connection with UI updates
// ElevatedButton(
//   onPressed: () async {
//     bool isConnected = await ConnectivityChecker.instance.checkConnection();
//     if (isConnected) {
//       print("Connected to the internet");
//     } else {
//       print("No internet connection");
//     }
//   },
//   child: Text("Check Connection"),
// )

// Check connection without UI updates
// Future<void> silentConnectionCheck() async {
//   bool isConnected = await ConnectivityChecker.instance.checkConnection(
//     updateUI: false,
//   );
//   // Do something with the result without showing snackbars/dialogs
// }

// =========================================>

/// 4. Manual Dialog Display
// Force show connectivity dialog
// ElevatedButton(
//   onPressed: () {
//     ConnectivityChecker.instance.forceShowConnectivityDialog();
//   },
//   child: Text("Network Settings"),
// )

// =========================================>

/// 5. Listening to Connectivity Changes
// Register a callback to be notified of changes
// @override
// void initState() {
//   super.initState();
//   // Set up connectivity change listener
//   ConnectivityChecker.instance.onConnectivityChanged = (isConnected) {
//     setState(() {
//       _isOnline = isConnected;
//     });

//     if (isConnected) {
//       // Refresh data or perform actions when coming online
//       refreshData();
//     } else {
//       // Handle offline state
//       showOfflineMessage();
//     }
//   };
// }

// @override
// void dispose() {
//   // Remove listener when widget is disposed
//   ConnectivityChecker.instance.onConnectivityChanged = null;
//   super.dispose();
// }

// =========================================>

/// 6. Handling API Calls with Connectivity
// Wrapper for API calls with connectivity check
// Future<dynamic> safeApiCall(Future<dynamic> Function() apiCall) async {
//   if (await ConnectivityChecker.instance.isConnected()) {
//     try {
//       return await apiCall();
//     } catch (e) {
//       // Handle API error
//       return null;
//     }
//   } else {
//     // Handle offline state
//     return null;
//   }
// }

// // Usage
// Future<void> fetchUserData() async {
//   final result = await safeApiCall(() => userRepository.getUserData());
//   if (result != null) {
//     // Process data
//   }
// }

// =========================================>

/// 7. Connectivity-Aware Widget
// Create a wrapper widget that rebuilds when connectivity changes:
class ConnectivityAwareWidget extends StatefulWidget {
  final Widget onlineWidget;
  final Widget offlineWidget;

  const ConnectivityAwareWidget({
    super.key,
    required this.onlineWidget,
    required this.offlineWidget,
  });

  @override
  State<ConnectivityAwareWidget> createState() =>
      _ConnectivityAwareWidgetState();
}

class _ConnectivityAwareWidgetState extends State<ConnectivityAwareWidget> {
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _checkInitialConnectivity();
    ConnectivityChecker.instance.onConnectivityChanged = (isConnected) {
      setState(() {
        _isOnline = isConnected;
      });
    };
  }

  Future<void> _checkInitialConnectivity() async {
    final isConnected = await ConnectivityChecker.instance.isConnected();
    setState(() {
      _isOnline = isConnected;
    });
  }

  @override
  void dispose() {
    ConnectivityChecker.instance.onConnectivityChanged = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isOnline ? widget.onlineWidget : widget.offlineWidget;
  }
}

// // Usage
// ConnectivityAwareWidget(
//   onlineWidget: YourNormalContent(),
//   offlineWidget: OfflineIndicator(),
// )

// =========================================>

/// 8. Implementing Refresh on Reconnection
// class MyHomePageState extends State<MyHomePage> {
//   List<dynamic> _data = [];
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadData();

//     // Refresh data when connection is restored
//     ConnectivityChecker.instance.onConnectivityChanged = (isConnected) {
//       if (isConnected && _data.isEmpty) {
//         _loadData();
//       }
//     };
//   }

//   Future<void> _loadData() async {
//     if (!await ConnectivityChecker.instance.isConnected()) {
//       return; // Don't attempt to load if offline
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final result = await apiService.fetchData();
//       setState(() {
//         _data = result;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     ConnectivityChecker.instance.onConnectivityChanged = null;
//     super.dispose();
//   }
// }

// =========================================>

/// 9. Manually Control UI Elements
// // Manually close snackbar
// ElevatedButton(
//   onPressed: () {
//     ConnectivityChecker.instance.closeSnackBar();
//   },
//   child: Text("Dismiss Notification"),
// )

// // Manually close dialog
// ElevatedButton(
//   onPressed: () {
//     ConnectivityChecker.instance.closeConnectivityDialog();
//   },
//   child: Text("Close Dialog"),
// )

class ConnectivityChecker {
  factory ConnectivityChecker() => _instance;
  ConnectivityChecker._internal();
  static final ConnectivityChecker _instance = ConnectivityChecker._internal();
  static ConnectivityChecker get instance => _instance;

  /// Context for pop Connectivity Dialog
  BuildContext? _connectivityDialogContext;

  bool firstTimeOpeningApp = true;
  bool isDialogOpen = false;
  bool isSnackBarVisible = false;

  // Debounce timer to prevent rapid state changes
  Timer? _debounceTimer;

  // Last known internet status
  InternetStatus _lastInternetStatus = InternetStatus.connected;

  // Last known network connectivity
  List<ConnectivityResult> _lastConnectivityResults = [ConnectivityResult.wifi];

  // How long to wait before showing disconnection UI
  final Duration _connectionStabilityDelay = const Duration(seconds: 3);

  // Callback that can be set by other parts of the app to be notified of connectivity changes
  Function(bool isConnected)? onConnectivityChanged;

  void initialize() async {
    try {
      // Check initial statuses
      final initialInternetStatus = await InternetConnection().internetStatus;
      _lastInternetStatus = initialInternetStatus;

      final initialConnectivity = await Connectivity().checkConnectivity();
      _lastConnectivityResults = initialConnectivity;

      // Handle initial state when app starts
      _handleInitialState(initialInternetStatus, initialConnectivity);

      // Listen to internet status changes
      InternetConnection().onStatusChange.listen(_handleInternetStatusChange);

      // Listen to connectivity changes
      Connectivity().onConnectivityChanged.listen(_handleConnectivityChange);
    } on PlatformException catch (e) {
      debugPrint(
        'Platform does not support connectivity queries: ${e.message}',
      );
    }
  }

  /// Handle the initial state when app starts
  void _handleInitialState(
    InternetStatus internetStatus,
    List<ConnectivityResult> connectivityResults,
  ) {
    final hasNetworkConnection =
        !connectivityResults.contains(ConnectivityResult.none);

    if (!hasNetworkConnection) {
      // No network connection at all - show dialog
      Future.delayed(const Duration(seconds: 1), () {
        showConnectivityDialog();
      });
    } else if (internetStatus == InternetStatus.disconnected) {
      // Connected to network but no internet - show snackbar
      Future.delayed(const Duration(seconds: 1), () {
        showSnackBar(online: false);
      });
    }

    // Notify listeners about initial state
    if (onConnectivityChanged != null) {
      onConnectivityChanged!(internetStatus == InternetStatus.connected);
    }
  }

  /// Manually check connection and update UI
  /// Returns true if connected to internet, false otherwise
  Future<bool> checkConnection({bool updateUI = true}) async {
    iPrint("Manual connection check initiated");

    try {
      // Check current status
      final connectivityResults = await Connectivity().checkConnectivity();
      final internetStatus = await InternetConnection().internetStatus;

      // Update stored status
      _lastConnectivityResults = connectivityResults;
      _lastInternetStatus = internetStatus;

      final hasNetworkConnection =
          !connectivityResults.contains(ConnectivityResult.none);
      final hasInternet = internetStatus == InternetStatus.connected;

      // Update UI if requested
      if (updateUI) {
        if (!hasNetworkConnection) {
          // No network connection - show dialog
          if (!isDialogOpen) {
            closeSnackBar();
            showConnectivityDialog();
          }
        } else if (!hasInternet) {
          // Network but no internet - show snackbar
          if (isDialogOpen) {
            closeConnectivityDialog();
          }
          if (!isSnackBarVisible) {
            showSnackBar(online: false);
          }
        } else {
          // Everything works - close all notifications
          closeSnackBar();
          closeConnectivityDialog();
          if (!firstTimeOpeningApp) {
            showOnlineSnackBar();
          } else {
            firstTimeOpeningApp = false;
          }
        }
      }

      // Notify listeners
      if (onConnectivityChanged != null) {
        onConnectivityChanged!(hasInternet);
      }

      return hasInternet;
    } catch (e) {
      iPrint("Error checking connection: $e");
      return false;
    }
  }

  /// Force show connection dialog regardless of current state
  /// Useful for manual connection troubleshooting
  void forceShowConnectivityDialog() {
    closeSnackBar();
    showConnectivityDialog(forceShow: true);
  }

  /// Handle internet status changes with debouncing
  void _handleInternetStatusChange(InternetStatus status) {
    iPrint("Raw InternetStatus change detected: $status");

    // Cancel any pending timer
    _debounceTimer?.cancel();

    if (status == InternetStatus.connected &&
        _lastInternetStatus == InternetStatus.disconnected) {
      // Connected to internet - update UI immediately
      _processStatusChange(status: status);
    } else if (status == InternetStatus.disconnected &&
        _lastInternetStatus == InternetStatus.connected) {
      // Lost internet - wait to confirm it's not just a momentary blip
      _debounceTimer = Timer(_connectionStabilityDelay, () {
        // Verify current status before showing UI
        Future.wait([
          InternetConnection().internetStatus,
          Connectivity().checkConnectivity(),
        ]).then((results) {
          final currentInternetStatus = results[0] as InternetStatus;
          final currentConnectivity = results[1] as List<ConnectivityResult>;

          if (currentInternetStatus == InternetStatus.disconnected) {
            _processStatusChange(
              status: currentInternetStatus,
              connectivity: currentConnectivity,
            );
          }
        });
      });
    }
  }

  /// Handle connectivity changes with debouncing
  void _handleConnectivityChange(List<ConnectivityResult> results) {
    iPrint("Raw ConnectionStatus change detected: ${results.last}");

    // Update stored connectivity
    final previousHadConnection =
        !_lastConnectivityResults.contains(ConnectivityResult.none);
    final currentHasConnection = !results.contains(ConnectivityResult.none);
    _lastConnectivityResults = results;

    // Cancel any pending timer
    _debounceTimer?.cancel();

    if (!previousHadConnection && currentHasConnection) {
      // Gained network connection - verify internet and update UI
      _debounceTimer = Timer(_connectionStabilityDelay, () {
        InternetConnection().internetStatus.then((internetStatus) {
          _processStatusChange(status: internetStatus, connectivity: results);
        });
      });
    } else if (previousHadConnection && !currentHasConnection) {
      // Lost network connection - wait to confirm it's not just a momentary blip
      _debounceTimer = Timer(_connectionStabilityDelay, () {
        // Verify current connectivity before showing UI
        Connectivity().checkConnectivity().then((currentResults) {
          final currentHasNoConnection = currentResults.contains(
            ConnectivityResult.none,
          );

          if (currentHasNoConnection) {
            _processStatusChange(connectivity: currentResults);
          }
        });
      });
    }
  }

  /// Process status changes after verifying them
  void _processStatusChange({
    InternetStatus? status,
    List<ConnectivityResult>? connectivity,
  }) {
    // Update stored states if provided
    if (status != null) {
      _lastInternetStatus = status;
    }
    if (connectivity != null) {
      _lastConnectivityResults = connectivity;
    }

    // Get current network connection status
    final hasNetworkConnection =
        !_lastConnectivityResults.contains(ConnectivityResult.none);
    final hasInternet = _lastInternetStatus == InternetStatus.connected;

    // Notify listeners
    if (onConnectivityChanged != null) {
      onConnectivityChanged!(hasInternet);
    }

    // Handle different scenarios
    if (!hasNetworkConnection) {
      // No network connection - show dialog if not already showing
      if (!isDialogOpen) {
        closeSnackBar();
        showConnectivityDialog();
      }
      return;
    }

    // At this point, we have network connection

    // Close dialog if it's open (we have network now)
    if (isDialogOpen) {
      closeConnectivityDialog();
    }

    // Check internet status
    if (hasInternet) {
      // We have internet - close any notifications
      if (isSnackBarVisible) {
        closeSnackBar();
        // Show "back online" snackbar if not first time
        if (!firstTimeOpeningApp) {
          showOnlineSnackBar();
        } else {
          firstTimeOpeningApp = false;
        }
      }
    } else {
      // Connected to network but no internet - show snackbar if not already showing
      if (!isSnackBarVisible) {
        showSnackBar(online: false);
      }
    }
  }

  void closeConnectivityDialog() {
    if (_connectivityDialogContext != null && isDialogOpen) {
      Navigator.of(_connectivityDialogContext!).pop();
      isDialogOpen = false;
      _connectivityDialogContext = null;
      iPrint("Closed connectivity dialog");
    }
  }

  void closeSnackBar() {
    if (navigatorKey.currentContext != null && isSnackBarVisible) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).hideCurrentSnackBar();
      isSnackBarVisible = false;
      iPrint("Closed snackbar");
    }
  }

  void showOnlineSnackBar() {
    if (navigatorKey.currentContext == null) return;

    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      const SnackBar(
        content: Text("Back online", textAlign: TextAlign.center),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
      ),
    );
  }

  Future<void> showConnectivityDialog({bool forceShow = false}) async {
    const settingsPlusAndroid = OpenSettingsPlusAndroid();
    const settingsPlusIOS = OpenSettingsPlusIOS();

    // Guard clause to prevent multiple dialogs unless forceShow is true
    if (navigatorKey.currentContext == null || (isDialogOpen && !forceShow)) {
      return;
    }
    iPrint("Showing connectivity dialog");

    // If force showing and dialog is already open, close it first
    if (forceShow && isDialogOpen) {
      closeConnectivityDialog();
    }

    await showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (context) {
        isDialogOpen = true;
        _connectivityDialogContext = context;
        return WillPopScope(
          onWillPop:
              () async => false, // Prevent back button from closing dialog
          child: AlertDialog(
            title: const Text("Connection Disabled"),
            content: const Text("Please enable your Wifi or Mobile Data"),
            actions: [
              TextButton(
                child: const Text("Wifi"),
                onPressed: () {
                  if (Platform.isAndroid) {
                    settingsPlusAndroid.wifi();
                  } else {
                    settingsPlusIOS.wifi();
                  }
                },
              ),
              TextButton(
                child: const Text("Mobile Data"),
                onPressed: () {
                  if (Platform.isAndroid) {
                    settingsPlusAndroid.date();
                  } else {
                    settingsPlusIOS.cellular();
                  }
                },
              ),
              TextButton(
                child: const Text("Check Connection"),
                onPressed: () => checkConnection(),
              ),
            ],
          ),
        );
      },
    );
  }

  void showSnackBar({required bool online}) {
    if (navigatorKey.currentContext == null) return;

    if (online) {
      showOnlineSnackBar();
      return;
    }

    // Don't show if already showing
    if (isSnackBarVisible) return;

    iPrint("Showing offline snackbar");
    isSnackBarVisible = true;

    ScaffoldMessenger.of(navigatorKey.currentContext!)
        .showSnackBar(
          SnackBar(
            content: const Text("You are offline", textAlign: TextAlign.center),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
            duration: const Duration(
              days: 365,
            ), // Effectively permanent until dismissed
            onVisible: () {
              isSnackBarVisible = true;
            },
            dismissDirection: DismissDirection.none, // Prevent swiping away
            action: SnackBarAction(
              label: "Try again",
              onPressed: () => checkConnection(),
            ),
          ),
        )
        .closed
        .then((_) {
          isSnackBarVisible = false;
        });
  }

  /// Check current internet connection status without updating UI
  /// Returns true if connected to internet, false otherwise
  /// Useful for API calls or other operations that need to check connectivity first
  Future<bool> isConnected() async {
    try {
      final internetStatus = await InternetConnection().internetStatus;
      return internetStatus == InternetStatus.connected;
    } catch (e) {
      iPrint("Error checking connection status: $e");
      return false;
    }
  }

  /// Check if device is connected to a network (WiFi or cellular)
  /// regardless of internet availability
  Future<bool> isNetworkAvailable() async {
    try {
      final connectivityResults = await Connectivity().checkConnectivity();
      return !connectivityResults.contains(ConnectivityResult.none);
    } catch (e) {
      iPrint("Error checking network availability: $e");
      return false;
    }
  }

  // Clean up resources
  void dispose() {
    _debounceTimer?.cancel();
    closeSnackBar();
    closeConnectivityDialog();
    onConnectivityChanged = null;
  }
}
