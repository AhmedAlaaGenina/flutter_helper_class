import 'dart:ui';

import 'package:flutter/material.dart';

class DottedBorder extends StatelessWidget {
  final Widget child;
  final double strokeWidth;
  final Color color;
  final List<double> dashPattern;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;
  final bool isCircle;
  final double? size;

  const DottedBorder({
    super.key,
    required this.child,
    this.strokeWidth = 1.0,
    this.color = Colors.black,
    this.dashPattern = const [3, 3],
    this.borderRadius = BorderRadius.zero,
    this.padding = const EdgeInsets.all(8),
    this.isCircle = false,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    if (isCircle) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final double diameter = size ??
              (constraints.maxWidth != double.infinity
                  ? constraints.maxWidth
                  : 100);

          return SizedBox(
            width: diameter,
            height: diameter,
            child: CustomPaint(
              painter: _DottedBorderPainter(
                strokeWidth: strokeWidth,
                color: color,
                dashPattern: dashPattern,
                borderRadius: borderRadius,
                isCircle: true,
              ),
              child: Center(
                child: Padding(
                  padding: padding,
                  child: SizedBox(
                    width: diameter - (strokeWidth * 2) - padding.horizontal,
                    height: diameter - (strokeWidth * 2) - padding.vertical,
                    child: Center(child: child),
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      return CustomPaint(
        painter: _DottedBorderPainter(
          strokeWidth: strokeWidth,
          color: color,
          dashPattern: dashPattern,
          borderRadius: borderRadius,
          isCircle: isCircle,
        ),
        child: Container(
          padding: padding,
          child: child,
        ),
      );
    }
  }
}

class _DottedBorderPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final List<double> dashPattern;
  final BorderRadius borderRadius;
  final bool isCircle;

  _DottedBorderPainter({
    required this.strokeWidth,
    required this.color,
    required this.dashPattern,
    required this.borderRadius,
    required this.isCircle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final Path path = Path();

    if (isCircle) {
      // Ensure we draw a perfect circle by using center point and radius
      final double radius = size.width / 2;
      final Offset center = Offset(size.width / 2, size.height / 2);
      path.addOval(
          Rect.fromCircle(center: center, radius: radius - (strokeWidth / 2)));
    } else {
      // Draw a rounded rectangle
      path.addRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2,
              size.width - strokeWidth, size.height - strokeWidth),
          topLeft: borderRadius.topLeft,
          topRight: borderRadius.topRight,
          bottomLeft: borderRadius.bottomLeft,
          bottomRight: borderRadius.bottomRight,
        ),
      );
    }

    // Create dotted effect
    final Path dashPath = Path();
    final PathMetrics pathMetrics = path.computeMetrics();

    for (PathMetric metric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;

      while (distance < metric.length) {
        double len = dashPattern[draw ? 0 : 1];
        if (distance + len > metric.length) {
          len = metric.length - distance;
        }

        if (draw) {
          dashPath.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }

        distance += len;
        draw = !draw;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(_DottedBorderPainter oldPainter) {
    return oldPainter.strokeWidth != strokeWidth ||
        oldPainter.color != color ||
        oldPainter.dashPattern != dashPattern ||
        oldPainter.borderRadius != borderRadius ||
        oldPainter.isCircle != isCircle;
  }
}
