import 'package:flutter/material.dart';

import 'breakpoints.dart';

class ResponsiveLayout extends StatelessWidget {
  const ResponsiveLayout({
    Key? key,
    required this.mobileBody,
    this.tabletBody,
    required this.desktopBody,
  }) : super(key: key);

  final Widget mobileBody;
  final Widget? tabletBody;
  final Widget desktopBody;

  @override
  Widget build(BuildContext context) {
    /// we can use MediaQuery instance of LayoutBuilder ;)

    /// with animation
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: (constraints.maxWidth < kMobileBreakPoint)
              ? mobileBody
              : (constraints.maxWidth >= kMobileBreakPoint &&
                      constraints.maxWidth < kTabletBreakpoint)
                  ? tabletBody ?? mobileBody
                  : desktopBody,
        );
      },
    );

    /// without animation
    // return LayoutBuilder(
    // builder: (BuildContext context, BoxConstraints constraints) {
    //     if (constraints.maxWidth < kTabletBreakpoint) {
    //       return mobileBody;
    //     } else if (constraints.maxWidth >= kTabletBreakpoint &&
    //         constraints.maxWidth < kDesktopBreakPoint) {
    //       return tabletBody ?? mobileBody;
    //     } else {
    //       return desktopBody ?? mobileBody;
    //     }
    //   },
    // );
  }
}
