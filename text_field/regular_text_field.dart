import 'package:flutter/material.dart';

import 'forma_base_input.dart';
import 'forma_input_mixin.dart';

class FormaRegularTextField extends FormaBaseInput {
  final TextEditingController? controller;
  const FormaRegularTextField({
    super.key,
    super.validator,
    required super.label,
    super.initialValue,
    super.action,
    super.type,
    super.formatters,
    super.enabled,
    super.onChange,
    super.onSubmit,
    super.onSave,
    super.maxLength,
    this.controller,
    super.onFocusChange,
    super.autoSubmit,
    super.foucsNode,
    super.autovalidateMode,
    super.suffix,
    super.suffixIcon,
    super.prefixWidget,
    super.height,
    super.maxLines,
    super.radius,
  });
  @override
  State<FormaRegularTextField> createState() => _FormaRegularTextFieldState();
}

class _FormaRegularTextFieldState extends State<FormaRegularTextField>
    with FormaInput<FormaRegularTextField> {
  final TextEditingController _controller = TextEditingController();
  @override
  TextEditingController? get inputController =>
      widget.controller ?? _controller;

  @override
  double get getHeight => widget.height ?? 48;

  @override
  void didUpdateWidget(covariant FormaRegularTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      Future.delayed(Duration.zero, () {
        _controller.text = widget.initialValue ?? "";
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _controller.text = widget.initialValue ?? "";
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    });
  }
}
