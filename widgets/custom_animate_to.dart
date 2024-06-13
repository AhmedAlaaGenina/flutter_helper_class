import 'package:flutter/material.dart';

enum AnimateDirectionsValues {
  left,
  right,
  up,
  down,
}

extension AnimateDirections on AnimateDirectionsValues {
  int get valueOfDirection {
    switch (this) {
      case AnimateDirectionsValues.left:
      case AnimateDirectionsValues.down:
        return -1;
      case AnimateDirectionsValues.right:
      case AnimateDirectionsValues.up:
        return 1;
      default:
        return 0;
    }
  }
}

class CustomAnimateTo extends StatefulWidget {
  const CustomAnimateTo({
    super.key,
    required this.child,
    required this.direction,
    this.controller,
    this.afterAnimate,
    this.duration = const Duration(milliseconds: 1200),
    this.delay = const Duration(milliseconds: 0),
    this.animationCurve = Curves.easeOut,
    this.opacityCurve = const Interval(0, 0.65),
  });

  final Function(AnimationController)? controller;
  final VoidCallback? afterAnimate;
  final Widget child;
  final Duration delay;
  final AnimateDirectionsValues direction;
  final Duration duration;
  final Curve animationCurve;
  final Curve opacityCurve;

  @override
  State<CustomAnimateTo> createState() => _CustomAnimateToState();
}

class _CustomAnimateToState extends State<CustomAnimateTo>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  AnimationController? controller;
  bool disposed = false;
  late Animation<double> opacity;

  @override
  void dispose() {
    disposed = true;
    controller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    animation = Tween<double>(
      //? when to start animation
      //? smaller number is to get small space
      //? bigger number is to get all space
      begin: widget.direction.valueOfDirection * getValueOfBegin(),
      end: 0,
    ).animate(
      CurvedAnimation(
        parent: controller!,
        curve: widget.animationCurve,
      ),
    );

    opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller!,
        curve: widget.opacityCurve,
      ),
    );

    //? callback function after animation end
    controller!.addStatusListener((AnimationStatus status) {
      if (widget.afterAnimate != null && status == AnimationStatus.completed) {
        widget.afterAnimate!();
      }
    });

    //? determine any controller to use
    if (widget.controller is Function) {
      widget.controller!(controller!);
    }
  }

  Offset getOffset() {
    if (widget.direction == AnimateDirectionsValues.up ||
        widget.direction == AnimateDirectionsValues.down) {
      return Offset(0, animation.value);
    }
    return Offset(animation.value, 0);
  }

  //? start from when
  double getValueOfBegin() {
    if (widget.direction == AnimateDirectionsValues.up ||
        widget.direction == AnimateDirectionsValues.down) {
      return 412;
    }
    return 156;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.delay.inMilliseconds == 0) {
      controller?.forward();
    }

    return AnimatedBuilder(
      animation: controller!,
      builder: (BuildContext context, Widget? child) {
        return Transform.translate(
          offset: getOffset(),
          child: Opacity(
            opacity: opacity.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}
