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
        _closeDropdown();
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
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 5),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 200,
                maxWidth: size.width,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
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
                      ListTile(
                        title: const Text('No items found'),
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
                          title: Text(widget.getLabel(item)),
                          onTap: () => _selectItem(item),
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
    setState(
      () {
        _filteredItems = widget.searchableFunction(value);
      },
    );
    if (widget.onSearchResult != null) widget.onSearchResult!(_filteredItems);

    if (_isOpen) {
      _overlayEntry?.markNeedsBuild();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: widget.hint,
          border: const OutlineInputBorder(),
          suffixIcon: IconButton(
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
    );
  }
}
