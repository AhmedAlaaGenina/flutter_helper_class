import 'package:flutter/material.dart';

class AnimatedHeight extends StatefulWidget {
  const AnimatedHeight({
    super.key,
    required this.child,
    required this.controller,
    this.initiallyClosed = false,
  });

  final Widget child;
  final AnimationController controller;
  final bool initiallyClosed;

  @override
  State<AnimatedHeight> createState() => _AnimatedHeightState();
}

class _AnimatedHeightState extends State<AnimatedHeight>
    with TickerProviderStateMixin {
  final GlobalKey _keyFoldChild = GlobalKey();
  Animation<double>? _sizeAnimation;
  double? _childWidth;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
  }

  void _afterLayout(_) {
    if (_keyFoldChild.currentContext == null) return;
    final RenderBox renderBox =
        _keyFoldChild.currentContext?.findRenderObject() as RenderBox;
    _sizeAnimation = Tween<double>(
            begin: widget.initiallyClosed ? 0.0 : renderBox.size.height,
            end: widget.initiallyClosed ? renderBox.size.height : 0.0)
        .animate(widget.controller);
    _childWidth = renderBox.size.width;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, child) {
        if (_sizeAnimation == null && !widget.initiallyClosed) {
          return child!;
        } else {
          return ClipRect(
            child: SizedOverflowBox(
              size: Size(_childWidth ?? 0, _sizeAnimation?.value ?? 0),
              child: child,
            ),
          );
        }
      },
      child: Container(
        key: _keyFoldChild,
        child: widget.child,
      ),
    );
  }
}
