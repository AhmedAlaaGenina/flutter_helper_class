import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedItemBuilderWidget extends StatefulWidget {
  final Widget child;
  final int index;
  final Duration delay;
  final bool enableAnimation;

  const AnimatedItemBuilderWidget({
    super.key,
    required this.child,
    required this.index,
    this.delay = const Duration(milliseconds: 20),
    this.enableAnimation = true,
  });

  @override
  State<AnimatedItemBuilderWidget> createState() =>
      _AnimatedItemBuilderWidgetState();
}

class _AnimatedItemBuilderWidgetState extends State<AnimatedItemBuilderWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      // Reduce the slide distance for less movement
      begin: const Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    // Cap the maximum delay to prevent long waits for items far down
    final maxDelay = const Duration(milliseconds: 100);
    final actualDelay =
        widget.index < 5 ? widget.delay * widget.index : maxDelay;

    if (widget.enableAnimation) {
      // Start animation after a delay based on item index for staggered effect
      Future.delayed(actualDelay, () {
        if (mounted) {
          _animationController.forward();
        }
      });
    } else {
      // If animations disabled, just show item immediately
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enableAnimation) {
      return widget.child;
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: widget.child),
    );
  }
}
