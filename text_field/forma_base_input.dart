import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class FormaBaseInput extends StatefulWidget {
  final String? Function(String?)? validator;
  final String label;
  final String? initialValue;
  final TextInputAction? action;
  final TextInputType? type;
  final List<TextInputFormatter>? formatters;
  final bool? enabled;
  final Function(String)? onChange;
  final Function(String)? onSubmit;
  final Function(String?)? onSave;
  final void Function(bool focus)? onFocusChange;
  final int? maxLength;
  final double? height;
  final double? radius;
  final int? maxLines;
  final bool autoSubmit;
  final FocusNode? foucsNode;
  final AutovalidateMode? autovalidateMode;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Widget? prefixWidget;

  const FormaBaseInput({
    super.key,
    this.validator,
    this.maxLength,
    required this.label,
    this.initialValue,
    this.action,
    this.type,
    this.formatters,
    this.enabled,
    this.onChange,
    this.onSubmit,
    this.onSave,
    this.onFocusChange,
    this.autoSubmit = false,
    this.foucsNode,
    this.autovalidateMode,
    this.suffix,
    this.suffixIcon,
    this.prefixWidget,
    this.height,
    this.maxLines,
    this.radius,
  });
}
