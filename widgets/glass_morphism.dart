import 'dart:ui';

import 'package:flutter/material.dart';

class GlassMorphism extends StatelessWidget {
  const GlassMorphism({
    super.key,
    required this.child,
    this.blur = 10.0,
    this.opacity = 0.2,
    this.color = Colors.white,
    this.borderRadius,
  });
  final Widget child;
  final double blur;
  final double opacity;
  final Color color;
  final BorderRadius? borderRadius;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(opacity),
            borderRadius: borderRadius,
          ),
          child: child,
        ),
      ),
    );
  }
}
