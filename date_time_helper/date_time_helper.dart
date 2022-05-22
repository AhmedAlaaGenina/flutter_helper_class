import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeHelper {
  static String dateToString(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  static DateTime stringToData(String dateTime) {
    return DateFormat('yyyy-MM-dd').parse(dateTime);
  }

  static String stringToTime(String dateTime, Locale locale) {
    List<String> times = dateTime.split(":");
    DateTime time = DateTime(
        0, 0, 0, int.parse(times[0]), int.parse(times[1]), int.parse(times[2]));
    return DateFormat('h a', locale.languageCode).format(time);
  }

  static int currentDayInMonth(int year, int month) {
    if (month == DateTime.february) {
      final bool isLeapYear =
          (year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0);
      return isLeapYear ? 29 : 28;
    }
    const List<int> daysInMonth = <int>[
      31,
      -1,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    return daysInMonth[month - 1];
  }
}
