import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class OverflowMarquee extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double blankSpace;
  final double? width;
  final Duration pauseAfterRound;
  final Duration accelerationDuration;
  final Duration decelerationDuration;

  const OverflowMarquee({
    super.key,
    required this.text,
    required this.style,
    this.width,
    this.blankSpace = 20.0,
    this.pauseAfterRound = const Duration(seconds: 1),
    this.accelerationDuration = const Duration(milliseconds: 200),
    this.decelerationDuration = const Duration(milliseconds: 100),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final TextPainter textPainter = TextPainter(
          text: TextSpan(text: text, style: style),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: width ?? constraints.maxWidth);

        final bool isOverflowing =
            textPainter.width >= (width ?? constraints.maxWidth);

        if (isOverflowing) {
          return Marquee(
            text: text,
            style: style,
            blankSpace: blankSpace,
            pauseAfterRound: pauseAfterRound,
            accelerationDuration: accelerationDuration,
            decelerationDuration: decelerationDuration,
          );
        } else {
          return Center(
            child: Text(
              text,
              style: style,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          );
        }
      },
    );
  }
}
