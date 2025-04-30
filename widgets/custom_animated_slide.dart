// import 'package:flutter/material.dart';

// /// Direction options for animations
// enum AnimateDirectionsValues {
//   left,
//   right,
//   up,
//   down,
//   topLeft,
//   topRight,
//   bottomLeft,
//   bottomRight,
// }

// extension AnimateDirections on AnimateDirectionsValues {
//   // Determine X direction value
//   int get xDirection {
//     switch (this) {
//       case AnimateDirectionsValues.left:
//       case AnimateDirectionsValues.topLeft:
//       case AnimateDirectionsValues.bottomLeft:
//         return -1;
//       case AnimateDirectionsValues.right:
//       case AnimateDirectionsValues.topRight:
//       case AnimateDirectionsValues.bottomRight:
//         return 1;
//       default:
//         return 0; // up and down have no x component
//     }
//   }

//   // Determine Y direction value
//   int get yDirection {
//     switch (this) {
//       case AnimateDirectionsValues.up:
//       case AnimateDirectionsValues.topLeft:
//       case AnimateDirectionsValues.topRight:
//         return -1;
//       case AnimateDirectionsValues.down:
//       case AnimateDirectionsValues.bottomLeft:
//       case AnimateDirectionsValues.bottomRight:
//         return 1;
//       default:
//         return 0; // left and right have no y component
//     }
//   }

//   // Check if this is a diagonal direction (corner)
//   bool get isDiagonal =>
//       this == AnimateDirectionsValues.topLeft ||
//       this == AnimateDirectionsValues.topRight ||
//       this == AnimateDirectionsValues.bottomLeft ||
//       this == AnimateDirectionsValues.bottomRight;
// }

// /// A widget that animates its child with translation and opacity effects
// class CustomAnimateTo extends StatefulWidget {
//   const CustomAnimateTo({
//     super.key,
//     required this.child,
//     required this.direction,
//     this.controller,
//     this.afterAnimate,
//     this.duration = const Duration(milliseconds: 1200),
//     this.delay = Duration.zero,
//     this.animationCurve = Curves.easeOutQuint,
//     this.opacityCurve = const Interval(0, 0.65, curve: Curves.easeOut),
//     this.distanceFactor = 0.3,
//   });

//   /// Callback to get the animation controller
//   final void Function(AnimationController)? controller;

//   /// Callback triggered when animation completes
//   final VoidCallback? afterAnimate;

//   /// The widget to animate
//   final Widget child;

//   /// Delay before starting the animation
//   final Duration delay;

//   /// Direction of the animation
//   final AnimateDirectionsValues direction;

//   /// Duration of the animation
//   final Duration duration;

//   /// Curve for the translation animation
//   final Curve animationCurve;

//   /// Curve for the opacity animation
//   final Curve opacityCurve;

//   /// Factor to determine animation distance (0.1-1.0)
//   /// Lower values mean shorter distance
//   final double distanceFactor;

//   @override
//   State<CustomAnimateTo> createState() => _CustomAnimateToState();
// }

// class _CustomAnimateToState extends State<CustomAnimateTo>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late Animation<Offset> _positionAnimation;
//   late final Animation<double> _opacityAnimation;
//   bool _animationInitialized = false;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       duration: widget.duration,
//       vsync: this,
//     );

//     // Setup controller callback if provided
//     widget.controller?.call(_controller);

//     // Handle animation completion callback
//     _controller.addStatusListener(_handleAnimationStatus);
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_animationInitialized) {
//       _initializeAnimations();
//       _animationInitialized = true;

//       // Schedule animation start with delay
//       _scheduleAnimation();
//     }
//   }

//   void _initializeAnimations() {
//     // Get screen dimensions for relative animations
//     final Size screenSize = MediaQuery.sizeOf(context);
//     final double maxWidth = screenSize.width;
//     final double maxHeight = screenSize.height;

//     // Calculate start position based on screen size and distanceFactor for x and y
//     final double startOffsetX = maxWidth * widget.distanceFactor *
//         widget.direction.xDirection;

//     final double startOffsetY = maxHeight * widget.distanceFactor *
//         widget.direction.yDirection;

//     // Position animation for both X and Y coordinates
//     _positionAnimation = Tween<Offset>(
//       begin: Offset(startOffsetX, startOffsetY),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: widget.animationCurve,
//       ),
//     );

//     // Opacity animation
//     _opacityAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: widget.opacityCurve,
//       ),
//     );
//   }

//   void _scheduleAnimation() {
//     if (widget.delay == Duration.zero) {
//       _controller.forward();
//     } else {
//       Future.delayed(widget.delay, () {
//         if (mounted) {
//           _controller.forward();
//         }
//       });
//     }
//   }

//   void _handleAnimationStatus(AnimationStatus status) {
//     if (status == AnimationStatus.completed && widget.afterAnimate != null) {
//       widget.afterAnimate!();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: _positionAnimation.value,
//           child: Opacity(
//             opacity: _opacityAnimation.value,
//             child: widget.child,
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _controller.removeStatusListener(_handleAnimationStatus);
//     _controller.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import 'dart:math' as math;

enum AnimationDirection {
  leftToRight,
  rightToLeft,
  bottomToTop,
  topToBottom,
  // Corner animations
  bottomLeftToTopRight,
  bottomRightToTopLeft,
  topLeftToBottomRight,
  topRightToBottomLeft,
}

/// Extension to provide utility methods for AnimationDirection
extension AnimationDirectionUtils on AnimationDirection {
  /// Returns the axis (horizontal or vertical) for the animation
  Axis get axis {
    switch (this) {
      case AnimationDirection.leftToRight:
      case AnimationDirection.rightToLeft:
        return Axis.horizontal;
      case AnimationDirection.bottomToTop:
      case AnimationDirection.topToBottom:
        return Axis.vertical;
      default:
        return Axis
            .horizontal; // For diagonal animations, default to horizontal
    }
  }

  /// Returns true if this is a diagonal/corner animation
  bool get isDiagonal {
    return this == AnimationDirection.bottomLeftToTopRight ||
        this == AnimationDirection.bottomRightToTopLeft ||
        this == AnimationDirection.topLeftToBottomRight ||
        this == AnimationDirection.topRightToBottomLeft;
  }

  /// Returns the horizontal multiplier (-1 or 1) based on direction
  int get horizontalMultiplier {
    switch (this) {
      case AnimationDirection.rightToLeft:
        return -1;
      case AnimationDirection.leftToRight:
        return 1;
      case AnimationDirection.bottomLeftToTopRight:
      case AnimationDirection.topLeftToBottomRight:
        return 1;
      case AnimationDirection.bottomRightToTopLeft:
      case AnimationDirection.topRightToBottomLeft:
        return -1;
      default:
        return 0; // No horizontal movement for pure vertical animations
    }
  }

  /// Returns the vertical multiplier (-1 or 1) based on direction
  int get verticalMultiplier {
    switch (this) {
      case AnimationDirection.topToBottom:
        return -1;
      case AnimationDirection.bottomToTop:
        return 1;
      case AnimationDirection.bottomLeftToTopRight:
      case AnimationDirection.bottomRightToTopLeft:
        return 1;
      case AnimationDirection.topLeftToBottomRight:
      case AnimationDirection.topRightToBottomLeft:
        return -1;
      default:
        return 0; // No vertical movement for pure horizontal animations
    }
  }

  /// Helper to determine axis-specific offset
  Offset getOffsetFor(double value) {
    if (isDiagonal) {
      return Offset(value * horizontalMultiplier, value * verticalMultiplier);
    } else if (axis == Axis.horizontal) {
      return Offset(value * horizontalMultiplier, 0);
    } else {
      return Offset(0, value * verticalMultiplier);
    }
  }
}

/// Configuration class for slide animations
class SlideAnimationConfig {
  /// Distance to animate from (null uses screen dimensions)
  final double? distance;

  /// Animation duration
  final Duration duration;

  /// Delay before animation starts
  final Duration delay;

  /// Animation curve for movement
  final Curve slideCurve;

  /// Animation curve for opacity
  final Curve opacityCurve;

  /// Whether to fade in during animation
  final bool withFade;

  /// Percentage of animation duration where fade completes (0.0-1.0)
  final double fadeCompleteAt;

  /// Scale factor during animation (1.0 = no scaling)
  final double? scale;

  /// Whether to apply a slight rotation effect for corner animations
  final bool enhancedCornerEffects;

  const SlideAnimationConfig({
    this.distance,
    this.duration = const Duration(milliseconds: 800),
    this.delay = Duration.zero,
    this.slideCurve = Curves.easeOutCubic,
    this.opacityCurve = Curves.easeOut,
    this.withFade = true,
    this.fadeCompleteAt = 0.65,
    this.scale,
    this.enhancedCornerEffects = false,
  }) : assert(fadeCompleteAt >= 0.0 && fadeCompleteAt <= 1.0,
            'fadeCompleteAt must be between 0.0 and 1.0');

  /// Create a config with fast animation timing
  factory SlideAnimationConfig.fast({
    double? distance,
    Duration delay = Duration.zero,
    bool enhancedCornerEffects = false,
  }) =>
      SlideAnimationConfig(
        distance: distance,
        duration: const Duration(milliseconds: 400),
        delay: delay,
        slideCurve: Curves.easeOutQuint,
        enhancedCornerEffects: enhancedCornerEffects,
      );

  /// Create a config with slow, emphasized animation
  factory SlideAnimationConfig.emphasized({
    double? distance,
    Duration delay = Duration.zero,
    Duration duration = Duration.zero,
    bool enhancedCornerEffects = false,
  }) =>
      SlideAnimationConfig(
        distance: distance,
        duration: const Duration(milliseconds: 1200),
        delay: delay,
        slideCurve: Curves.easeOutCirc,
        fadeCompleteAt: 0.5,
        enhancedCornerEffects: enhancedCornerEffects,
      );

  /// Create a config specifically optimized for corner animations
  factory SlideAnimationConfig.corner({
    double? distance,
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 950),
  }) =>
      SlideAnimationConfig(
        distance: distance,
        duration: duration,
        delay: delay,
        slideCurve: Curves.easeOutBack,
        fadeCompleteAt: 0.7,
        enhancedCornerEffects: true,
      );

  /// Create a config with bouncy effect
  factory SlideAnimationConfig.bouncy({
    double? distance,
    Duration delay = Duration.zero,
  }) =>
      SlideAnimationConfig(
        distance: distance,
        duration: const Duration(milliseconds: 850),
        delay: delay,
        slideCurve: Curves.elasticOut,
        fadeCompleteAt: 0.4,
      );
}

/// A widget that animates its child with a slide and optional fade animation
class CustomAnimatedSlide extends StatefulWidget {
  /// The widget to animate
  final Widget child;

  /// The animation direction
  final AnimationDirection direction;

  /// Animation configuration
  final SlideAnimationConfig config;

  /// Callback for accessing the animation controller
  final Function(AnimationController controller)? onControllerCreated;

  /// Callback after animation completes
  final VoidCallback? onAnimationComplete;

  /// Key for finding this widget
  final Key? widgetKey;

  const CustomAnimatedSlide({
    super.key,
    required this.child,
    required this.direction,
    this.config = const SlideAnimationConfig(),
    this.onControllerCreated,
    this.onAnimationComplete,
    this.widgetKey,
  });

  /// Convenience constructor for corner animations with enhanced visual effects
  factory CustomAnimatedSlide.fromCorner({
    required Widget child,
    required AnimationDirection direction,
    Key? key,
    SlideAnimationConfig? config,
    Function(AnimationController controller)? onControllerCreated,
    VoidCallback? onAnimationComplete,
    Key? widgetKey,
  }) {
    // Validate that a corner direction was provided
    assert(
        direction == AnimationDirection.bottomLeftToTopRight ||
            direction == AnimationDirection.bottomRightToTopLeft ||
            direction == AnimationDirection.topLeftToBottomRight ||
            direction == AnimationDirection.topRightToBottomLeft,
        'AnimatedSlide.fromCorner requires a corner direction');

    return CustomAnimatedSlide(
      key: key,
      child: child,
      direction: direction,
      config: config ?? SlideAnimationConfig.corner(),
      onControllerCreated: onControllerCreated,
      onAnimationComplete: onAnimationComplete,
      widgetKey: widgetKey,
    );
  }

  @override
  State<CustomAnimatedSlide> createState() => _CustomAnimatedSlideState();
}

class _CustomAnimatedSlideState extends State<CustomAnimatedSlide>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideAnimation;
  late Animation<double> _opacityAnimation;
  Animation<double>? _scaleAnimation;
  Animation<double>? _rotationAnimation;
  bool _hasCalculatedDistance = false;
  double _animationDistance = 100.0; // Default fallback value

  @override
  void initState() {
    super.initState();

    // Create animation controller
    _controller = AnimationController(
      duration: widget.config.duration,
      vsync: this,
    );

    // Notify if controller accessor is provided
    if (widget.onControllerCreated != null) {
      widget.onControllerCreated!(_controller);
    }

    // Setup animations
    _setupAnimations();

    // Add completion listener
    _controller.addStatusListener(_handleAnimationStatusChange);

    // Auto-start animation after specified delay
    if (widget.config.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.config.delay, () {
        // Check if widget is still mounted before proceeding
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  void _setupAnimations() {
    // If we have a preconfigured distance, use it directly
    if (widget.config.distance != null) {
      _animationDistance = widget.config.distance!;
      _hasCalculatedDistance = true;
      _createAnimations();
    }
    // Otherwise we'll calculate it in the build method once we have context
  }

  void _createAnimations() {
    // Create the slide animation
    _slideAnimation = Tween<double>(
      begin: _animationDistance,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.config.slideCurve,
      ),
    );

    // Create the opacity animation if fade is enabled
    _opacityAnimation = Tween<double>(
      begin: widget.config.withFade ? 0.0 : 1.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          widget.config.fadeCompleteAt,
          curve: widget.config.opacityCurve,
        ),
      ),
    );

    // Create scale animation if specified in config
    if (widget.config.scale != null) {
      final double beginScale = widget.config.scale!;
      _scaleAnimation = Tween<double>(
        begin: beginScale,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: widget.config.slideCurve,
        ),
      );
    }

    // Create rotation animation for enhanced corner effects
    if (widget.direction.isDiagonal && widget.config.enhancedCornerEffects) {
      // Calculate small rotation for extra visual flair (±5 degrees)
      final double rotationAmount = 5.0 * math.pi / 180.0; // Convert to radians

      // Direction-dependent rotation
      double rotationBegin = 0.0;
      switch (widget.direction) {
        case AnimationDirection.bottomLeftToTopRight:
          rotationBegin = rotationAmount;
          break;
        case AnimationDirection.bottomRightToTopLeft:
          rotationBegin = -rotationAmount;
          break;
        case AnimationDirection.topLeftToBottomRight:
          rotationBegin = -rotationAmount;
          break;
        case AnimationDirection.topRightToBottomLeft:
          rotationBegin = rotationAmount;
          break;
        default:
          rotationBegin = 0.0;
      }

      _rotationAnimation = Tween<double>(
        begin: rotationBegin,
        end: 0.0,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          // Apply rotation only in first 70% of animation
          curve: const Interval(0.0, 0.7, curve: Curves.easeOutCirc),
        ),
      );
    }
  }

  void _handleAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed &&
        widget.onAnimationComplete != null) {
      widget.onAnimationComplete!();
    }
  }

  /// Calculate animation distance based on screen size if needed
  void _calculateAnimationDistanceIfNeeded(BuildContext context) {
    if (_hasCalculatedDistance) return;

    final Size screenSize = MediaQuery.of(context).size;

    // Calculate appropriate animation distance based on direction
    if (widget.direction.isDiagonal) {
      // For diagonal animations, use a distance that looks good visually
      // Calculate using Pythagorean theorem for consistent diagonal distance
      double diagonalDistance = 0.3 *
          math.sqrt(screenSize.width * screenSize.width +
              screenSize.height * screenSize.height);
      _animationDistance =
          diagonalDistance * 0.5; // Scale down a bit for better UX
    } else {
      // For standard animations, use appropriate screen dimension
      _animationDistance = widget.direction.axis == Axis.horizontal
          ? screenSize.width * 0.3 // 30% of screen width for horizontal
          : screenSize.height * 0.3; // 30% of screen height for vertical
    }

    _hasCalculatedDistance = true;
    _createAnimations();

    // If we had to wait for context to calculate the distance and no
    // delay was specified, start the animation now
    if (widget.config.delay == Duration.zero && !_controller.isAnimating) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CustomAnimatedSlide oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the direction or config changed significantly, reset animations
    if (oldWidget.direction != widget.direction ||
        oldWidget.config.distance != widget.config.distance ||
        oldWidget.config.slideCurve != widget.config.slideCurve ||
        oldWidget.config.opacityCurve != widget.config.opacityCurve ||
        oldWidget.config.fadeCompleteAt != widget.config.fadeCompleteAt) {
      _hasCalculatedDistance = widget.config.distance != null;
      if (_hasCalculatedDistance) {
        _animationDistance = widget.config.distance!;
      }
      _createAnimations();
    }

    // Update animation duration if it changed
    if (oldWidget.config.duration != widget.config.duration) {
      _controller.duration = widget.config.duration;
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener(_handleAnimationStatusChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate animation distance if not already done
    _calculateAnimationDistanceIfNeeded(context);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final Offset offset =
            widget.direction.getOffsetFor(_slideAnimation.value);

        Widget result = KeyedSubtree(
          key: widget.widgetKey,
          child: widget.child,
        );

        // Apply opacity
        result = Opacity(
          opacity: _opacityAnimation.value,
          child: result,
        );

        // Apply scale if configured
        if (_scaleAnimation != null) {
          result = Transform.scale(
            scale: _scaleAnimation!.value,
            child: result,
          );
        }

        // Apply rotation for enhanced corner animations
        if (_rotationAnimation != null) {
          result = Transform.rotate(
            angle: _rotationAnimation!.value,
            child: result,
          );
        }

        // Apply translation (must be the outermost transformation)
        result = Transform.translate(
          offset: offset,
          child: result,
        );

        return result;
      },
    );
  }
}
