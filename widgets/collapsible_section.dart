import 'package:flutter/material.dart';
import 'package:hr_app/core/theme/colors/cy_color_theme.dart';
import 'package:hr_app/core/theme/typography/cy_text_theme.dart';

class CollapsibleSection extends StatefulWidget {
  final String title;
  final TextStyle? titleStyle;
  final Widget icon;

  final List<Widget> children;

  final bool initiallyExpanded;

  final Duration animationDuration;

  final bool isLoading;

  final BoxDecoration? decoration;

  final VoidCallback? onOpen;

  final VoidCallback? onClose;

  final Function(bool isExpanded)? onExpandChanged;

  final Widget? loadingIndicator;

  final String? sectionId;

  final CollapsibleSectionController? controller;

  const CollapsibleSection({
    Key? key,
    required this.title,
    this.titleStyle,
    this.icon = const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
    this.children = const [],
    this.initiallyExpanded = false,
    this.animationDuration = const Duration(milliseconds: 350),
    this.isLoading = false,
    this.decoration,
    this.onOpen,
    this.onClose,
    this.onExpandChanged,
    this.loadingIndicator,
    this.sectionId,
    this.controller,
  }) : assert(
         controller == null || sectionId != null,
         'sectionId must be provided when using a controller',
       ),
       super(key: key);

  @override
  State<CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<CollapsibleSection>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _controller;
  late Animation<double> _iconRotationAnimation;
  late Animation<double> _contentOpacityAnimation;
  late Animation<double> _headerScaleAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = _determineInitialExpandedState();

    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _iconRotationAnimation = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeInOutCubic),
      ),
    );

    _contentOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOutQuart),
      ),
    );

    _headerScaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
        reverseCurve: const Interval(0.0, 0.2, curve: Curves.easeIn),
      ),
    );

    if (_isExpanded) {
      _controller.value = 1.0;
    }

    if (widget.controller != null) {
      widget.controller!.addListener(_handleControllerChange);
    }
  }

  @override
  void dispose() {
    if (widget.controller != null) {
      widget.controller!.removeListener(_handleControllerChange);
    }
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CollapsibleSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller != null) {
        oldWidget.controller!.removeListener(_handleControllerChange);
      }
      if (widget.controller != null) {
        widget.controller!.addListener(_handleControllerChange);
        _updateExpandedStateFromController();
      }
    }
  }

  bool _determineInitialExpandedState() {
    if (widget.controller != null && widget.controller!.accordionMode) {
      if (widget.initiallyExpanded) {
        // If this section should be initially expanded in accordion mode,
        // update the controller to reflect this
        widget.controller!.setOpenSection(widget.sectionId);
      }
      // In accordion mode, only expand if this is the section marked as open in the controller
      return widget.controller!.openSectionId == widget.sectionId;
    } else {
      // Without controller or not in accordion mode, use the widget's initiallyExpanded property
      return widget.initiallyExpanded;
    }
  }

  void _handleControllerChange() {
    _updateExpandedStateFromController();
  }

  void _updateExpandedStateFromController() {
    if (widget.controller != null && widget.controller!.accordionMode) {
      final shouldBeExpanded =
          widget.controller!.openSectionId == widget.sectionId;
      if (shouldBeExpanded != _isExpanded) {
        setState(() {
          _isExpanded = shouldBeExpanded;
          if (_isExpanded) {
            _controller.forward();
            if (widget.onOpen != null) {
              widget.onOpen!();
            }
            if (widget.onExpandChanged != null) {
              widget.onExpandChanged!(true);
            }
          } else {
            _controller.reverse();
            if (widget.onClose != null) {
              widget.onClose!();
            }
            if (widget.onExpandChanged != null) {
              widget.onExpandChanged!(false);
            }
          }
        });
      }
    }
  }

  void _toggleExpand() {
    final newExpandedState = !_isExpanded;

    // If using a controller with accordion mode
    if (widget.controller != null && widget.controller!.accordionMode) {
      if (newExpandedState) {
        // Tell controller this section is now open (which will close others)
        widget.controller!.setOpenSection(widget.sectionId);
      } else {
        // Clear the open section in controller
        widget.controller!.setOpenSection(null);
      }
    }

    setState(() {
      _isExpanded = newExpandedState;
      if (_isExpanded) {
        _controller.forward();

        if (widget.onOpen != null) {
          widget.onOpen!();
        }
      } else {
        _controller.reverse();

        if (widget.onClose != null) {
          widget.onClose!();
        }
      }

      if (widget.onExpandChanged != null) {
        widget.onExpandChanged!(_isExpanded);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: widget.animationDuration,
      curve: Curves.easeInOutCubic,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration:
          widget.decoration ??
          BoxDecoration(
            color: CyColorTheme.of(context).background.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isExpanded ? 0.08 : 0.05),
                spreadRadius: _isExpanded ? 1.5 : 1,
                blurRadius: _isExpanded ? 3 : 1,
                offset: _isExpanded ? const Offset(0, 2) : const Offset(0, 1),
              ),
            ],
          ),
      child: Column(
        children: [
          ScaleTransition(
            scale: _headerScaleAnimation,
            child: InkWell(
              onTap: _toggleExpand,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style:
                          widget.titleStyle ??
                          CyTypography.of(
                            context,
                          ).headline.typoHeadlineMeduim16,
                    ),
                    RotationTransition(
                      turns: _iconRotationAnimation,
                      child: widget.icon,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Animated Content with improved transitions
          AnimatedSize(
            duration: widget.animationDuration,
            curve: Curves.easeInOutCubic,
            alignment: Alignment.topCenter,
            child: ClipRect(
              child: AnimatedSwitcher(
                duration: widget.animationDuration,
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: SizeTransition(
                      sizeFactor: animation,
                      axisAlignment: 0.0,
                      child: FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, -0.05),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                    ),
                  );
                },
                child: _isExpanded
                    ? _buildExpandedContent()
                    : const SizedBox(
                        key: ValueKey<String>('collapsed'),
                        height: 0,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent() {
    return FadeTransition(
      opacity: _contentOpacityAnimation,
      child: Container(
        key: const ValueKey<String>('expanded'),
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
        decoration:
            widget.decoration ??
            BoxDecoration(
              color: CyColorTheme.of(context).background,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(10),
              ),
            ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.isLoading)
              widget.loadingIndicator ??
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
            // Otherwise show children
            else
              ...widget.children,
          ],
        ),
      ),
    );
  }
}

/// Controller for managing multiple CollapsibleSection widgets with accordion behavior
class CollapsibleSectionController extends ChangeNotifier {
  String? _openSectionId;
  final bool accordionMode;

  /// If [accordionMode] is true, only one section can be open at a time
  CollapsibleSectionController({this.accordionMode = false});

  /// Gets ID of currently open section (if using accordion mode)
  String? get openSectionId => _openSectionId;

  /// Updates which section is open and notifies listeners
  void setOpenSection(String? sectionId) {
    if (_openSectionId != sectionId) {
      _openSectionId = sectionId;
      notifyListeners();
    }
  }

  /// Checks if a specific section should be open
  bool isSectionOpen(String sectionId) {
    return !accordionMode || _openSectionId == sectionId;
  }
}
