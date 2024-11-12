import 'package:flutter/material.dart';

class SearchableDropdown<T> extends StatefulWidget {
  final String hint;
  final List<T> items;
  final Function(List<T>)? onSearchResult;
  final Function()? onNotFound;
  final Function(T) onSelected;
  final String Function(T) getLabel;
  final TextEditingController? controller;
  final List<T> Function(String) searchableFunction;
  final double? width;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry margin;
  final double dropdownMaxHeight;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? dropdownBackgroundColor;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final TextStyle? dropdownTextStyle;
  final BoxDecoration? dropdownDecoration;
  final InputDecoration? inputDecoration;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Widget? notFoundWidget;
  final double dropdownElevation;
  final double dropdownOffset;
  final InputBorder? border;

  const SearchableDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.onSelected,
    required this.getLabel,
    required this.searchableFunction,
    this.onNotFound,
    this.onSearchResult,
    this.controller,
    this.width,
    this.contentPadding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.dropdownMaxHeight = 200,
    this.borderRadius = 8,
    this.backgroundColor,
    this.dropdownBackgroundColor,
    this.hintStyle,
    this.textStyle,
    this.dropdownTextStyle,
    this.dropdownDecoration,
    this.inputDecoration,
    this.suffixIcon,
    this.prefixIcon,
    this.notFoundWidget,
    this.dropdownElevation = 4,
    this.dropdownOffset = 5,
    this.border,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  late TextEditingController _controller;
  bool _isOpen = false;
  OverlayEntry? _overlayEntry;
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _filteredItems = widget.items;
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _openDropdown();
      } else {
        // Delay closing dropdown to allow item selection on tap
        Future.delayed(
          const Duration(milliseconds: 200),
          () => _closeDropdown(),
        );
      }
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    _closeDropdown();
    super.dispose();
  }

  void _openDropdown() {
    _isOpen = true;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    _isOpen = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _selectItem(T item) {
    _controller.text = widget.getLabel(item);
    widget.onSelected(item);
    _closeDropdown();
    _focusNode.unfocus();
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: widget.width ?? size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + widget.dropdownOffset),
          child: Material(
            elevation: widget.dropdownElevation,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: Colors.transparent,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: widget.dropdownMaxHeight,
                maxWidth: widget.width ?? size.width,
              ),
              decoration: widget.dropdownDecoration ??
                  BoxDecoration(
                    color: widget.dropdownBackgroundColor ??
                        Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1,
                    ),
                  ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_filteredItems.isEmpty) ...[
                      widget.notFoundWidget ??
                          ListTile(
                            title: Text(
                              'No items found',
                              style: widget.dropdownTextStyle,
                            ),
                            trailing: widget.onNotFound != null
                                ? TextButton(
                                    onPressed: () {
                                      _closeDropdown();
                                      widget.onNotFound!();
                                    },
                                    child: const Text('Add New'),
                                  )
                                : null,
                          ),
                    ] else
                      ..._filteredItems.map(
                        (item) => ListTile(
                          contentPadding: widget.contentPadding,
                          title: Text(
                            widget.getLabel(item),
                            style: widget.dropdownTextStyle,
                          ),
                          onTap: () {
                            _selectItem(item);
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onSearchChanged(String value) {
    setState(() {
      _filteredItems = widget.searchableFunction(value);
    });
    if (widget.onSearchResult != null) widget.onSearchResult!(_filteredItems);

    if (_isOpen) {
      _overlayEntry?.markNeedsBuild();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      margin: widget.margin,
      child: CompositedTransformTarget(
        link: _layerLink,
        child: TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: _onSearchChanged,
          style: widget.textStyle,
          decoration: widget.inputDecoration ??
              InputDecoration(
                hintText: widget.hint,
                hintStyle: widget.hintStyle,
                border: widget.border ?? const OutlineInputBorder(),
                contentPadding: widget.contentPadding,
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.suffixIcon ??
                    IconButton(
                      icon: const Icon(Icons.arrow_drop_down),
                      onPressed: () {
                        if (_isOpen) {
                          _focusNode.unfocus();
                        } else {
                          _focusNode.requestFocus();
                        }
                      },
                    ),
              ),
        ),
      ),
    );
  }
}
