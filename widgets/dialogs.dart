import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class Dialogs {
  static Future<bool> showYesNoDialog(
    BuildContext context, {
    required String title,
    required String content,
  }) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => context.pop(false),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () => context.pop(true),
                child: const Text("Yes"),
              ),
            ],
          );
        });
  }

  static Future<void> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String content,
    VoidCallback? onTap,
    bool isDismissible = false,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          content: Text(
            content,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          actions: [
            TextButton(
              onPressed: onTap ?? () => context.pop(),
              child: const Text("confirmation"),
            ),
          ],
        );
      },
    );
  }

  static Future<void> showWidgetDialog(
    BuildContext context, {
    required Widget content,
    Widget? title,
    EdgeInsetsGeometry? contentPadding,
    double? radius,
    bool isDismissible = false,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: isDismissible,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 16.r),
          ),
          contentPadding: contentPadding ?? EdgeInsets.zero,
          title: title,
          content: content,
        );
      },
    );
  }
}
