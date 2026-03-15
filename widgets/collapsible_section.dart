import 'package:flutter/material.dart';

typedef CollapsibleHeaderBuilder =
    Widget Function(BuildContext context, bool isExpanded, VoidCallback toggle);

typedef CollapsibleDecorationBuilder =
    BoxDecoration? Function(BuildContext context, bool isExpanded);

typedef CollapsibleTrailingBuilder =
    Widget Function(BuildContext context, bool isExpanded);

/// Controls a single [CollapsibleSection] externally.
///
/// If provided, the section becomes **controlled**, meaning
/// its expansion state is driven by this controller instead
/// of internal state.
class CollapsibleSectionController extends ChangeNotifier {
  CollapsibleSectionController({bool initiallyExpanded = false})
    : _isExpanded = initiallyExpanded;

  bool _isExpanded;

  bool get isExpanded => _isExpanded;

  void expand() => setExpanded(true);

  void collapse() => setExpanded(false);

  void toggle() => setExpanded(!_isExpanded);

  void setExpanded(bool value) {
    if (_isExpanded == value) return;
    _isExpanded = value;
    notifyListeners();
  }
}

/// Controls multiple [CollapsibleSection] widgets in **accordion mode**.
///
/// Only one section can be open at a time.
class CollapsibleAccordionController extends ChangeNotifier {
  CollapsibleAccordionController({String? initialOpenSectionId})
    : _openSectionId = initialOpenSectionId;

  String? _openSectionId;

  String? get openSectionId => _openSectionId;

  bool isOpen(String id) => _openSectionId == id;

  void open(String id) {
    if (_openSectionId == id) return;
    _openSectionId = id;
    notifyListeners();
  }

  void close() {
    if (_openSectionId == null) return;
    _openSectionId = null;
    notifyListeners();
  }

  void toggle(String id) {
    if (_openSectionId == id) {
      close();
    } else {
      open(id);
    }
  }
}

/// A reusable collapsible/expandable section widget.
///
/// Supports:
/// - standalone expansion
/// - controller-driven expansion
/// - accordion behavior
/// - custom headers
/// - loading state
class CollapsibleSection extends StatefulWidget {
  const CollapsibleSection({
    super.key,
    required this.headerBuilder,
    required this.child,
    this.controller,
    this.accordionController,
    this.sectionId,
    this.initiallyExpanded = false,
    this.animationDuration = const Duration(milliseconds: 260),
    this.sizeCurve = Curves.easeInOutCubic,
    this.fadeCurve = Curves.easeOut,
    this.headerPadding = const EdgeInsets.all(16),
    this.contentPadding = const EdgeInsets.fromLTRB(16, 0, 16, 16),
    this.decorationBuilder,
    this.isLoading = false,
    this.loadingIndicator,
    this.maintainState = false,
    this.enabled = true,
    this.clipBehavior = Clip.antiAlias,
    this.onExpansionChanged,
    this.onOpen,
    this.onClose,
    this.semanticLabel,
  }) : assert(
         accordionController == null || (sectionId != null && sectionId != ''),
         'A non-empty sectionId is required when using accordionController',
       ),
       assert(
         !(controller != null && accordionController != null),
         'Use either controller or accordionController, not both.',
       );

  /// Builds the section header.
  ///
  /// Provides:
  /// - current expansion state
  /// - toggle callback
  final CollapsibleHeaderBuilder headerBuilder;

  /// The content displayed when the section is expanded.
  final Widget child;

  /// External controller for a single section.
  ///
  /// When provided, [initiallyExpanded] is ignored.
  final CollapsibleSectionController? controller;

  /// Accordion controller for grouped collapsible sections.
  ///
  /// Requires [sectionId].
  final CollapsibleAccordionController? accordionController;

  /// Unique identifier for this section inside an accordion group.
  final String? sectionId;

  /// Initial expansion state used only when no controller is provided.
  final bool initiallyExpanded;

  final Duration animationDuration;
  final Curve sizeCurve;
  final Curve fadeCurve;

  final EdgeInsetsGeometry headerPadding;
  final EdgeInsetsGeometry contentPadding;

  final CollapsibleDecorationBuilder? decorationBuilder;

  final bool isLoading;
  final Widget? loadingIndicator;

  final bool maintainState;
  final bool enabled;
  final Clip clipBehavior;

  final ValueChanged<bool>? onExpansionChanged;
  final VoidCallback? onOpen;
  final VoidCallback? onClose;

  final String? semanticLabel;

  /// Convenience constructor for common cases.
  ///
  /// Creates a simple header with a title and optional trailing widget.
  factory CollapsibleSection.simple({
    Key? key,
    required Widget title,
    required Widget child,
    CollapsibleTrailingBuilder? trailingBuilder,
    TextStyle? titleStyle,
    CrossAxisAlignment headerCrossAxisAlignment = CrossAxisAlignment.center,
    CollapsibleSectionController? controller,
    CollapsibleAccordionController? accordionController,
    String? sectionId,
    bool initiallyExpanded = false,
    Duration animationDuration = const Duration(milliseconds: 260),
    Curve sizeCurve = Curves.easeInOutCubic,
    Curve fadeCurve = Curves.easeOut,
    EdgeInsetsGeometry headerPadding = const EdgeInsets.all(16),
    EdgeInsetsGeometry contentPadding = const EdgeInsets.fromLTRB(
      16,
      0,
      16,
      16,
    ),
    CollapsibleDecorationBuilder? decorationBuilder,
    bool isLoading = false,
    Widget? loadingIndicator,
    bool maintainState = false,
    bool enabled = true,
    Clip clipBehavior = Clip.antiAlias,
    ValueChanged<bool>? onExpansionChanged,
    VoidCallback? onOpen,
    VoidCallback? onClose,
    String? semanticLabel,
  }) {
    return CollapsibleSection(
      key: key,
      controller: controller,
      accordionController: accordionController,
      sectionId: sectionId,
      initiallyExpanded: initiallyExpanded,
      animationDuration: animationDuration,
      sizeCurve: sizeCurve,
      fadeCurve: fadeCurve,
      headerPadding: headerPadding,
      contentPadding: contentPadding,
      decorationBuilder: decorationBuilder,
      isLoading: isLoading,
      loadingIndicator: loadingIndicator,
      maintainState: maintainState,
      enabled: enabled,
      clipBehavior: clipBehavior,
      onExpansionChanged: onExpansionChanged,
      onOpen: onOpen,
      onClose: onClose,
      semanticLabel: semanticLabel,
      child: child,
      headerBuilder: (context, isExpanded, toggle) {
        return Row(
          crossAxisAlignment: headerCrossAxisAlignment,
          children: [
            Expanded(
              child: DefaultTextStyle.merge(style: titleStyle, child: title),
            ),
            const SizedBox(width: 12),
            trailingBuilder != null
                ? trailingBuilder(context, isExpanded)
                : AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: animationDuration,
                    curve: Curves.easeInOutCubic,
                    child: const Icon(Icons.keyboard_arrow_down_rounded),
                  ),
          ],
        );
      },
    );
  }

  @override
  State<CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<CollapsibleSection>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late final AnimationController _animationController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _fadeAnimation;

  bool get _usesAccordion => widget.accordionController != null;
  bool get _usesController => widget.controller != null;

  @override
  void initState() {
    super.initState();
    _isExpanded = _resolveInitialExpandedState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
      value: _isExpanded ? 1 : 0,
    );

    _configureAnimations();

    widget.controller?.addListener(_handleExternalStateChange);
    widget.accordionController?.addListener(_handleExternalStateChange);
  }

  @override
  void didUpdateWidget(covariant CollapsibleSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animationDuration != widget.animationDuration) {
      _animationController.duration = widget.animationDuration;
    }

    if (oldWidget.sizeCurve != widget.sizeCurve ||
        oldWidget.fadeCurve != widget.fadeCurve) {
      _configureAnimations();
    }

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleExternalStateChange);
      widget.controller?.addListener(_handleExternalStateChange);
    }

    if (oldWidget.accordionController != widget.accordionController) {
      oldWidget.accordionController?.removeListener(_handleExternalStateChange);
      widget.accordionController?.addListener(_handleExternalStateChange);
    }

    _syncFromExternalState();
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleExternalStateChange);
    widget.accordionController?.removeListener(_handleExternalStateChange);
    _animationController.dispose();
    super.dispose();
  }

  void _configureAnimations() {
    _sizeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: widget.sizeCurve,
      reverseCurve: widget.sizeCurve,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: widget.fadeCurve,
      reverseCurve: widget.fadeCurve,
    );
  }

  bool _resolveInitialExpandedState() {
    if (_usesAccordion) {
      final isInitiallyOpen =
          widget.sectionId != null &&
          widget.accordionController!.isOpen(widget.sectionId!);

      if (!isInitiallyOpen &&
          widget.initiallyExpanded &&
          widget.sectionId != null &&
          widget.accordionController!.openSectionId == null) {
        widget.accordionController!.open(widget.sectionId!);
        return true;
      }

      return isInitiallyOpen;
    }

    if (_usesController) {
      return widget.controller!.isExpanded;
    }

    return widget.initiallyExpanded;
  }

  void _handleExternalStateChange() {
    _syncFromExternalState();
  }

  void _syncFromExternalState() {
    if (_usesAccordion && widget.sectionId != null) {
      _applyExpanded(
        widget.accordionController!.isOpen(widget.sectionId!),
        notifyExternal: false,
      );
      return;
    }

    if (_usesController) {
      _applyExpanded(widget.controller!.isExpanded, notifyExternal: false);
    }
  }

  void _toggle() {
    if (!widget.enabled) return;

    if (_usesAccordion && widget.sectionId != null) {
      widget.accordionController!.toggle(widget.sectionId!);
      return;
    }

    if (_usesController) {
      widget.controller!.toggle();
      return;
    }

    _applyExpanded(!_isExpanded);
  }

  void _applyExpanded(bool value, {bool notifyExternal = true}) {
    if (_isExpanded == value) return;

    setState(() {
      _isExpanded = value;
    });

    if (value) {
      _animationController.forward();
      widget.onOpen?.call();
    } else {
      _animationController.reverse();
      widget.onClose?.call();
    }

    if (notifyExternal && _usesController) {
      widget.controller!.setExpanded(value);
    }

    widget.onExpansionChanged?.call(value);
  }

  BorderRadius _resolveBorderRadius(BoxDecoration? decoration) {
    final radius = decoration?.borderRadius;
    if (radius is BorderRadius) return radius;
    return BorderRadius.circular(16);
  }

  @override
  Widget build(BuildContext context) {
    final decoration = widget.decorationBuilder?.call(context, _isExpanded);
    final borderRadius = _resolveBorderRadius(decoration);

    final shouldBuildContent =
        widget.maintainState || _isExpanded || _animationController.isAnimating;

    return Semantics(
      container: true,
      button: true,
      enabled: widget.enabled,
      toggled: _isExpanded,
      label: widget.semanticLabel,
      child: DecoratedBox(
        decoration: decoration ?? const BoxDecoration(),
        child: ClipRRect(
          borderRadius: borderRadius,
          clipBehavior: widget.clipBehavior,
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: widget.enabled ? _toggle : null,
                  borderRadius: borderRadius,
                  child: Padding(
                    padding: widget.headerPadding,
                    child: widget.headerBuilder(context, _isExpanded, _toggle),
                  ),
                ),
                ClipRect(
                  child: SizeTransition(
                    sizeFactor: _sizeAnimation,
                    axisAlignment: -1,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: shouldBuildContent
                          ? Padding(
                              padding: widget.contentPadding,
                              child: widget.isLoading
                                  ? (widget.loadingIndicator ??
                                        const Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            child: CircularProgressIndicator(),
                                          ),
                                        ))
                                  : widget.child,
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CollapsibleSectionExamplesPage extends StatefulWidget {
  const CollapsibleSectionExamplesPage({super.key});

  @override
  State<CollapsibleSectionExamplesPage> createState() =>
      _CollapsibleSectionExamplesPageState();
}

class _CollapsibleSectionExamplesPageState
    extends State<CollapsibleSectionExamplesPage> {
  late final CollapsibleSectionController _controlledSectionController;
  late final CollapsibleSectionController _externalControlController;
  late final CollapsibleAccordionController _accordionController;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controlledSectionController = CollapsibleSectionController();
    _externalControlController = CollapsibleSectionController();
    _accordionController = CollapsibleAccordionController(
      initialOpenSectionId: 'section1',
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _controlledSectionController.dispose();
    _externalControlController.dispose();
    _accordionController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 20),
      child: Text(
        text,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Color(0x14000000),
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('CollapsibleSection Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle('1) أبسط استخدام (Simple Section)'),
          _card(
            child: CollapsibleSection.simple(
              title: const Text(
                'Trip Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Departure: Cairo'),
                  SizedBox(height: 8),
                  Text('Arrival: Dubai'),
                ],
              ),
            ),
          ),

          _sectionTitle('2) Simple Section مع trailing مخصص'),
          _card(
            child: CollapsibleSection.simple(
              title: const Text('Passenger Info'),
              trailingBuilder: (context, isExpanded) {
                return Icon(
                  isExpanded
                      ? Icons.remove_circle_outline
                      : Icons.add_circle_outline,
                );
              },
              child: const Text('Passenger details here'),
            ),
          ),

          _sectionTitle('3) استخدام Custom Header'),
          _card(
            child: CollapsibleSection(
              headerBuilder: (context, isExpanded, toggle) {
                return Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Booking Summary',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text(isExpanded ? 'Hide' : 'Show'),
                  ],
                );
              },
              child: const Text('Summary content'),
            ),
          ),

          _sectionTitle('4) استخدام Controller للتحكم الخارجي'),
          Row(
            children: [
              ElevatedButton(
                onPressed: _controlledSectionController.toggle,
                child: const Text('Toggle Section'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _card(
            child: CollapsibleSection.simple(
              controller: _controlledSectionController,
              title: const Text('Controlled Section'),
              child: const Text('Controlled content'),
            ),
          ),

          _sectionTitle('5) فتح وغلق Section من الخارج'),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton(
                onPressed: _externalControlController.expand,
                child: const Text('Open'),
              ),
              ElevatedButton(
                onPressed: _externalControlController.collapse,
                child: const Text('Close'),
              ),
              ElevatedButton(
                onPressed: _externalControlController.toggle,
                child: const Text('Toggle'),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _card(
            child: CollapsibleSection.simple(
              controller: _externalControlController,
              title: const Text('External Control'),
              child: const Text('Content controlled from outside'),
            ),
          ),

          _sectionTitle('6) Accordion (قسم واحد فقط مفتوح)'),
          _card(
            child: Column(
              children: [
                CollapsibleSection.simple(
                  accordionController: _accordionController,
                  sectionId: 'section1',
                  title: const Text('Section 1'),
                  child: const Text('Content 1'),
                ),
                CollapsibleSection.simple(
                  accordionController: _accordionController,
                  sectionId: 'section2',
                  title: const Text('Section 2'),
                  child: const Text('Content 2'),
                ),
                CollapsibleSection.simple(
                  accordionController: _accordionController,
                  sectionId: 'section3',
                  title: const Text('Section 3'),
                  child: const Text('Content 3'),
                ),
              ],
            ),
          ),

          _sectionTitle('7) Loading State'),
          _card(
            child: CollapsibleSection.simple(
              title: const Text('Trip Passengers'),
              isLoading: _isLoading,
              child: const Text('Passengers loaded successfully'),
            ),
          ),

          _sectionTitle('8) Loading Indicator مخصص'),
          _card(
            child: CollapsibleSection.simple(
              title: const Text('Passengers with custom loader'),
              isLoading: _isLoading,
              loadingIndicator: const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: LinearProgressIndicator(),
              ),
              child: const Text('Passenger list loaded'),
            ),
          ),

          _sectionTitle('9) Callbacks'),
          _card(
            child: CollapsibleSection.simple(
              title: const Text('Trip Info'),
              onOpen: () => _showMessage('Opened'),
              onClose: () => _showMessage('Closed'),
              onExpansionChanged: (expanded) {
                _showMessage('Expanded: $expanded');
              },
              child: const Text('Trip data'),
            ),
          ),

          _sectionTitle('10) Decoration مخصص'),
          _card(
            child: CollapsibleSection.simple(
              title: const Text('Custom Style'),
              decorationBuilder: (context, expanded) {
                return BoxDecoration(
                  color: expanded ? Colors.blue.shade50 : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: expanded ? Colors.blue : Colors.grey.shade400,
                  ),
                );
              },
              child: const Text('Styled section'),
            ),
          ),

          _sectionTitle('11) maintainState'),
          _card(
            child: CollapsibleSection.simple(
              title: const Text('Form'),
              maintainState: true,
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Type something here',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),

          _sectionTitle('12) Disabled Section'),
          _card(
            child: CollapsibleSection.simple(
              title: const Text('Disabled Section'),
              enabled: false,
              child: const Text('This section cannot be toggled'),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
