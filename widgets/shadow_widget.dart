import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:truck_queuing_app/config/theme/theme.dart';

class ShadowWidget extends StatelessWidget {
  final Widget child;
  final double opacity;
  final double sigma;

  final double radius;
  final Color? color;
  final Offset offset;

  const ShadowWidget({
    super.key,
    required this.child,
    this.radius = 6,
    this.opacity = 0.5,
    this.sigma = 2,
    this.color,
    this.offset = const Offset(2, 2),
  });

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? AppColors.shadowColor;
    return Stack(
      children: [
        if (color.alpha != 0)
          Transform.translate(
            offset: offset,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaY: sigma,
                sigmaX: sigma,
                tileMode: TileMode.decal,
              ),
              child: Container(
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(radius),
                  border: Border.all(
                    color: Colors.transparent,
                    width: 0,
                  ),
                ),
                child: Opacity(
                  opacity: opacity,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(color, BlendMode.srcATop),
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        child,
      ],
    );
  }
}
