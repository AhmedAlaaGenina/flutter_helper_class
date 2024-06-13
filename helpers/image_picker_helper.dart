import 'package:fashion/config/routes/routes.dart';
import 'package:fashion/core/util/util.dart';
import 'package:fashion/core/widgets/dialogs.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static final ImagePicker _picker = ImagePicker();

  // Method to pick an image from the camera
  static Future<XFile?> pickImageFromCamera({int? imageQuality}) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
      );
      if (pickedFile != null) {
        return pickedFile;
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      if (e.code == 'camera_access_denied') {
        _showPermissionDeniedDialog(
          'Camera access is required to capture photos.',
        );
      } else {
        ePrint('Error: $e');
      }
      return null;
    }
  }

  // Method to pick an image from the gallery
  static Future<XFile?> pickImageFromGallery({int? imageQuality}) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
      );
      if (pickedFile != null) {
        return pickedFile;
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      if (e.code == 'photo_access_denied') {
        _showPermissionDeniedDialog(
          'Gallery access is required to select photos.',
        );
      } else {
        ePrint('Error: $e');
      }
      return null;
    }
  }

  // Method to pick multiple images from the gallery
  static Future<List<XFile>> pickMultipleImages({int? imageQuality}) async {
    try {
      return await _picker.pickMultiImage(
        imageQuality: imageQuality,
      );
    } on PlatformException catch (e) {
      if (e.code == 'camera_access_denied' || e.code == 'photo_access_denied') {
        _showPermissionDeniedDialog(
          'Gallery access is required to select photos.',
        );
      } else {
        ePrint('Error: $e');
      }
    }
    return [];
  }

  // Method to show permission denied dialog
  static void _showPermissionDeniedDialog(
    String message,
  ) {
    Dialogs.showConfirmationDialog(
      RouteConfigurations.parentNavigatorKey.currentState!.context,
      title: 'Permission Denied',
      content: message,
    );
  }
}
