import 'package:flutter/material.dart';

import 'breakpoints.dart';

extension MediaQueryValues on BuildContext {
  double get height => MediaQuery.of(this).size.height;

  double get width => MediaQuery.of(this).size.width;

  double get topPadding => MediaQuery.of(this).viewPadding.top;

  double get bottomPadding => MediaQuery.of(this).viewPadding.bottom;

  double get bottom => MediaQuery.of(this).viewInsets.bottom;

  bool get isMobile => MediaQuery.of(this).size.width < kMobileBreakPoint;

  bool get isTablet =>
      MediaQuery.of(this).size.width <= kDesktopBreakPoint &&
      MediaQuery.of(this).size.width >= kMobileBreakPoint;

  bool get isDesktop => MediaQuery.of(this).size.width > kDesktopBreakPoint;
}
