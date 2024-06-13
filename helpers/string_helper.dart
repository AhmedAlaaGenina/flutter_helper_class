import 'package:fashion/core/extension/extension.dart';
import 'package:flutter/material.dart';

class StringHelper {
  StringHelper._();
  static MainAxisAlignment mainAxisAlignment({
    required String text,
    required bool isDeviceArabic,
    bool replacement = false,
  }) {
    // Check if the text is Arabic
    var isTextArabic = text.isArabic();

    // If the text is Arabic and the device locale is Arabic,
    // or if the text is not Arabic and the device locale is not Arabic,
    // set alignment based on replacement flag
    if ((isTextArabic && isDeviceArabic) ||
        (!isTextArabic && !isDeviceArabic)) {
      return replacement ? MainAxisAlignment.end : MainAxisAlignment.start;
    }
    // If the text and device locale do not match, set alignment based on replacement flag
    else {
      return replacement ? MainAxisAlignment.start : MainAxisAlignment.end;
    }
  }

  static TextAlign textAlign({
    required String text,
    required bool isDeviceArabic,
  }) {
    var isTextArabic = text.isArabic();

    if (isTextArabic && isDeviceArabic) {
      return TextAlign.right;
    } else if (!isTextArabic && !isDeviceArabic) {
      return TextAlign.left;
    } else if (isTextArabic && !isDeviceArabic) {
      return TextAlign.right;
    } else {
      return TextAlign.left;
    }
  }

  static TextDirection textDirection({
    required String text,
    required bool isDeviceArabic,
  }) {
    var isTextArabic = text.isArabic();

    if (isTextArabic && isDeviceArabic) {
      return TextDirection.rtl;
    } else if (!isTextArabic && !isDeviceArabic) {
      return TextDirection.ltr;
    } else if (isTextArabic && !isDeviceArabic) {
      return TextDirection.rtl;
    } else {
      return TextDirection.ltr;
    }
  }
}
