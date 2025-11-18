
import 'package:intl/intl.dart';

extension DateTimeFormatter on DateTime {
  String toFormattedDateTime() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    String formattedTime = DateFormat('hh:mm a').format(this); // 12-hour format
    String formattedDate =
        DateFormat('dd MMM yyyy, hh:mm a').format(this); // Full format

    if (year == today.year && month == today.month && day == today.day) {
      return "Today, $formattedTime";
    } else {
      return formattedDate;
    }
  }

  String toDayMonthYear() {
    final formatted = DateFormat('d MMM yyyy').format(this);
    return formatted; // "28 oct 2024"
  }

  String get dayCompleteMonthYear => DateFormat('dd MMMM, yyyy').format(this);
  String get dayAbbreviationMonthYear =>
      DateFormat('dd MMM, yyyy').format(this);

  String get toFormattedTime => DateFormat('hh:mm a').format(this);

  String get dayAbbreviation => DateFormat('EEE').format(this); // "Mon"
  String get weekDayAbbreviation => DateFormat('EEEE').format(this); // "Monday"
  String get monthAbbreviation => DateFormat('MMM').format(this); // "Mar"
  String get dayMonthYearInUpperCase =>
      DateFormat('dd MMM yyyy').format(this).toUpperCase(); // "22 MAR 2025"

  String get timeIn24HourFormat => DateFormat('HH:mm').format(this); // "14:30"

  String get timeIn12HourFormat =>
      DateFormat('hh:mm a').format(this); // "02:30 PM"
  String get dateInDash =>
      DateFormat('yyyy-MM-dd').format(this); // "2024-03-17"
  String get dateInSlash =>
      DateFormat('yyyy/MM/dd').format(this); // "2024/03/17"

  String get dayAnd24HourTime =>
      DateFormat('EEE, HH:mm').format(this); // "Mon, 14:30"

  String get dayAnd12HourTime =>
      DateFormat('EEE, hh:mm a').format(this); // "Mon, 02:30 PM"

  String get dayMonth => DateFormat('d MMM').format(this); // "17 Mar"
  String get monthDay => DateFormat('MMM d').format(this); // "Mar 17"
  String get completeDateTime24 =>
      DateFormat('yyyy-MM-dd HH:mm').format(this); // "2024-03-17 14:30"
  String get completeDateTime12 =>
      DateFormat('yyyy-MM-dd hh:mm a').format(this);

  String get completeDateTime24WithSecondInDash =>
      DateFormat('dd/MM/yyyy  HH:mm:ss').format(this); // "2024-03-17 14:30"
  String get completeDateTime24WithSecond =>
      DateFormat('yyyy-MM-dd  HH:mm:ss').format(this); // "2024-03-17 14:30"
  String get completeDateTime12WithSecond =>
      DateFormat('yyyy-MM-dd hh:mm:ss a').format(this);

  String get completeDateTime24InSlash =>
      DateFormat('dd/MM/yyyy HH:mm').format(this);

  String get completeDateTime12InSlash =>
      DateFormat('dd/MM/yyyy hh:mm a').format(this);

  // Mar 17 - Apr 1
  // 17 Mar - 1 Apr
  // 17 - 21 Mar
  String dayRangeMonth(
    DateTime? toDate, {
    bool showFirstMonth = false,
    bool isMonthFirst = false,
  }) {
    if (toDate == null) return '';
    final fromDay = DateFormat('d').format(this);
    final fromMonth = DateFormat('MMM').format(this);
    final toDay = DateFormat('d').format(toDate);
    final toMonth = DateFormat('MMM').format(toDate);
    final sameMonth = fromMonth == toMonth;
    if (this.isBefore(toDate)) {
      return sameMonth && !showFirstMonth
          ? !isMonthFirst
              ? '$fromDay - $toDay $toMonth'
              : '$fromMonth $fromDay - $toDay'
          : !isMonthFirst
              ? '$fromDay $fromMonth - $toDay $toMonth'
              : '$fromMonth $fromDay - $toMonth $toDay';
    } else {
      return sameMonth && !showFirstMonth
          ? !isMonthFirst
              ? '$toDay - $fromDay $toMonth'
              : '$fromMonth $toDay - $fromDay'
          : !isMonthFirst
              ? '$toDay $toMonth - $fromDay $fromMonth'
              : '$fromMonth $toDay - $fromMonth $fromDay';
    }
  }

  int differenceInDays(DateTime? toDate) {
    if (toDate == null) return 0;
    final daysDifference = toDate.difference(this).inDays + 1;
    return daysDifference;
  }

  String getRelativeDate() {
    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final week = DateTime(now.year, now.month, now.day - 7);

    if (this.year == now.year &&
        this.month == now.month &&
        this.day == now.day) {
      return 'Today';
    } else if (this.year == yesterday.year &&
        this.month == yesterday.month &&
        this.day == yesterday.day) {
      return 'Yesterday';
    } else if (this.isAfter(week)) {
      return DateFormat('EEEE').format(this);
    } else {
      return DateFormat('MMM d, yyyy').format(this);
    }
  }

  bool isSameDay(DateTime date) {
    return this.year == date.year &&
        this.month == date.month &&
        this.day == date.day;
  }
}
