import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

final logger = Logger();

//for debug print
dPrint(String text) {
  logger.d(text);
}

//for error print
ePrint(String text) {
  logger.e(text);
}

//for info print
iPrint(String text) {
  logger.i(text);
}

//for verbose print
vPrint(String text) {
  logger.v(text);
}

//for warning print
wPrint(String text) {
  logger.w(text);
}

//for wtf ("What a Terrible Failure" or "What The Failure.") print
wtfPrint(String text) {
  logger.wtf(text);
}

//for long print
void lPrint(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => debugPrint(match.group(0) ?? ''));
}
