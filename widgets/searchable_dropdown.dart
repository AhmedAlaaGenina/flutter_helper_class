import 'package:flutter/material.dart';

/// Defines how items are grouped in the dropdown
class DropdownGroup<T> {
  final String name;
  final List<T> items;

  DropdownGroup({required this.name, required this.items});
}

/// Configuration for selection limits
class SelectionConfig {
  final int? maxSelections;
  final int? minSelections;
  final String? maxSelectionsMessage;
  final String? minSelectionsMessage;

  const SelectionConfig({
    this.maxSelections,
    this.minSelections,
    this.maxSelectionsMessage,
    this.minSelectionsMessage,
  });
}

enum SelectionMode {
  single,
  multipleWithCheckbox,
  multipleWithToggle,
}

class SearchableDropdown<T> extends StatefulWidget {
  final String hint;
  final List<T> items;
  final Function(List<T>)? onSearchResult;
  final Function()? onNotFound;
  final Function(List<T>) onSelected;
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
  final List<T>? initialValue;
  //?
  final List<DropdownGroup<T>>? groups;
  final bool Function(T item)? enabledItemFunction;
  final Widget Function(T item, bool isSelected)? itemBuilder;
  final SelectionMode selectionMode;
  final SelectionConfig? selectionConfig;
  final bool showSelectedItemsAsChips;
  final Widget Function(T item)? chipBuilder;

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
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 8),
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
    this.initialValue,
    this.groups,
    this.enabledItemFunction,
    this.itemBuilder,
    this.selectionMode = SelectionMode.single,
    this.selectionConfig,
    this.showSelectedItemsAsChips = false,
    this.chipBuilder,
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
  List<T> _selectedItems = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _filteredItems = widget.items;
    _selectedItems = widget.initialValue?.toList() ?? [];
    _updateDisplayText();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _openDropdown();
      } else {
        if (!_isMultiSelectMode() || !_isOpen) {
          Future.delayed(
            const Duration(milliseconds: 200),
            () => _closeDropdown(),
          );
        }
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

  bool _isMultiSelectMode() {
    return widget.selectionMode == SelectionMode.multipleWithCheckbox ||
        widget.selectionMode == SelectionMode.multipleWithToggle;
  }

  void _updateDisplayText() {
    if (!_focusNode.hasFocus) {
      if (_selectedItems.isEmpty) {
        _controller.text = '';
      } else if (!_isMultiSelectMode()) {
        // In single select mode, only show the last selected item
        _controller.text = widget.getLabel(_selectedItems.last);
        // Keep only the last selected item
        _selectedItems = [_selectedItems.last];
      } else {
        _controller.text = '${_selectedItems.length} items selected';
      }
    }
  }

  void _openDropdown() {
    if (!_isOpen) {
      setState(() {
        _isOpen = true;
        // Reset filtered items to show all items
        _filteredItems = widget.items;
        _searchQuery = '';
        // Clear the display text only in multi-select mode when opening
        if (_isMultiSelectMode()) {
          _controller.text = '';
        }
      });
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _closeDropdown() {
    if (_isOpen) {
      setState(() {
        _isOpen = false;
        _searchQuery = '';
        _filteredItems = widget.items;
      });
      _overlayEntry?.remove();
      _overlayEntry = null;
      _updateDisplayText();
    }
  }

  void _toggleItem(T item) {
    if (!_canSelectMore()) return;

    setState(() {
      if (_isMultiSelectMode()) {
        if (_selectedItems.contains(item)) {
          _selectedItems.remove(item);
        } else {
          _selectedItems.add(item);
        }
        // Keep the search text in multi-select mode
        _controller.text = _searchQuery;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      } else {
        // In single select mode, replace the selection
        _selectedItems = [item];
        _updateDisplayText();
      }
    });

    widget.onSelected(_selectedItems);

    if (!_isMultiSelectMode()) {
      _closeDropdown();
      _focusNode.unfocus();
    } else {
      // Rebuild overlay to update checkboxes
      _overlayEntry?.markNeedsBuild();
    }
  }

  bool _canSelectMore() {
    if (widget.selectionConfig?.maxSelections == null) return true;

    if (_selectedItems.length >= widget.selectionConfig!.maxSelections!) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.selectionConfig!.maxSelectionsMessage ??
                'Maximum selection limit reached',
          ),
        ),
      );
      return false;
    }
    return true;
  }

  void _selectAll() {
    setState(() {
      // Only select from filtered items if there's a search query
      if (_searchQuery.isNotEmpty) {
        // Add all filtered items that aren't already selected
        for (var item in _filteredItems) {
          if (!_selectedItems.contains(item)) {
            _selectedItems.add(item);
          }
        }
      } else {
        // If no search query, select all items
        _selectedItems = List.from(widget.items);
      }
      _controller.text = _searchQuery;
    });
    widget.onSelected(_selectedItems);
    _overlayEntry?.markNeedsBuild();
  }

  void _onSearchChanged(String value) {
    _searchQuery = value;
    setState(() {
      _filteredItems =
          value.isEmpty ? widget.items : widget.searchableFunction(value);
    });
    if (widget.onSearchResult != null) widget.onSearchResult!(_filteredItems);

    if (_isOpen) {
      _overlayEntry?.markNeedsBuild();
    }
  }

  Widget _buildSelectedItemsChips() {
    if (!widget.showSelectedItemsAsChips || _selectedItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          ..._selectedItems.map((item) {
            if (widget.chipBuilder != null) {
              return widget.chipBuilder!(item);
            }

            return Chip(
              label: Text(widget.getLabel(item)),
              onDeleted: () => _toggleItem(item),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildGroupedItems() {
    if (widget.groups == null) return _buildItemsList();

    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.groups!.length,
      itemBuilder: (context, index) {
        final group = widget.groups![index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                group.name,
                style: widget.dropdownTextStyle?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...group.items.map((item) => _buildItem(item)),
          ],
        );
      },
    );
  }

  Widget _buildItemsList() {
    return ListView.builder(
      // controller: _scrollController,
      shrinkWrap: true,
      itemCount: _filteredItems.length /* + (_isLoading ? 1 : 0) */,
      itemBuilder: (context, index) {
        if (index == _filteredItems.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        return _buildItem(_filteredItems[index]);
      },
    );
  }

  Widget _buildItem(T item) {
    final isEnabled = widget.enabledItemFunction?.call(item) ?? true;
    final isSelected = _selectedItems.contains(item);

    if (widget.itemBuilder != null) {
      return InkWell(
        onTap: isEnabled ? () => _toggleItem(item) : null,
        child: widget.itemBuilder!(item, isSelected),
      );
    }

    return ListTile(
      enabled: isEnabled,
      selected: isSelected,
      title: Text(
        widget.getLabel(item),
        style: widget.dropdownTextStyle?.copyWith(
          color: !isEnabled ? Colors.grey : null,
        ),
      ),
      trailing: _buildSelectionIndicator(item, isSelected),
      onTap: isEnabled ? () => _toggleItem(item) : null,
    );
  }

  Widget? _buildSelectionIndicator(T item, bool isSelected) {
    switch (widget.selectionMode) {
      case SelectionMode.multipleWithCheckbox:
        return Checkbox(
          value: isSelected,
          onChanged: (bool? value) => _toggleItem(item),
        );
      case SelectionMode.multipleWithToggle:
        return Switch(
          value: isSelected,
          onChanged: (bool value) => _toggleItem(item),
        );
      default:
        return null;
    }
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isMultiSelectMode()) ...[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${_selectedItems.length} selected',
                                style: widget.dropdownTextStyle,
                              ),
                              Row(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedItems.clear();
                                        _controller.text = _searchQuery;
                                      });
                                      widget.onSelected(_selectedItems);
                                      _overlayEntry?.markNeedsBuild();
                                    },
                                    child: const Text('Clear All'),
                                  ),
                                  TextButton(
                                    onPressed: _selectAll,
                                    child: Text(
                                      _searchQuery.isEmpty
                                          ? 'Select All'
                                          : 'Select All Filtered',
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if (widget.selectionConfig
                                                  ?.minSelections !=
                                              null &&
                                          _selectedItems.length <
                                              widget.selectionConfig!
                                                  .minSelections!) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              widget.selectionConfig!
                                                      .minSelectionsMessage ??
                                                  'Minimum selection limit not reached',
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      _closeDropdown();
                                      _focusNode.unfocus();
                                    },
                                    child: const Text('Done'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (_searchQuery.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'Showing ${_filteredItems.length} of ${widget.items.length} items',
                                style: widget.dropdownTextStyle?.copyWith(
                                  fontSize: 12,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),
                  ],
                  Flexible(
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
                            _buildGroupedItems(),
                          // ..._filteredItems.map(
                          //   (item) => ListTile(
                          //     contentPadding: widget.contentPadding,
                          //     title: Text(
                          //       widget.getLabel(item),
                          //       style: widget.dropdownTextStyle,
                          //     ),
                          //     trailing: widget.isMultiSelect
                          //         ? Checkbox(
                          //             value: _selectedItems.contains(item),
                          //             onChanged: (_) => _toggleItem(item),
                          //           )
                          //         : null,
                          //     onTap: () => _toggleItem(item),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
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
                    hintText: _isOpen && _isMultiSelectMode()
                        ? 'Type to search...'
                        : widget.hint,
                    hintStyle: widget.hintStyle,
                    border: widget.border ?? const OutlineInputBorder(),
                    contentPadding: widget.contentPadding,
                    prefixIcon: widget.prefixIcon,
                    suffixIcon: widget.suffixIcon ??
                        IconButton(
                          icon: const Icon(Icons.arrow_drop_down),
                          onPressed: () {
                            if (_isOpen) {
                              _closeDropdown();
                              _focusNode.unfocus();
                            } else {
                              _focusNode.requestFocus();
                            }
                          },
                        ),
                  ),
            ),
          ),
        ),
        _buildSelectedItemsChips(),
      ],
    );
  }
}
