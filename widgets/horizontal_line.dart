import 'package:flutter/material.dart';

class HorizontalLine extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  const HorizontalLine({
    super.key,
    this.height,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 1,
      width: width,
      decoration: BoxDecoration(
        color: color ?? Colors.grey,
        borderRadius: BorderRadius.circular(1),
      ),
    );
  }
}
