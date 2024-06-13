import 'package:flutter/material.dart';

class DoubleTapHeartAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final VoidCallback? onDoubleTap;

  const DoubleTapHeartAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
    this.icon = Icons.favorite,
    this.iconColor = Colors.red,
    this.iconSize = 48.0,
    this.onDoubleTap,
  });

  @override
  State<DoubleTapHeartAnimation> createState() =>
      _DoubleTapHeartAnimationState();
}

class _DoubleTapHeartAnimationState extends State<DoubleTapHeartAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  Offset _tapPosition = Offset.zero;
  bool _showHeart = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.2,
          1.0,
          curve: Curves.easeIn,
        ),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(
          0.0, -8.0), // Move the heart icon 8 times its size upwards
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
        setState(() {
          _showHeart = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDoubleTap(TapDownDetails details) {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = renderBox.globalToLocal(details.globalPosition);
      _showHeart = true;
    });
    _controller.forward();
    if (widget.onDoubleTap != null) {
      widget.onDoubleTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: _handleDoubleTap,
      child: Stack(
        children: [
          widget.child,
          if (_showHeart)
            Positioned(
              left: _tapPosition.dx - widget.iconSize / 2,
              top: _tapPosition.dy - widget.iconSize / 2,
              child: SlideTransition(
                position: _slideAnimation,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Icon(
                          widget.icon,
                          color: widget.iconColor,
                          size: widget.iconSize,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
