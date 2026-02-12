import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// ============================================================================
/// ENUMS & EXTENSIONS
/// ============================================================================

enum AnimationDirection {
  leftToRight,
  rightToLeft,
  bottomToTop,
  topToBottom,
  bottomLeftToTopRight,
  bottomRightToTopLeft,
  topLeftToBottomRight,
  topRightToBottomLeft,
}

extension AnimationDirectionUtils on AnimationDirection {
  bool get isDiagonal =>
      this == AnimationDirection.bottomLeftToTopRight ||
      this == AnimationDirection.bottomRightToTopLeft ||
      this == AnimationDirection.topLeftToBottomRight ||
      this == AnimationDirection.topRightToBottomLeft;

  Axis get axis {
    switch (this) {
      case AnimationDirection.leftToRight:
      case AnimationDirection.rightToLeft:
        return Axis.horizontal;
      case AnimationDirection.bottomToTop:
      case AnimationDirection.topToBottom:
        return Axis.vertical;
      default:
        return Axis.horizontal;
    }
  }

  int get horizontalMultiplier {
    switch (this) {
      case AnimationDirection.leftToRight:
        return 1;
      case AnimationDirection.rightToLeft:
        return -1;
      case AnimationDirection.bottomLeftToTopRight:
      case AnimationDirection.topLeftToBottomRight:
        return 1;
      case AnimationDirection.bottomRightToTopLeft:
      case AnimationDirection.topRightToBottomLeft:
        return -1;
      default:
        return 0;
    }
  }

  int get verticalMultiplier {
    switch (this) {
      case AnimationDirection.bottomToTop:
        return 1;
      case AnimationDirection.topToBottom:
        return -1;
      case AnimationDirection.bottomLeftToTopRight:
      case AnimationDirection.bottomRightToTopLeft:
        return 1;
      case AnimationDirection.topLeftToBottomRight:
      case AnimationDirection.topRightToBottomLeft:
        return -1;
      default:
        return 0;
    }
  }

  Offset offsetFor(double distancePx) {
    if (isDiagonal) {
      return Offset(
        distancePx * horizontalMultiplier,
        distancePx * verticalMultiplier,
      );
    }
    if (axis == Axis.horizontal) {
      return Offset(distancePx * horizontalMultiplier, 0);
    }
    return Offset(0, distancePx * verticalMultiplier);
  }
}

enum AnimationTrigger { immediate, onVisible, manual }

enum Transform3DEffect { none, flip, perspective, tilt }

/// ============================================================================
/// EXTERNAL CONTROLLER (manual power)
/// - replay() always works even for onVisible widgets (it is a direct command)
/// ============================================================================

class AnimatedSlideController {
  AnimationController? _c;
  VoidCallback? _forceReplayHook; // set by widget

  bool get isReady => _c != null;
  bool get isAnimating => _c?.isAnimating ?? false;
  bool get isCompleted => _c?.isCompleted ?? false;
  bool get isDismissed => _c?.isDismissed ?? true;
  double get value => _c?.value ?? 0;

  void _attach(AnimationController controller, VoidCallback forceReplayHook) {
    _c = controller;
    _forceReplayHook = forceReplayHook;
  }

  void _detach(AnimationController controller) {
    if (_c == controller) {
      _c = null;
      _forceReplayHook = null;
    }
  }

  Future<void> play({double from = 0.0}) async {
    final c = _c;
    if (c == null) return;
    c.value = from.clamp(0.0, 1.0);
    await c.forward();
  }

  Future<void> reverse({double from = 1.0}) async {
    final c = _c;
    if (c == null) return;
    c.value = from.clamp(0.0, 1.0);
    await c.reverse();
  }

  void stop({bool canceled = true}) => _c?.stop(canceled: canceled);
  void reset() => _c?.reset();

  /// IMPORTANT: replay will always run regardless of onVisible flags.
  Future<void> replay() async {
    _forceReplayHook?.call();
  }

  Future<void> animateTo(
    double target, {
    Duration? duration,
    Curve curve = Curves.linear,
  }) async {
    final c = _c;
    if (c == null) return;
    await c.animateTo(
      target.clamp(0.0, 1.0),
      duration: duration ?? const Duration(milliseconds: 300),
      curve: curve,
    );
  }
}

/// ============================================================================
/// CONFIG
/// ============================================================================

@immutable
class SlideAnimationConfig {
  // Distance
  final double? distance; // px
  final double distanceFactor; // 0..1 of screen dimension

  // Timing
  final Duration duration;
  final Duration delay;
  final Curve slideCurve;

  // Fade
  final bool withFade;
  final Interval fadeIn;
  final Interval? fadeOut;

  // Transform
  final double? beginScale;
  final double? rotateDegrees;
  final Alignment transformAlignment;

  // Trigger
  final AnimationTrigger trigger;
  final double visibilityThreshold; // 0..1
  final Duration visibilityThrottle;

  // Stagger
  final int? staggerIndex;
  final Duration? staggerDelay;

  // Repeat
  final bool repeat;
  final bool reverseRepeat; // yoyo
  final int? repeatCount; // null = infinite

  // NEW: AutoReverse (once) — independent from repeat
  final bool autoReverse;

  // Advanced effects (OFF by default for lists)
  final Transform3DEffect transform3D;
  final double perspectiveDepth;

  final bool enableBlurEffect;
  final double blurAmount;

  // NEW: Real spring physics
  final bool useSpringPhysics;
  final SpringDescription springDescription;

  // Autoplay (only for immediate/onVisible)
  final bool autoplay;

  const SlideAnimationConfig({
    this.distance,
    this.distanceFactor = 0.22,
    this.duration = const Duration(milliseconds: 650),
    this.delay = Duration.zero,
    this.slideCurve = Curves.easeOutCubic,
    this.withFade = true,
    this.fadeIn = const Interval(0.0, 0.65, curve: Curves.easeOut),
    this.fadeOut,
    this.beginScale,
    this.rotateDegrees,
    this.transformAlignment = Alignment.center,
    this.trigger = AnimationTrigger.immediate,
    this.visibilityThreshold = 0.12,
    this.visibilityThrottle = const Duration(milliseconds: 50),
    this.staggerIndex,
    this.staggerDelay,
    this.repeat = false,
    this.reverseRepeat = false,
    this.repeatCount,
    this.autoReverse = false,
    this.transform3D = Transform3DEffect.none,
    this.perspectiveDepth = 0.002,
    this.enableBlurEffect = false,
    this.blurAmount = 8.0,
    this.useSpringPhysics = false,
    this.springDescription = const SpringDescription(
      mass: 1.0,
      stiffness: 120.0,
      damping: 16.0,
    ),
    this.autoplay = true,
  }) : assert(distanceFactor > 0.0 && distanceFactor <= 1.0),
       assert(visibilityThreshold >= 0.0 && visibilityThreshold <= 1.0),
       assert(repeatCount == null || repeatCount > 0);

  Duration get effectiveDelay {
    if (staggerIndex != null && staggerDelay != null) {
      return delay + (staggerDelay! * staggerIndex!);
    }
    return delay;
  }

  factory SlideAnimationConfig.listItem({
    required int index,
    Duration stagger = const Duration(milliseconds: 70),
  }) {
    return SlideAnimationConfig(
      trigger: AnimationTrigger.onVisible,
      duration: const Duration(milliseconds: 520),
      distanceFactor: 0.20,
      withFade: true,
      staggerIndex: index,
      staggerDelay: stagger,
      transform3D: Transform3DEffect.none,
      enableBlurEffect: false,
      useSpringPhysics: false,
    );
  }

  SlideAnimationConfig copyWith({
    double? distance,
    double? distanceFactor,
    Duration? duration,
    Duration? delay,
    Curve? slideCurve,
    bool? withFade,
    Interval? fadeIn,
    Interval? fadeOut,
    double? beginScale,
    double? rotateDegrees,
    Alignment? transformAlignment,
    AnimationTrigger? trigger,
    double? visibilityThreshold,
    Duration? visibilityThrottle,
    int? staggerIndex,
    Duration? staggerDelay,
    bool? repeat,
    bool? reverseRepeat,
    int? repeatCount,
    bool? autoReverse,
    Transform3DEffect? transform3D,
    double? perspectiveDepth,
    bool? enableBlurEffect,
    double? blurAmount,
    bool? useSpringPhysics,
    SpringDescription? springDescription,
    bool? autoplay,
  }) {
    return SlideAnimationConfig(
      distance: distance ?? this.distance,
      distanceFactor: distanceFactor ?? this.distanceFactor,
      duration: duration ?? this.duration,
      delay: delay ?? this.delay,
      slideCurve: slideCurve ?? this.slideCurve,
      withFade: withFade ?? this.withFade,
      fadeIn: fadeIn ?? this.fadeIn,
      fadeOut: fadeOut ?? this.fadeOut,
      beginScale: beginScale ?? this.beginScale,
      rotateDegrees: rotateDegrees ?? this.rotateDegrees,
      transformAlignment: transformAlignment ?? this.transformAlignment,
      trigger: trigger ?? this.trigger,
      visibilityThreshold: visibilityThreshold ?? this.visibilityThreshold,
      visibilityThrottle: visibilityThrottle ?? this.visibilityThrottle,
      staggerIndex: staggerIndex ?? this.staggerIndex,
      staggerDelay: staggerDelay ?? this.staggerDelay,
      repeat: repeat ?? this.repeat,
      reverseRepeat: reverseRepeat ?? this.reverseRepeat,
      repeatCount: repeatCount ?? this.repeatCount,
      autoReverse: autoReverse ?? this.autoReverse,
      transform3D: transform3D ?? this.transform3D,
      perspectiveDepth: perspectiveDepth ?? this.perspectiveDepth,
      enableBlurEffect: enableBlurEffect ?? this.enableBlurEffect,
      blurAmount: blurAmount ?? this.blurAmount,
      useSpringPhysics: useSpringPhysics ?? this.useSpringPhysics,
      springDescription: springDescription ?? this.springDescription,
      autoplay: autoplay ?? this.autoplay,
    );
  }
}

/// ============================================================================
/// VisibilityDetectorLite (FAST, throttled, for long lists)
/// ============================================================================

class _VisibilityDetectorLite extends StatefulWidget {
  final Widget child;
  final Duration throttle;
  final ValueChanged<double> onVisibleFraction;

  const _VisibilityDetectorLite({
    required Key key,
    required this.child,
    required this.throttle,
    required this.onVisibleFraction,
  }) : super(key: key);

  @override
  State<_VisibilityDetectorLite> createState() =>
      _VisibilityDetectorLiteState();
}

class _VisibilityDetectorLiteState extends State<_VisibilityDetectorLite> {
  final GlobalKey _boxKey = GlobalKey();
  Timer? _timer;
  double _last = -1;

  @override
  void initState() {
    super.initState();

    // 1) first check after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());

    // 2) second check shortly after (TabBarView/layout cases)
    Future.delayed(const Duration(milliseconds: 16), () {
      if (mounted) _check();
    });
  }

  @override
  void didUpdateWidget(covariant _VisibilityDetectorLite oldWidget) {
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
    Future.delayed(const Duration(milliseconds: 16), () {
      if (mounted) _check();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _schedule() {
    if (!mounted) return;
    if (_timer?.isActive == true) return;
    _timer = Timer(widget.throttle, _check);
  }

  void _check() {
    if (!mounted) return;

    final ctx = _boxKey.currentContext;
    if (ctx == null) return;

    final ro = ctx.findRenderObject();
    if (ro is! RenderBox || !ro.attached || !ro.hasSize) {
      // try again next frame if layout not ready
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _check();
      });
      return;
    }

    final size = ro.size;
    if (size.isEmpty) {
      // try again shortly if size is still 0
      Future.delayed(const Duration(milliseconds: 16), () {
        if (mounted) _check();
      });
      return;
    }

    final topLeft = ro.localToGlobal(Offset.zero);
    final rect = topLeft & size;

    final media = MediaQuery.of(context);
    final viewport = Rect.fromLTWH(0, 0, media.size.width, media.size.height);

    final inter = rect.intersect(viewport);

    double fraction = 0.0;
    if (!inter.isEmpty) {
      final visibleArea = inter.width * inter.height;
      final totalArea = size.width * size.height;
      fraction = (visibleArea / totalArea).clamp(0.0, 1.0);
    }

    if ((_last - fraction).abs() < 0.02) return;
    _last = fraction;

    widget.onVisibleFraction(fraction);
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (_) {
        _schedule();
        return false;
      },
      child: Container(key: _boxKey, child: widget.child),
    );
  }
}

/// ============================================================================
/// Helpers
/// ============================================================================

class _MinAnimation extends Animation<double>
    with AnimationWithParentMixin<double> {
  final Animation<double> a;
  final Animation<double> b;

  _MinAnimation(this.a, this.b);

  @override
  Animation<double> get parent => a;

  @override
  double get value => math.min(a.value, b.value);

  @override
  void addListener(VoidCallback listener) {
    a.addListener(listener);
    b.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    a.removeListener(listener);
    b.removeListener(listener);
  }

  @override
  void addStatusListener(AnimationStatusListener listener) {
    a.addStatusListener(listener);
    b.addStatusListener(listener);
  }

  @override
  void removeStatusListener(AnimationStatusListener listener) {
    a.removeStatusListener(listener);
    b.removeStatusListener(listener);
  }
}

/// ============================================================================
/// MAIN WIDGET: CustomAnimatedSlide
/// ============================================================================

class CustomAnimatedSlide extends StatefulWidget {
  final Widget child;
  final AnimationDirection direction;
  final SlideAnimationConfig config;

  final AnimatedSlideController? controller;

  final VoidCallback? onStart;
  final VoidCallback? onComplete;
  final VoidCallback? onReverseComplete;
  final ValueChanged<AnimationStatus>? onStatusChanged;

  final bool reanimateOnUpdate;
  final Key? widgetKey;

  const CustomAnimatedSlide({
    super.key,
    required this.child,
    required this.direction,
    this.config = const SlideAnimationConfig(),
    this.controller,
    this.onStart,
    this.onComplete,
    this.onReverseComplete,
    this.onStatusChanged,
    this.reanimateOnUpdate = false,
    this.widgetKey,
  });

  factory CustomAnimatedSlide.listItem({
    Key? key,
    required Widget child,
    required int index,
    AnimationDirection direction = AnimationDirection.bottomToTop,
    SlideAnimationConfig? config,
  }) {
    return CustomAnimatedSlide(
      key: key,
      direction: direction,
      config: (config ?? SlideAnimationConfig.listItem(index: index)),
      child: child,
    );
  }

  @override
  State<CustomAnimatedSlide> createState() => _CustomAnimatedSlideState();
}

class _CustomAnimatedSlideState extends State<CustomAnimatedSlide>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  Animation<double>? _distAnim;
  Animation<double>? _opacityAnim;
  Animation<double>? _scaleAnim;
  Animation<double>? _rotAnim;
  Animation<double>? _perspAnim;

  double _distancePx = 0.0;
  bool _distanceReady = false;

  bool _visibleTriggered = false;
  bool _manualForcedReplay = false;

  int _repeatDone = 0;
  Size? _lastMediaSize;

  @override
  void initState() {
    super.initState();

    _c = AnimationController(duration: widget.config.duration, vsync: this);

    widget.controller?._attach(_c, _forceReplay);

    _c.addStatusListener(_handleStatus);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _ensureDistanceAndCreateAnims();
      _maybeStart();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final size = MediaQuery.sizeOf(context);
    if (_lastMediaSize == null) {
      _lastMediaSize = size;
      return;
    }
    if (_lastMediaSize != size) {
      _lastMediaSize = size;
      if (widget.config.distance == null) {
        _distanceReady = false;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _ensureDistanceAndCreateAnims();
        });
      }
    }
  }

  void _forceReplay() {
    // Manual command must always work (even if onVisible already triggered).
    _manualForcedReplay = true;
    _visibleTriggered = true; // prevent auto-trigger duplication
    _repeatDone = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      if (!_distanceReady) {
        _ensureDistanceAndCreateAnims();
      }
      await _startWithDelay(force: true);
      _manualForcedReplay = false;
    });
  }

  void _handleStatus(AnimationStatus status) {
    widget.onStatusChanged?.call(status);

    if (status == AnimationStatus.completed) {
      widget.onComplete?.call();

      // autoReverse once (only when not repeating)
      if (widget.config.autoReverse && !widget.config.repeat) {
        _c.reverse(from: 1.0);
        return;
      }

      if (!widget.config.repeat) return;

      if (!widget.config.reverseRepeat) {
        _repeatDone++;
        final max = widget.config.repeatCount;
        final canContinue = max == null || _repeatDone < max;
        if (canContinue && mounted) {
          _runForward(from: 0.0); // repeat forward
        }
      } else {
        // yoyo: reverse after forward completes
        if (mounted) {
          _c.reverse(from: 1.0);
        }
      }
    }

    if (status == AnimationStatus.dismissed) {
      widget.onReverseComplete?.call();

      if (widget.config.repeat && widget.config.reverseRepeat) {
        _repeatDone++;
        final max = widget.config.repeatCount;
        final canContinue = max == null || _repeatDone < max;
        if (canContinue && mounted) {
          _runForward(from: 0.0); // next yoyo cycle
        }
      }
    }
  }

  void _ensureDistanceAndCreateAnims() {
    if (_distanceReady) return;

    final cfg = widget.config;
    if (cfg.distance != null) {
      _distancePx = cfg.distance!;
    } else {
      final size = MediaQuery.sizeOf(context);
      if (widget.direction.isDiagonal) {
        final diag = math.sqrt(
          size.width * size.width + size.height * size.height,
        );
        _distancePx = diag * cfg.distanceFactor * 0.6;
      } else {
        _distancePx =
            (widget.direction.axis == Axis.horizontal
                ? size.width
                : size.height) *
            cfg.distanceFactor;
      }
    }

    _distanceReady = true;
    _createAnimations();
    if (mounted) setState(() {});
  }

  void _createAnimations() {
    final cfg = widget.config;

    _distAnim = Tween<double>(
      begin: _distancePx,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _c, curve: cfg.slideCurve));

    // Opacity (fade in/out)
    if (cfg.withFade) {
      final fadeInAnim = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: _c, curve: cfg.fadeIn));

      if (cfg.fadeOut != null) {
        final fadeOutAnim = Tween<double>(
          begin: 1.0,
          end: 0.0,
        ).animate(CurvedAnimation(parent: _c, curve: cfg.fadeOut!));
        _opacityAnim = _MinAnimation(fadeInAnim, fadeOutAnim);
      } else {
        _opacityAnim = fadeInAnim;
      }
    } else {
      _opacityAnim = const AlwaysStoppedAnimation(1.0);
    }

    // Scale
    if (cfg.beginScale != null) {
      _scaleAnim = Tween<double>(
        begin: cfg.beginScale!,
        end: 1.0,
      ).animate(CurvedAnimation(parent: _c, curve: cfg.slideCurve));
    } else {
      _scaleAnim = null;
    }

    // Rotation
    if (cfg.rotateDegrees != null && cfg.rotateDegrees != 0) {
      final radians = cfg.rotateDegrees!.abs() * math.pi / 180.0;
      final sign =
          widget.direction.horizontalMultiplier +
          widget.direction.verticalMultiplier;
      final begin = (sign >= 0) ? radians : -radians;

      _rotAnim = Tween<double>(begin: begin, end: 0.0).animate(
        CurvedAnimation(
          parent: _c,
          curve: const Interval(0.0, 0.7, curve: Curves.easeOutCirc),
        ),
      );
    } else {
      _rotAnim = null;
    }

    // 3D
    if (cfg.transform3D != Transform3DEffect.none) {
      _perspAnim = Tween<double>(
        begin: math.pi / 2,
        end: 0.0,
      ).animate(CurvedAnimation(parent: _c, curve: cfg.slideCurve));
    } else {
      _perspAnim = null;
    }
  }

  Future<void> _maybeStart() async {
    final cfg = widget.config;

    if (cfg.trigger == AnimationTrigger.manual) return;

    if (cfg.trigger == AnimationTrigger.immediate) {
      if (!cfg.autoplay) return;
      await _startWithDelay(force: false);
    }
    // onVisible handled by detector
  }

  Future<void> _startWithDelay({required bool force}) async {
    // force=true means explicit manual replay; it should always run
    if (!force && widget.config.trigger == AnimationTrigger.manual) return;

    final delay = widget.config.effectiveDelay;
    if (delay != Duration.zero) {
      await Future.delayed(delay);
      if (!mounted) return;
    }

    widget.onStart?.call();

    _repeatDone = 0;

    // reset + run forward from 0
    _c.stop();
    _c.value = 0.0;

    await _runForward(from: 0.0);
  }

  Future<void> _runForward({required double from}) async {
    _c.stop();
    _c.value = from.clamp(0.0, 1.0);

    if (widget.config.useSpringPhysics) {
      // Real physics-based spring
      final sim = SpringSimulation(
        widget.config.springDescription,
        _c.value,
        1.0,
        0.0,
      );
      await _c.animateWith(sim);
      return;
    }

    await _c.forward(from: _c.value);
  }

  void _onVisible(double fraction) {
    if (widget.config.trigger != AnimationTrigger.onVisible) return;
    if (!widget.config.autoplay) return;

    // if manual replay is running, ignore auto triggers
    if (_manualForcedReplay) return;

    if (_visibleTriggered) return;
    if (fraction < widget.config.visibilityThreshold) return;

    _visibleTriggered = true;
    _startWithDelay(force: false);
  }

  Widget _apply3D(Widget child) {
    final cfg = widget.config;
    if (cfg.transform3D == Transform3DEffect.none || _perspAnim == null)
      return child;

    final m = Matrix4.identity()..setEntry(3, 2, cfg.perspectiveDepth);

    switch (cfg.transform3D) {
      case Transform3DEffect.flip:
        if (widget.direction.axis == Axis.horizontal) {
          m.rotateY(_perspAnim!.value);
        } else {
          m.rotateX(_perspAnim!.value);
        }
        break;
      case Transform3DEffect.perspective:
        m
          ..rotateX(_perspAnim!.value * 0.3)
          ..rotateY(_perspAnim!.value * 0.3);
        break;
      case Transform3DEffect.tilt:
        m.rotateZ(_perspAnim!.value * 0.2);
        break;
      default:
        break;
    }

    return Transform(
      transform: m,
      alignment: cfg.transformAlignment,
      child: child,
    );
  }

  Widget _applyBlur(Widget child) {
    final cfg = widget.config;
    if (!cfg.enableBlurEffect) return child;

    // Guard: blur is heavy — keep OFF for long lists unless only a few items
    final blurValue = cfg.blurAmount * (1.0 - _c.value);
    if (blurValue < 0.6) return child;

    return ImageFiltered(
      imageFilter: ui.ImageFilter.blur(sigmaX: blurValue, sigmaY: blurValue),
      child: child,
    );
  }

  @override
  void didUpdateWidget(covariant CustomAnimatedSlide oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?._detach(_c);
      widget.controller?._attach(_c, _forceReplay);
    }

    if (oldWidget.config.duration != widget.config.duration) {
      _c.duration = widget.config.duration;
    }

    final changed =
        oldWidget.direction != widget.direction ||
        oldWidget.config.distance != widget.config.distance ||
        oldWidget.config.distanceFactor != widget.config.distanceFactor ||
        oldWidget.config.slideCurve != widget.config.slideCurve ||
        oldWidget.config.withFade != widget.config.withFade ||
        oldWidget.config.fadeIn != widget.config.fadeIn ||
        oldWidget.config.fadeOut != widget.config.fadeOut ||
        oldWidget.config.beginScale != widget.config.beginScale ||
        oldWidget.config.rotateDegrees != widget.config.rotateDegrees ||
        oldWidget.config.transform3D != widget.config.transform3D ||
        oldWidget.config.perspectiveDepth != widget.config.perspectiveDepth ||
        oldWidget.config.enableBlurEffect != widget.config.enableBlurEffect ||
        oldWidget.config.blurAmount != widget.config.blurAmount ||
        oldWidget.config.useSpringPhysics != widget.config.useSpringPhysics ||
        oldWidget.config.springDescription != widget.config.springDescription ||
        oldWidget.config.trigger != widget.config.trigger ||
        oldWidget.config.visibilityThreshold !=
            widget.config.visibilityThreshold ||
        oldWidget.config.visibilityThrottle !=
            widget.config.visibilityThrottle ||
        oldWidget.config.staggerIndex != widget.config.staggerIndex ||
        oldWidget.config.staggerDelay != widget.config.staggerDelay ||
        oldWidget.config.repeat != widget.config.repeat ||
        oldWidget.config.reverseRepeat != widget.config.reverseRepeat ||
        oldWidget.config.repeatCount != widget.config.repeatCount ||
        oldWidget.config.autoReverse != widget.config.autoReverse ||
        oldWidget.config.autoplay != widget.config.autoplay;

    if (changed) {
      _distanceReady = false;
      _visibleTriggered = false;
      _repeatDone = 0;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _ensureDistanceAndCreateAnims();
        if (widget.reanimateOnUpdate && widget.controller != null) {
          widget.controller!.replay();
        }
      });
    }
  }

  @override
  void dispose() {
    widget.controller?._detach(_c);
    _c.removeStatusListener(_handleStatus);
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final needsVisible = widget.config.trigger == AnimationTrigger.onVisible;

    // Important: for onVisible, wrap even before distance is ready
    if (!_distanceReady || _distAnim == null || _opacityAnim == null) {
      if (needsVisible) {
        return _VisibilityDetectorLite(
          key: widget.key ?? UniqueKey(),
          throttle: widget.config.visibilityThrottle,
          onVisibleFraction: _onVisible,
          child: widget.child,
        );
      }
      return widget.child;
    }

    final cachedChild = KeyedSubtree(
      key: widget.widgetKey,
      child: widget.child,
    );

    Widget animated = AnimatedBuilder(
      animation: _c,
      child: cachedChild, // ✅ cached: no rebuild each frame
      builder: (context, child) {
        final offset = widget.direction.offsetFor(_distAnim!.value);

        Widget result = child!;

        // 3D (optional)
        result = _apply3D(result);

        // Opacity
        result = Opacity(opacity: _opacityAnim!.value, child: result);

        // Scale
        if (_scaleAnim != null) {
          result = Transform.scale(
            scale: _scaleAnim!.value,
            alignment: widget.config.transformAlignment,
            child: result,
          );
        }

        // Rotation
        if (_rotAnim != null) {
          result = Transform.rotate(
            angle: _rotAnim!.value,
            alignment: widget.config.transformAlignment,
            child: result,
          );
        }

        // Blur (optional)
        result = _applyBlur(result);

        // Translate outermost
        result = Transform.translate(offset: offset, child: result);

        return RepaintBoundary(child: result);
      },
    );

    if (needsVisible) {
      return _VisibilityDetectorLite(
        key: widget.key ?? UniqueKey(),
        throttle: widget.config.visibilityThrottle,
        onVisibleFraction: _onVisible,
        child: animated,
      );
    }

    return animated;
  }
}

class CustomAnimatedSlideShowcasePage extends StatefulWidget {
  const CustomAnimatedSlideShowcasePage({super.key});

  @override
  State<CustomAnimatedSlideShowcasePage> createState() =>
      _CustomAnimatedSlideShowcasePageState();
}

class _CustomAnimatedSlideShowcasePageState
    extends State<CustomAnimatedSlideShowcasePage> {
  final AnimatedSlideController _manualCtrl = AnimatedSlideController();
  int _tick = 0;

  void _rebuildToReplayAll() => setState(() => _tick++);

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CustomAnimatedSlide — Full Showcase'),
          actions: [
            IconButton(
              tooltip: 'Replay (rebuild samples)',
              onPressed: _rebuildToReplayAll,
              icon: const Icon(Icons.replay),
            ),
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Basics'),
              Tab(text: 'Effects'),
              Tab(text: 'Physics'),
              Tab(text: 'Manual'),
              Tab(text: 'Long List'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _tabBasics(context, t),
            _tabEffects(context, t),
            _tabPhysics(context, t),
            _tabManual(context, t),
            _tabLongList(context, t),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 1: Basics (directions + diagonal + delay)
  // ---------------------------------------------------------------------------

  Widget _tabBasics(BuildContext context, ThemeData t) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _H(
          title: 'Directions (immediate)',
          sub: 'Left/Right/Up/Down + 4 diagonals',
        ),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _demoBox(
              label: 'RTL',
              child: CustomAnimatedSlide(
                key: ValueKey('b-rtl-$_tick'),
                direction: AnimationDirection.rightToLeft,
                config: const SlideAnimationConfig(
                  trigger: AnimationTrigger.immediate,
                  duration: Duration(milliseconds: 650),
                  distanceFactor: 0.22,
                  withFade: true,
                ),
                child: const _Box(text: 'RTL'),
              ),
            ),
            _demoBox(
              label: 'LTR',
              child: CustomAnimatedSlide(
                key: ValueKey('b-ltr-$_tick'),
                direction: AnimationDirection.leftToRight,
                config: const SlideAnimationConfig(
                  trigger: AnimationTrigger.immediate,
                  duration: Duration(milliseconds: 650),
                  distanceFactor: 0.22,
                  withFade: true,
                ),
                child: const _Box(text: 'LTR'),
              ),
            ),
            _demoBox(
              label: 'BTT',
              child: CustomAnimatedSlide(
                key: ValueKey('b-btt-$_tick'),
                direction: AnimationDirection.bottomToTop,
                config: const SlideAnimationConfig(
                  trigger: AnimationTrigger.immediate,
                  duration: Duration(milliseconds: 650),
                  distanceFactor: 0.22,
                  withFade: true,
                ),
                child: const _Box(text: 'BTT'),
              ),
            ),
            _demoBox(
              label: 'TTB',
              child: CustomAnimatedSlide(
                key: ValueKey('b-ttb-$_tick'),
                direction: AnimationDirection.topToBottom,
                config: const SlideAnimationConfig(
                  trigger: AnimationTrigger.immediate,
                  duration: Duration(milliseconds: 650),
                  distanceFactor: 0.22,
                  withFade: true,
                ),
                child: const _Box(text: 'TTB'),
              ),
            ),
            _demoBox(
              label: 'BL→TR',
              child: CustomAnimatedSlide(
                key: ValueKey('b-bltr-$_tick'),
                direction: AnimationDirection.bottomLeftToTopRight,
                config: const SlideAnimationConfig(
                  trigger: AnimationTrigger.immediate,
                  duration: Duration(milliseconds: 720),
                  distanceFactor: 0.25,
                  withFade: true,
                ),
                child: const _Box(text: 'BL→TR'),
              ),
            ),
            _demoBox(
              label: 'BR→TL',
              child: CustomAnimatedSlide(
                key: ValueKey('b-brtl-$_tick'),
                direction: AnimationDirection.bottomRightToTopLeft,
                config: const SlideAnimationConfig(
                  trigger: AnimationTrigger.immediate,
                  duration: Duration(milliseconds: 720),
                  distanceFactor: 0.25,
                  withFade: true,
                ),
                child: const _Box(text: 'BR→TL'),
              ),
            ),
            _demoBox(
              label: 'TL→BR',
              child: CustomAnimatedSlide(
                key: ValueKey('b-tlbr-$_tick'),
                direction: AnimationDirection.topLeftToBottomRight,
                config: const SlideAnimationConfig(
                  trigger: AnimationTrigger.immediate,
                  duration: Duration(milliseconds: 720),
                  distanceFactor: 0.25,
                  withFade: true,
                ),
                child: const _Box(text: 'TL→BR'),
              ),
            ),
            _demoBox(
              label: 'TR→BL',
              child: CustomAnimatedSlide(
                key: ValueKey('b-trbl-$_tick'),
                direction: AnimationDirection.topRightToBottomLeft,
                config: const SlideAnimationConfig(
                  trigger: AnimationTrigger.immediate,
                  duration: Duration(milliseconds: 720),
                  distanceFactor: 0.25,
                  withFade: true,
                ),
                child: const _Box(text: 'TR→BL'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        _H(title: 'Delay', sub: 'Start after delay'),
        Align(
          alignment: Alignment.centerLeft,
          child: CustomAnimatedSlide(
            key: ValueKey('b-delay-$_tick'),
            direction: AnimationDirection.rightToLeft,
            config: const SlideAnimationConfig(
              trigger: AnimationTrigger.immediate,
              delay: Duration(milliseconds: 400),
              duration: Duration(milliseconds: 700),
              distanceFactor: 0.24,
              withFade: true,
            ),
            child: const _Box(text: 'DELAY 400ms'),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 2: Effects (fade out, scale, rotation, 3D, blur)
  // ---------------------------------------------------------------------------

  Widget _tabEffects(BuildContext context, ThemeData t) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _H(
          title: 'Fade In + Fade Out',
          sub: 'fadeOut makes it disappear near the end',
        ),
        _demoRow(
          children: [
            CustomAnimatedSlide(
              key: ValueKey('fx-fadeout-$_tick'),
              direction: AnimationDirection.rightToLeft,
              config: const SlideAnimationConfig(
                trigger: AnimationTrigger.immediate,
                duration: Duration(milliseconds: 950),
                distanceFactor: 0.22,
                withFade: true,
                fadeIn: Interval(0.0, 0.45, curve: Curves.easeOut),
                fadeOut: Interval(0.75, 1.0, curve: Curves.easeIn),
              ),
              child: const _Box(text: 'FadeOut'),
            ),
            CustomAnimatedSlide(
              key: ValueKey('fx-scale-$_tick'),
              direction: AnimationDirection.bottomToTop,
              config: const SlideAnimationConfig(
                trigger: AnimationTrigger.immediate,
                duration: Duration(milliseconds: 750),
                distanceFactor: 0.22,
                withFade: true,
                beginScale: 0.92,
              ),
              child: const _Box(text: 'Scale'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _H(
          title: 'Rotation + Scale',
          sub: 'Rotation is direction-aware (nice corner effect)',
        ),
        _demoRow(
          children: [
            CustomAnimatedSlide(
              key: ValueKey('fx-rot-$_tick'),
              direction: AnimationDirection.bottomLeftToTopRight,
              config: const SlideAnimationConfig(
                trigger: AnimationTrigger.immediate,
                duration: Duration(milliseconds: 820),
                distanceFactor: 0.25,
                withFade: true,
                beginScale: 0.94,
                rotateDegrees: 7,
              ),
              child: const _Box(text: 'Rotate'),
            ),
            CustomAnimatedSlide(
              key: ValueKey('fx-autorv-$_tick'),
              direction: AnimationDirection.leftToRight,
              config: const SlideAnimationConfig(
                trigger: AnimationTrigger.immediate,
                duration: Duration(milliseconds: 650),
                distanceFactor: 0.20,
                withFade: true,
                autoReverse: true, // ✅ once
              ),
              child: const _Box(text: 'AutoReverse'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _H(
          title: '3D Transform',
          sub: 'Use on few widgets (not for every list item)',
        ),
        _demoRow(
          children: [
            CustomAnimatedSlide(
              key: ValueKey('fx-3d-flip-$_tick'),
              direction: AnimationDirection.rightToLeft,
              config: const SlideAnimationConfig(
                trigger: AnimationTrigger.immediate,
                duration: Duration(milliseconds: 900),
                distanceFactor: 0.20,
                transform3D: Transform3DEffect.flip,
                perspectiveDepth: 0.003,
                withFade: true,
              ),
              child: const _Box(text: 'Flip 3D'),
            ),
            CustomAnimatedSlide(
              key: ValueKey('fx-3d-persp-$_tick'),
              direction: AnimationDirection.bottomToTop,
              config: const SlideAnimationConfig(
                trigger: AnimationTrigger.immediate,
                duration: Duration(milliseconds: 900),
                distanceFactor: 0.20,
                transform3D: Transform3DEffect.perspective,
                perspectiveDepth: 0.0025,
                withFade: true,
              ),
              child: const _Box(text: 'Perspective'),
            ),
            CustomAnimatedSlide(
              key: ValueKey('fx-3d-tilt-$_tick'),
              direction: AnimationDirection.bottomLeftToTopRight,
              config: const SlideAnimationConfig(
                trigger: AnimationTrigger.immediate,
                duration: Duration(milliseconds: 900),
                distanceFactor: 0.25,
                transform3D: Transform3DEffect.tilt,
                perspectiveDepth: 0.002,
                withFade: true,
              ),
              child: const _Box(text: 'Tilt'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _H(
          title: 'Blur (heavier)',
          sub: 'Keep OFF in long lists unless for few items',
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: CustomAnimatedSlide(
            key: ValueKey('fx-blur-$_tick'),
            direction: AnimationDirection.leftToRight,
            config: const SlideAnimationConfig(
              trigger: AnimationTrigger.immediate,
              duration: Duration(milliseconds: 650),
              distanceFactor: 0.22,
              withFade: true,
              enableBlurEffect: true,
              blurAmount: 10,
            ),
            child: const _Box(text: 'Blur'),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 3: Physics + Repeat
  // ---------------------------------------------------------------------------

  Widget _tabPhysics(BuildContext context, ThemeData t) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _H(
          title: 'Real Spring Physics (SpringSimulation)',
          sub: 'Natural motion — physics driven',
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: CustomAnimatedSlide(
            key: ValueKey('ph-spring-$_tick'),
            direction: AnimationDirection.rightToLeft,
            config: const SlideAnimationConfig(
              trigger: AnimationTrigger.immediate,
              useSpringPhysics: true,
              springDescription: SpringDescription(
                mass: 1.0,
                stiffness: 120.0,
                damping: 16.0,
              ),
              distanceFactor: 0.24,
              withFade: true,
            ),
            child: const _Box(text: 'SPRING'),
          ),
        ),
        const SizedBox(height: 16),
        _H(title: 'Repeat / YoYo', sub: 'repeat + reverseRepeat + repeatCount'),
        _demoRow(
          children: [
            CustomAnimatedSlide(
              key: ValueKey('ph-repeat-$_tick'),
              direction: AnimationDirection.leftToRight,
              config: const SlideAnimationConfig(
                trigger: AnimationTrigger.immediate,
                repeat: true,
                reverseRepeat: false,
                repeatCount: 3, // forward 3 times
                duration: Duration(milliseconds: 420),
                distanceFactor: 0.20,
                withFade: true,
              ),
              child: const _Box(text: 'Repeat x3'),
            ),
            CustomAnimatedSlide(
              key: ValueKey('ph-yoyo-$_tick'),
              direction: AnimationDirection.bottomToTop,
              config: const SlideAnimationConfig(
                trigger: AnimationTrigger.immediate,
                repeat: true,
                reverseRepeat: true,
                repeatCount: null, // infinite
                duration: Duration(milliseconds: 600),
                distanceFactor: 0.18,
                withFade: true,
              ),
              child: const _Box(text: 'YoYo ∞'),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 4: Manual controller (play/reverse/replay/animateTo)
  // ---------------------------------------------------------------------------

  Widget _tabManual(BuildContext context, ThemeData t) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _H(
          title: 'Manual trigger + Controller',
          sub: 'play / reverse / replay / animateTo',
        ),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: () => _manualCtrl.play(from: 0),
              icon: const Icon(Icons.play_arrow),
              label: const Text('Play'),
            ),
            OutlinedButton.icon(
              onPressed: () => _manualCtrl.reverse(from: 1),
              icon: const Icon(Icons.undo),
              label: const Text('Reverse'),
            ),
            OutlinedButton.icon(
              onPressed: () => _manualCtrl.replay(),
              icon: const Icon(Icons.replay),
              label: const Text('Replay'),
            ),
            OutlinedButton.icon(
              onPressed: () => _manualCtrl.animateTo(
                0.5,
                duration: const Duration(milliseconds: 350),
              ),
              icon: const Icon(Icons.tune),
              label: const Text('AnimateTo 0.5'),
            ),
            OutlinedButton.icon(
              onPressed: () => _manualCtrl.reset(),
              icon: const Icon(Icons.restart_alt),
              label: const Text('Reset'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Align(
          alignment: Alignment.centerLeft,
          child: CustomAnimatedSlide(
            key: ValueKey('man-$_tick'),
            controller: _manualCtrl,
            direction: AnimationDirection.topRightToBottomLeft,
            config: const SlideAnimationConfig(
              trigger: AnimationTrigger.manual, // ✅ manual
              duration: Duration(milliseconds: 800),
              distanceFactor: 0.25,
              withFade: true,
              beginScale: 0.95,
              rotateDegrees: 7,
              transform3D: Transform3DEffect.tilt,
              perspectiveDepth: 0.002,
            ),
            child: const _Box(text: 'MANUAL'),
          ),
        ),
        const SizedBox(height: 14),
        _H(
          title: 'Manual replay won’t break onVisible',
          sub: 'This is why replay uses a direct hook (always works).',
        ),
        const Text(
          '✅ You can call controller.replay() even if trigger is onVisible in other widgets.',
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 5: Long List (onVisible + stagger)
  // ---------------------------------------------------------------------------

  Widget _tabLongList(BuildContext context, ThemeData t) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 40,
      itemBuilder: (context, i) {
        // Stagger + onVisible preset (safe & fast)
        final cfg = SlideAnimationConfig.listItem(index: i).copyWith(
          // if you want fadeOut too:
          // fadeOut: const Interval(0.92, 1.0, curve: Curves.easeIn),
          // keep heavy effects OFF in list:
          transform3D: Transform3DEffect.none,
          enableBlurEffect: false,
        );

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CustomAnimatedSlide(
            key: ValueKey('list-$i-$_tick'),
            direction: (i % 2 == 0)
                ? AnimationDirection.rightToLeft
                : AnimationDirection.leftToRight,
            config: cfg,
            child: _Tile(text: 'List item #${i + 1} (onVisible + stagger)'),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers UI
  // ---------------------------------------------------------------------------

  Widget _demoBox({required String label, required Widget child}) {
    return SizedBox(
      width: 180,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black12),
            ),
            child: Center(child: child),
          ),
        ],
      ),
    );
  }

  Widget _demoRow({required List<Widget> children}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: children
            .map(
              (w) =>
                  Padding(padding: const EdgeInsets.only(right: 12), child: w),
            )
            .toList(),
      ),
    );
  }
}

class _H extends StatelessWidget {
  final String title;
  final String sub;

  const _H({required this.title, required this.sub});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: t.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            sub,
            style: t.textTheme.bodyMedium?.copyWith(color: t.hintColor),
          ),
        ],
      ),
    );
  }
}

class _Box extends StatelessWidget {
  final String text;
  const _Box({required this.text});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      width: 120,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(
        text,
        style: t.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final String text;
  const _Tile({required this.text});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Text(text, style: t.textTheme.titleMedium),
    );
  }
}
