import 'package:flutter/material.dart';

class ExpandableWidget extends StatefulWidget {
  final Widget headerWidget;
  final List<Widget> expandedChildren;
  final Duration animationDuration;
  final Curve animationCurve;
  final bool initiallyExpanded;
  final EdgeInsets padding;
  final double? width;
  final double childrenSpacing;
  final VoidCallback? onToggle;

  const ExpandableWidget({
    super.key,
    required this.headerWidget,
    required this.expandedChildren,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animationCurve = Curves.easeInOut,
    this.initiallyExpanded = false,
    this.padding = EdgeInsets.zero,
    this.childrenSpacing = 8.0,
    this.width,
    this.onToggle,
  });

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
    );

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      widget.onToggle?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          GestureDetector(
            onTap: _toggleExpand,
            child: widget.headerWidget,
          ),
          // Expandable content
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widget.expandedChildren
                  .asMap()
                  .map((index, child) => MapEntry(
                        index,
                        Padding(
                          padding: EdgeInsets.only(
                            top: index == 0 ? widget.childrenSpacing : 0,
                            bottom: widget.childrenSpacing,
                          ),
                          child: child,
                        ),
                      ))
                  .values
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
