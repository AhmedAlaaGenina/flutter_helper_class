import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

class StoragePermissionHandler {
  static Future<bool> requestStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;

        // For Android 13 (API 33) and above
        if (androidInfo.version.sdkInt >= 33) {
          // Request photos and media permissions separately
          final photos = await Permission.photos.request();
          final videos = await Permission.videos.request();
          final audio = await Permission.audio.request();

          return photos.isGranted && videos.isGranted && audio.isGranted;
        }
        // For Android 11 and 12 (API 30-32)
        else if (androidInfo.version.sdkInt >= 30) {
          final storage = await Permission.storage.request();
          final manageExternal =
              await Permission.manageExternalStorage.request();

          return storage.isGranted || manageExternal.isGranted;
        }
        // For Android 10 and below
        else {
          final status = await Permission.storage.request();
          return status.isGranted;
        }
      }
      // For iOS
      else if (Platform.isIOS) {
        final photos = await Permission.photos.request();
        final mediaLibrary = await Permission.mediaLibrary.request();

        return photos.isGranted && mediaLibrary.isGranted;
      }

      return false;
    } catch (e) {
      print('Error requesting storage permission: $e');
      return false;
    }
  }

  static Future<void> handleStorageAccess({
    required Function() onGranted,
    required Function() onDenied,
  }) async {
    bool hasPermission = await requestStoragePermission();

    if (hasPermission) {
      onGranted();
    } else {
      onDenied();
    }
  }
}
