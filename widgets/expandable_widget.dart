import 'package:flutter/material.dart';

// // First, create a global key
// final GlobalKey<_ExpandableWidgetState> expandableKey = GlobalKey<_ExpandableWidgetState>();

// // Then, use it in your widget
// ExpandableWidget(
//   key: expandableKey,
//   headerWidget: Text('Header'),
//   expandedChildren: [
//     Text('Child 1'),
//     Text('Child 2'),
//   ],
// )

// // Now you can control it from anywhere:
// expandableKey.currentState?.collapse(); // To close
// expandableKey.currentState?.expand();   // To open
// expandableKey.currentState?.toggle();   // To toggle

//////???

// void buildExpandableWidget(BuildContext context) {
//   late _ExpandableWidgetState expandableState;

//   return ExpandableWidget(
//     onInit: (state) {
//       expandableState = state;
//     },
//     headerWidget: Text('Header'),
//     expandedChildren: [
//       Text('Child 1'),
//       ElevatedButton(
//         onPressed: () {
//           expandableState.collapse(); // Close programmatically
//         },
//         child: Text('Close'),
//       ),
//     ],
//   );
// }

mixin ExpandableControllerMixin on State<ExpandableWidget> {
  bool get isExpanded;
  void expand();
  void collapse();
  void toggle();
}

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
  final void Function(ExpandableControllerMixin)? onInit;

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
    this.onInit,
  });

  @override
  State<ExpandableWidget> createState() => _ExpandableWidgetState();
}

class _ExpandableWidgetState extends State<ExpandableWidget>
    with SingleTickerProviderStateMixin, ExpandableControllerMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late bool _isExpanded;

  @override
  bool get isExpanded => _isExpanded;

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
    widget.onInit?.call(this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void expand() {
    if (!_isExpanded) {
      setState(() {
        _isExpanded = true;
        _animationController.forward();
        widget.onToggle?.call();
      });
    }
  }

  @override
  void collapse() {
    if (_isExpanded) {
      setState(() {
        _isExpanded = false;
        _animationController.reverse();
        widget.onToggle?.call();
      });
    }
  }

  @override
  void toggle() {
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

  void _toggleExpand() {
    toggle();
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
          GestureDetector(
            onTap: _toggleExpand,
            child: widget.headerWidget,
          ),
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
