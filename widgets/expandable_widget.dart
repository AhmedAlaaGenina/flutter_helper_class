import 'package:flutter/material.dart';

/// Controller interface for programmatic control of ExpandableWidget
abstract class ExpandableController {
  /// Current expansion state
  bool get isExpanded;

  /// Animation controller for advanced control
  AnimationController get animationController;

  /// Expand the widget
  Future<void> expand();

  /// Collapse the widget
  Future<void> collapse();

  /// Toggle expansion state
  Future<void> toggle();

  /// Set expansion state directly
  Future<void> setExpanded(bool expanded);
}

/// Public interface for ExpandableWidget's state
/// This allows for strongly typed GlobalKey access
abstract class ExpandableWidgetState extends State<ExpandableWidget>
    implements ExpandableController {}

/// Callback types for type safety
typedef ExpandableStateCallback = void Function(bool isExpanded);
typedef ExpandableControllerCallback =
    void Function(ExpandableController controller);

/// Mixin for ExpandableWidget state management
mixin ExpandableControllerMixin on State<ExpandableWidget>
    implements ExpandableController {
  @override
  bool get isExpanded;

  @override
  AnimationController get animationController;

  @override
  Future<void> expand();

  @override
  Future<void> collapse();

  @override
  Future<void> toggle();

  @override
  Future<void> setExpanded(bool expanded);
}

/// Configuration for animations in the ExpandableWidget
class ExpandableAnimationConfig {
  /// Duration for all animations
  final Duration duration;

  /// Curve for content size transition
  final Curve sizeCurve;

  /// Curve for content opacity transition
  final Curve opacityCurve;

  /// Curve for icon rotation transition
  final Curve rotationCurve;

  /// Curve for header scale transition
  final Curve scaleCurve;

  /// Whether to enable content opacity animation
  final bool enableOpacityAnimation;

  /// Whether to enable icon rotation animation
  final bool enableRotationAnimation;

  /// Whether to enable header scale animation
  final bool enableScaleAnimation;

  /// Whether to enable slide animation for content
  final bool enableSlideAnimation;

  const ExpandableAnimationConfig({
    this.duration = const Duration(milliseconds: 300),
    this.sizeCurve = Curves.easeInOutCubic,
    this.opacityCurve = Curves.easeOutQuart,
    this.rotationCurve = Curves.easeInOutCubic,
    this.scaleCurve = Curves.easeOut,
    this.enableOpacityAnimation = true,
    this.enableRotationAnimation = true,
    this.enableScaleAnimation = true,
    this.enableSlideAnimation = true,
  });
}

/// Ultimate ExpandableWidget with all features and strong typing
class ExpandableWidget extends StatefulWidget {
  /// Header widget that acts as the toggle trigger
  final Widget headerWidget;

  /// List of widgets to show when expanded
  final List<Widget> expandedChildren;

  /// Configuration for all animations
  final ExpandableAnimationConfig animationConfig;

  /// Initial expansion state
  final bool initiallyExpanded;

  /// Padding around the entire widget
  final EdgeInsets padding;

  /// Margin around the entire widget
  final EdgeInsets margin;

  /// Padding specifically for the header
  final EdgeInsets headerPadding;

  /// Fixed width for the widget (null = full width)
  final double? width;

  /// Spacing between expanded children
  final double childrenSpacing;

  /// Callback when expansion state changes
  final ExpandableStateCallback? onToggle;

  /// Callback to receive controller instance for external control
  final ExpandableControllerCallback? onControllerCreated;

  /// Whether the header should be clickable
  final bool headerClickable;

  /// Custom decoration for the entire widget
  final BoxDecoration? decoration;

  /// Custom header decoration
  final BoxDecoration? headerDecoration;

  /// Custom expanded content decoration
  final BoxDecoration? expandedDecoration;

  /// Content padding for the expanded area
  final EdgeInsets contentPadding;

  /// Alignment for the expanded content
  final CrossAxisAlignment expandedAlignment;

  /// Whether to maintain state when parent rebuilds
  final bool maintainState;

  /// Minimum height for the expanded section
  final double? minExpandedHeight;

  /// Maximum height for the expanded section
  final double? maxExpandedHeight;

  /// Whether to clip the expanded content
  final bool clipExpanded;

  /// Scroll physics for expanded content (if scrollable)
  final ScrollPhysics? scrollPhysics;

  /// Builder for the leading icon (left side of header)
  final Widget Function(
    bool isExpanded,
    Animation<double> animation,
    VoidCallback toggle,
  )?
  leadingIconBuilder;

  /// Builder for the trailing icon (right side of header)
  final Widget Function(
    bool isExpanded,
    Animation<double> animation,
    VoidCallback toggle,
  )?
  trailingIconBuilder;

  /// Whether to show a divider between header and content
  final bool showDivider;

  /// Divider color and thickness
  final Color? dividerColor;
  final double dividerThickness;

  /// Semantic label for accessibility
  final String? semanticLabel;

  /// Whether the widget is enabled
  final bool enabled;

  /// Whether the content is in a loading state
  final bool isLoading;

  /// Custom loading indicator widget
  final Widget? loadingIndicator;

  /// Section ID for use with accordion controller
  final String? sectionId;

  /// Accordion controller for managing multiple widgets
  final AccordionController? accordionController;

  const ExpandableWidget({
    super.key,
    required this.headerWidget,
    required this.expandedChildren,
    this.animationConfig = const ExpandableAnimationConfig(),
    this.initiallyExpanded = false,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.headerPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    this.contentPadding = const EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 16,
    ),
    this.childrenSpacing = 8.0,
    this.width,
    this.onToggle,
    this.onControllerCreated,
    this.headerClickable = true,
    this.decoration,
    this.headerDecoration,
    this.expandedDecoration,
    this.expandedAlignment = CrossAxisAlignment.stretch,
    this.maintainState = true,
    this.minExpandedHeight,
    this.maxExpandedHeight,
    this.clipExpanded = true,
    this.scrollPhysics,
    this.leadingIconBuilder,
    this.trailingIconBuilder,
    this.showDivider = false,
    this.dividerColor,
    this.dividerThickness = 1.0,
    this.semanticLabel,
    this.enabled = true,
    this.isLoading = false,
    this.loadingIndicator,
    this.sectionId,
    this.accordionController,
  }) : assert(childrenSpacing >= 0),
       assert(dividerThickness >= 0),
       assert(minExpandedHeight == null || minExpandedHeight >= 0),
       assert(maxExpandedHeight == null || maxExpandedHeight >= 0),
       assert(
         maxExpandedHeight == null ||
             minExpandedHeight == null ||
             maxExpandedHeight >= minExpandedHeight,
       ),
       assert(
         accordionController == null || sectionId != null,
         'sectionId must be provided when using an accordionController',
       );

  /// Creates an ExpandableWidget with a builder pattern
  /// This allows for more complex construction scenarios
  factory ExpandableWidget.builder({
    Key? key,
    required Widget headerWidget,
    required WidgetBuilder contentBuilder,
    ExpandableAnimationConfig animationConfig =
        const ExpandableAnimationConfig(),
    bool initiallyExpanded = false,
    EdgeInsets margin = EdgeInsets.zero,
    EdgeInsets padding = EdgeInsets.zero,
    EdgeInsets headerPadding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ),
    EdgeInsets contentPadding = const EdgeInsets.symmetric(
      vertical: 8,
      horizontal: 16,
    ),
    double childrenSpacing = 8.0,
    double? width,
    ExpandableStateCallback? onToggle,
    ExpandableControllerCallback? onControllerCreated,
    bool headerClickable = true,
    BoxDecoration? decoration,
    BoxDecoration? headerDecoration,
    BoxDecoration? expandedDecoration,
    CrossAxisAlignment expandedAlignment = CrossAxisAlignment.stretch,
    bool maintainState = true,
    double? minExpandedHeight,
    double? maxExpandedHeight,
    bool clipExpanded = true,
    ScrollPhysics? scrollPhysics,
    Widget Function(
      bool isExpanded,
      Animation<double> animation,
      VoidCallback toggle,
    )?
    leadingIconBuilder,
    Widget Function(
      bool isExpanded,
      Animation<double> animation,
      VoidCallback toggle,
    )?
    trailingIconBuilder,
    bool showDivider = false,
    Color? dividerColor,
    double dividerThickness = 1.0,
    String? semanticLabel,
    bool enabled = true,
    bool isLoading = false,
    Widget? loadingIndicator,
    String? sectionId,
    AccordionController? accordionController,
  }) {
    return ExpandableWidget(
      key: key,
      headerWidget: headerWidget,
      expandedChildren: [Builder(builder: contentBuilder)],
      animationConfig: animationConfig,
      initiallyExpanded: initiallyExpanded,
      margin: margin,
      padding: padding,
      headerPadding: headerPadding,
      contentPadding: contentPadding,
      childrenSpacing: childrenSpacing,
      width: width,
      onToggle: onToggle,
      onControllerCreated: onControllerCreated,
      headerClickable: headerClickable,
      decoration: decoration,
      headerDecoration: headerDecoration,
      expandedDecoration: expandedDecoration,
      expandedAlignment: expandedAlignment,
      maintainState: maintainState,
      minExpandedHeight: minExpandedHeight,
      maxExpandedHeight: maxExpandedHeight,
      clipExpanded: clipExpanded,
      scrollPhysics: scrollPhysics,
      leadingIconBuilder: leadingIconBuilder,
      trailingIconBuilder: trailingIconBuilder,
      showDivider: showDivider,
      dividerColor: dividerColor,
      dividerThickness: dividerThickness,
      semanticLabel: semanticLabel,
      enabled: enabled,
      isLoading: isLoading,
      loadingIndicator: loadingIndicator,
      sectionId: sectionId,
      accordionController: accordionController,
    );
  }

  @override
  ExpandableWidgetState createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends ExpandableWidgetState
    with
        SingleTickerProviderStateMixin,
        ExpandableControllerMixin,
        AutomaticKeepAliveClientMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late bool _isExpanded;
  bool _isAnimating = false;

  @override
  bool get wantKeepAlive => widget.maintainState;

  @override
  bool get isExpanded => _isExpanded;

  @override
  AnimationController get animationController => _animationController;

  @override
  void initState() {
    super.initState();

    // Determine initial state based on widget props and accordion controller
    _isExpanded = _determineInitialExpandedState();

    _animationController = AnimationController(
      duration: widget.animationConfig.duration,
      vsync: this,
    );

    _setupAnimations();

    if (_isExpanded) {
      _animationController.value = 1.0;
    }

    // Add listener for animation state
    _animationController.addStatusListener(_handleAnimationStatus);

    // Listen to accordion controller changes if provided
    if (widget.accordionController != null && widget.sectionId != null) {
      widget.accordionController!.addListener(_handleAccordionControllerChange);
    }

    // Notify parent of controller creation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onControllerCreated?.call(this);
    });
  }

  bool _determineInitialExpandedState() {
    if (widget.accordionController != null && widget.sectionId != null) {
      if (widget.initiallyExpanded) {
        // If this section should be initially expanded in accordion mode,
        // update the controller to reflect this
        widget.accordionController!.setOpenSection(widget.sectionId);
      }
      // In accordion mode, only expand if this is the section marked as open in the controller
      return widget.accordionController!.openSectionId == widget.sectionId;
    } else {
      // Without controller, use the widget's initiallyExpanded property
      return widget.initiallyExpanded;
    }
  }

  void _handleAccordionControllerChange() {
    if (widget.accordionController != null && widget.sectionId != null) {
      final shouldBeExpanded =
          widget.accordionController!.openSectionId == widget.sectionId;
      if (shouldBeExpanded != _isExpanded) {
        setState(() {
          _isExpanded = shouldBeExpanded;
          if (_isExpanded) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
        });
      }
    }
  }

  void _setupAnimations() {
    // Main size animation
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: widget.animationConfig.sizeCurve,
    );

    // Content opacity animation
    _fadeAnimation = widget.animationConfig.enableOpacityAnimation
        ? Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                0.3,
                1.0,
                curve: widget.animationConfig.opacityCurve,
              ),
            ),
          )
        : AlwaysStoppedAnimation(1.0);

    // Icon rotation animation
    _rotationAnimation = widget.animationConfig.enableRotationAnimation
        ? Tween<double>(begin: 0.0, end: 0.5).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                0.0,
                0.8,
                curve: widget.animationConfig.rotationCurve,
              ),
            ),
          )
        : AlwaysStoppedAnimation(0.0);

    // Header scale animation
    _scaleAnimation = widget.animationConfig.enableScaleAnimation
        ? Tween<double>(begin: 1.0, end: 1.03).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: Interval(
                0.0,
                0.2,
                curve: widget.animationConfig.scaleCurve,
              ),
              reverseCurve: Interval(0.0, 0.2, curve: Curves.easeIn),
            ),
          )
        : AlwaysStoppedAnimation(1.0);
  }

  @override
  void didUpdateWidget(ExpandableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Update animation duration if changed
    if (widget.animationConfig.duration != oldWidget.animationConfig.duration) {
      _animationController.duration = widget.animationConfig.duration;
    }

    // Update animations if config changed
    if (widget.animationConfig != oldWidget.animationConfig) {
      _setupAnimations();
    }

    // Handle accordion controller changes
    if (widget.accordionController != oldWidget.accordionController) {
      if (oldWidget.accordionController != null) {
        oldWidget.accordionController!.removeListener(
          _handleAccordionControllerChange,
        );
      }
      if (widget.accordionController != null && widget.sectionId != null) {
        widget.accordionController!.addListener(
          _handleAccordionControllerChange,
        );
        // Update state if needed based on new controller
        _handleAccordionControllerChange();
      }
    }
  }

  @override
  void dispose() {
    // Clean up listeners
    _animationController.removeStatusListener(_handleAnimationStatus);
    if (widget.accordionController != null) {
      widget.accordionController!.removeListener(
        _handleAccordionControllerChange,
      );
    }
    _animationController.dispose();
    super.dispose();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.forward:
      case AnimationStatus.reverse:
        if (!_isAnimating) {
          setState(() => _isAnimating = true);
        }
        break;
      case AnimationStatus.completed:
      case AnimationStatus.dismissed:
        if (_isAnimating) {
          setState(() => _isAnimating = false);
        }
        break;
    }
  }

  @override
  Future<void> expand() async {
    if (!_isExpanded && widget.enabled) {
      // If using accordion controller, update it
      if (widget.accordionController != null && widget.sectionId != null) {
        widget.accordionController!.setOpenSection(widget.sectionId);
      } else {
        setState(() => _isExpanded = true);
        await _animationController.forward();
        widget.onToggle?.call(_isExpanded);
      }
    }
  }

  @override
  Future<void> collapse() async {
    if (_isExpanded && widget.enabled) {
      // If using accordion controller, update it
      if (widget.accordionController != null && widget.sectionId != null) {
        widget.accordionController!.closeAll();
      } else {
        setState(() => _isExpanded = false);
        await _animationController.reverse();
        widget.onToggle?.call(_isExpanded);
      }
    }
  }

  @override
  Future<void> toggle() async {
    if (_isExpanded) {
      await collapse();
    } else {
      await expand();
    }
  }

  @override
  Future<void> setExpanded(bool expanded) async {
    if (expanded) {
      await expand();
    } else {
      await collapse();
    }
  }

  void _handleHeaderTap() {
    if (widget.headerClickable && widget.enabled) {
      toggle();
    }
  }

  Widget _buildHeader() {
    Widget headerContent = widget.headerWidget;

    // Create toggle function for icon builders
    VoidCallback toggleFunc = _handleHeaderTap;

    // Row to hold everything
    List<Widget> rowChildren = [];

    // Add leading icon if builder provided
    if (widget.leadingIconBuilder != null) {
      rowChildren.add(
        widget.leadingIconBuilder!(_isExpanded, _expandAnimation, toggleFunc),
      );
      rowChildren.add(SizedBox(width: 12));
    }

    // Add main content
    rowChildren.add(Expanded(child: headerContent));

    // Add trailing icon if builder provided
    if (widget.trailingIconBuilder != null) {
      rowChildren.add(
        widget.trailingIconBuilder!(_isExpanded, _expandAnimation, toggleFunc),
      );
    }
    // Use default rotating arrow icon for trailing if no builder but animation enabled
    else if (widget.animationConfig.enableRotationAnimation) {
      rowChildren.add(
        RotationTransition(
          turns: _rotationAnimation,
          child: Icon(Icons.keyboard_arrow_down),
        ),
      );
    }

    Widget header = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: rowChildren,
    );

    // Apply scale animation
    if (widget.animationConfig.enableScaleAnimation) {
      header = ScaleTransition(scale: _scaleAnimation, child: header);
    }

    // Apply decoration if provided
    if (widget.headerDecoration != null) {
      header = Container(decoration: widget.headerDecoration, child: header);
    }

    // Apply padding to header
    header = Padding(padding: widget.headerPadding, child: header);

    return header;
  }

  Widget _buildExpandedContent() {
    // Show loading indicator if loading
    if (widget.isLoading) {
      return Container(
        padding: widget.contentPadding,
        child:
            widget.loadingIndicator ??
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            ),
      );
    }

    List<Widget> children = [];

    // Add spacing between children
    for (int i = 0; i < widget.expandedChildren.length; i++) {
      if (i > 0) {
        children.add(SizedBox(height: widget.childrenSpacing));
      }
      children.add(widget.expandedChildren[i]);
    }

    Widget content = Column(
      crossAxisAlignment: widget.expandedAlignment,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );

    // Apply decoration if provided
    if (widget.expandedDecoration != null) {
      content = Container(
        decoration: widget.expandedDecoration,
        child: content,
      );
    }

    // Apply content padding
    content = Padding(padding: widget.contentPadding, child: content);

    // Apply slide animation if enabled
    if (widget.animationConfig.enableSlideAnimation) {
      content = SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.05),
          end: Offset.zero,
        ).animate(_expandAnimation),
        child: content,
      );
    }

    return content;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Build structure based on whether we have height constraints
    final bool hasHeightConstraints = widget.maxExpandedHeight != null;

    return Semantics(
      label: widget.semanticLabel,
      expanded: _isExpanded,
      enabled: widget.enabled,
      button: widget.headerClickable,
      child: Container(
        width: widget.width,
        padding: widget.padding,
        margin: widget.margin,
        decoration: widget.decoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header - Using Material for better tap handling
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.headerClickable && widget.enabled
                    ? _handleHeaderTap
                    : null,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: _buildHeader(),
              ),
            ),

            // Divider
            if (widget.showDivider)
              AnimatedContainer(
                duration: widget.animationConfig.duration,
                height: _isExpanded ? widget.dividerThickness : 0,
                color: widget.dividerColor ?? Theme.of(context).dividerColor,
              ),

            // Content - different handling based on whether we have height constraints
            if (hasHeightConstraints)
              // Handle scrollable content case
              AnimatedCrossFade(
                firstChild: SizedBox.shrink(),
                secondChild: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: widget.minExpandedHeight ?? 0,
                    maxHeight: widget.maxExpandedHeight!,
                  ),
                  child: SingleChildScrollView(
                    physics:
                        widget.scrollPhysics ?? AlwaysScrollableScrollPhysics(),
                    child: _buildExpandedContent(),
                  ),
                ),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: widget.animationConfig.duration,
                sizeCurve: widget.animationConfig.sizeCurve,
              )
            else
              // Handle regular content case
              AnimatedSize(
                duration: widget.animationConfig.duration,
                curve: widget.animationConfig.sizeCurve,
                alignment: Alignment.topCenter,
                child: !_isExpanded
                    ? SizedBox.shrink()
                    : widget.clipExpanded
                    ? ClipRect(
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: _buildExpandedContent(),
                        ),
                      )
                    : FadeTransition(
                        opacity: _fadeAnimation,
                        child: _buildExpandedContent(),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Extension for easier access to ExpandableController
extension ExpandableWidgetExtension on GlobalKey<ExpandableWidgetState> {
  ExpandableController? get controller => currentState;
}

/// Controller for accordion-style expandable groups
class AccordionController extends ChangeNotifier {
  String? _openSectionId;

  /// Creates a controller for accordion behavior
  AccordionController();

  /// Gets ID of currently open section
  String? get openSectionId => _openSectionId;

  /// Updates which section is open and notifies listeners
  void setOpenSection(String? sectionId) {
    if (_openSectionId != sectionId) {
      _openSectionId = sectionId;
      notifyListeners();
    }
  }

  /// Opens a specific section
  void openSection(String sectionId) {
    setOpenSection(sectionId);
  }

  /// Closes all sections
  void closeAll() {
    setOpenSection(null);
  }

  /// Toggles a section open/closed
  void toggleSection(String sectionId) {
    setOpenSection(_openSectionId == sectionId ? null : sectionId);
  }
}
