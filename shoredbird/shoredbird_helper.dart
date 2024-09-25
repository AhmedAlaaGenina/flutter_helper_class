import 'package:flutter/material.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';

class ShorebirdUpdateManager {
  ShorebirdUpdateManager._();

  // Singleton instance
  static final ShorebirdCodePush _shorebirdCodePush = ShorebirdCodePush();

  /// Check if Shorebird is available
  static bool isShorebirdAvailable() {
    try {
      return _shorebirdCodePush.isShorebirdAvailable();
    } catch (e) {
      debugPrint('Error checking Shorebird availability: $e');
      return false;
    }
  }

  /// Check if an update is available
  static Future<bool> isUpdateAvailable() async {
    try {
      return await _shorebirdCodePush.isNewPatchAvailableForDownload();
    } catch (e) {
      debugPrint('Error checking for updates: $e');
      return false;
    }
  }

  /// Download the update if available
  static Future<bool> downloadUpdate() async {
    try {
      await _shorebirdCodePush.downloadUpdateIfAvailable();
      return true;
    } catch (e) {
      debugPrint('Error downloading update: $e');
      return false;
    }
  }

  /// Get the current patch number
  static Future<int?> getCurrentPatchNumber() async {
    try {
      return await _shorebirdCodePush.currentPatchNumber();
    } catch (e) {
      debugPrint('Error retrieving current patch number: $e');
      return null;
    }
  }

  /// Check for an update, download if available, and prompt user to restart
  static Future<void> checkForUpdatesAndApply(BuildContext context) async {
    if (!(isShorebirdAvailable() &&
        await isUpdateAvailable() &&
        context.mounted)) return;

    bool isUserWillingToUpdate = await _promptUserToUpdate(context) ?? false;
    if (!isUserWillingToUpdate) return;

    bool downloadSuccessful = await downloadUpdate();
    if (!(downloadSuccessful && context.mounted)) return;

    _promptUserToRestart(context);
  }

  /// Prompt the user to restart the app after a successful update download
  static void _promptUserToRestart(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Ready'),
          content: const Text(
              'An update has been downloaded. Please restart the app to apply the changes.'),
          actions: [
            TextButton(
              child: const Text('Later'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () => RestartWidget.restartApp(context),
              child: const Text('Restart Now'),
            ),
          ],
        );
      },
    );
  }

  /// Prompt the user to confirm if they want to download and apply the update
  static Future<bool?> _promptUserToUpdate(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Available'),
          content: const Text(
              'A new update is available. Would you like to update now?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Later'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Update Now'),
            ),
          ],
        );
      },
    );
  }
}

// void main() {
//   runApp(
//     RestartWidget(
//       child: MaterialApp(),
//     ),
//   );
// }
class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
