import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:forma/core/app_theme/colors/forma_color_theme.dart';
import 'package:forma/core/app_theme/colors/forma_dark_theme.dart';
import 'package:forma/core/app_theme/theme_bloc/theme_bloc.dart';
import 'package:forma/core/app_theme/typography/typography_base.dart';

import 'forma_base_input.dart';

enum InputState { error, focused, unfocused, dimmed }

mixin FormaInput<T extends FormaBaseInput> on State<T> {
  InputState currentState = InputState.unfocused;
  final FocusNode _focusNode = FocusNode();
  String? errorMessage;
  bool obscured = false;
  Timer? _timer;
  bool get disposeController {
    return true;
  }

  TextEditingController? get inputController {
    return null;
  }

  bool get enabled {
    return widget.enabled ?? true;
  }

  bool get readOnly {
    return false;
  }

  Widget? getPrefix() {
    return null;
  }

  String? getHint() {
    return null;
  }

  AutovalidateMode? get autovalidateMode {
    return widget.autovalidateMode;
  }

  Widget? getSuffix() {
    return widget.suffixIcon;
  }

  void onFocusChange(bool hasFocus) {}
  @override
  void initState() {
    super.initState();
    initInput();
  }

  double get getHeight {
    return widget.height ?? 48.h;
  }

  BoxDecoration get inputDecoration {
    return BoxDecoration(
      color: getFillColor(),
      border: Border.all(
        color: getBorderColor(),
        width: 1.5.r,
      ),
      borderRadius: BorderRadius.circular(widget.radius ?? 12.r),
    );
  }

  EdgeInsets get inputPaddings {
    return EdgeInsets.symmetric(
      horizontal: 16.w,
      vertical: 10.h,
    );
  }

  List<Widget> get stackComponents {
    return [];
  }

  FocusNode get inputNode {
    return widget.foucsNode ?? _focusNode;
  }

  Color getFillColor() {
    if (FormaColorTheme is FormaDarkTheme) {
      return FormaColorTheme.of(context).grey500;
    }
    return FormaColorTheme.of(context).white;
  }

  String? Function(String?)? get validator {
    return widget.validator;
  }

  String? inputValidator(
    String? value,
  ) {
    if (validator != null && mounted) {
      String? error = validator!(value);
      if (error != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() {
            currentState = InputState.error;
            errorMessage = error;
          });
        });
      } else {
        if ((widget.enabled ?? true)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            setState(() {
              if (inputNode.hasFocus) {
                currentState = InputState.focused;
              } else {
                currentState = InputState.unfocused;
              }
              errorMessage = null;
            });
          });
        }
      }
      return error;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        if (!(widget.enabled ?? true)) return;
        if (inputNode.hasFocus) {
          currentState = InputState.focused;
        } else {
          currentState = InputState.unfocused;
        }
        errorMessage = null;
      });
    });
    return null;
  }

  void initInput() {
    inputNode.addListener(() {
      if (!mounted) return;
      onFocusChange(inputNode.hasFocus);
      if (widget.onFocusChange != null) {
        widget.onFocusChange!(inputNode.hasFocus);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          if (currentState == InputState.error) return;
          if (inputNode.hasFocus) {
            currentState = InputState.focused;
          } else {
            currentState = InputState.unfocused;
          }
        });
      });
    });
    if (!enabled) {
      setState(() {
        currentState = InputState.dimmed;
      });
    }
  }

  Brightness getCurrentTheme(BuildContext context) {
    final selectedTheme =
        BlocProvider.of<ThemeBloc>(context).state.selectedColorTheme;
    if (selectedTheme is FormaDarkTheme) {
      return Brightness.dark;
    } else {
      return Brightness.light;
    }
  }

  Color getBorderColor() {
    switch (currentState) {
      case InputState.dimmed:
      case InputState.unfocused:
        return FormaColorTheme.of(context).grey500;
      case InputState.error:
        return FormaColorTheme.of(context).error300;
      case InputState.focused:
        return FormaColorTheme.of(context).grey500;
    }
  }

  Widget? get prefixWidget {
    return widget.prefixWidget;
  }

  Color get cursorColor {
    return FormaColorTheme.of(context).grey500;
  }

  TextStyle get mainTextStyle {
    final selectedTheme =
        BlocProvider.of<ThemeBloc>(context).state.selectedColorTheme;
    Color color;
    if (selectedTheme is FormaDarkTheme) {
      color = FormaColorTheme.of(context).white;
    } else {
      color = FormaColorTheme.of(context).black500;
    }
    if (!(widget.enabled ?? true)) {
      color = FormaColorTheme.of(context).error100;
    }
    return FormaTypographyTheme.of(context).xsmall.regular(color: color);
  }

  List<TextInputFormatter>? get formatters {
    return widget.formatters;
  }

  int? get maxLength {
    return widget.maxLength;
  }

  TextInputType? get keyboardType {
    return widget.type;
  }

  onChange(val) {
    if (widget.autoSubmit) {
      _timer?.cancel();
      _timer = Timer(const Duration(seconds: 1), () {
        onSubmit?.call(val);
        _timer = null;
      });
    }

    if (widget.onChange != null) widget.onChange!(val);
  }

  Function(String)? get onSubmit {
    return widget.onSubmit;
  }

  Function(String?)? get onSave {
    return widget.onSave;
  }

  String? get initValue {
    return widget.initialValue;
  }

  BoxConstraints get prefixConstraints {
    return BoxConstraints(
      minWidth: 28.w,
      maxWidth: 32.w,
      maxHeight: 24.r,
      minHeight: 24.r,
    );
  }

  BoxConstraints? get suffixConstraints {
    return null;
  }

  int? get minLines {
    return null;
  }

  int? get maxLines {
    return widget.maxLines ?? 1;
  }

  bool? get showCursor {
    return null;
  }

  Widget? get suffix => widget.suffix;
  @mustCallSuper
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              height: getHeight,
              decoration: inputDecoration,
              padding: inputPaddings,
              child: TextFormField(
                controller: inputController,
                obscureText: obscured,
                onChanged: (val) {
                  onChange(val);
                },
                showCursor: showCursor,
                onFieldSubmitted: onSubmit,
                onSaved: onSave,
                maxLength: maxLength,
                autovalidateMode: autovalidateMode,
                readOnly: readOnly,
                initialValue: inputController != null ? null : initValue,
                focusNode: inputNode,
                minLines: minLines,
                maxLines: maxLines,
                decoration: InputDecoration(
                  counter: null,
                  counterText: "",
                  counterStyle: TextStyle(
                    fontSize: 0,
                    height: 0.001,
                    color: FormaColorTheme.of(context).error100,
                  ),
                  prefixIcon: getPrefix(),
                  prefixIconConstraints: prefixConstraints,
                  errorBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  errorStyle: TextStyle(
                    fontSize: 0,
                    height: 0.001,
                    color: FormaColorTheme.of(context).error300,
                  ),
                  errorText: null,
                  fillColor: getFillColor(),
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  labelText: getHint() != null ? null : widget.label,
                  hintText: getHint(),
                  suffix: suffix,
                  hintStyle: FormaTypographyTheme.of(context).medium.regular(
                        color: FormaColorTheme.of(context).error100,
                      ),
                  floatingLabelStyle:
                      FormaTypographyTheme.of(context).medium.regular(
                            color: getFloatingLabelColor(),
                          ),
                  labelStyle: FormaTypographyTheme.of(context)
                      .small
                      .regular(color: getLabelColor()),
                  filled: true,
                  border: InputBorder.none,
                  alignLabelWithHint: false,
                  prefix: prefixWidget,
                ),
                cursorHeight: 20.h,
                validator: (value) {
                  return inputValidator(value);
                },
                style: mainTextStyle,
                textAlignVertical: TextAlignVertical.center,
                textInputAction: widget.action,
                keyboardType: keyboardType,
                inputFormatters: formatters,
                autocorrect: false,
                enableInteractiveSelection: true,
                enableSuggestions: false,
                enabled: enabled,
                cursorColor: cursorColor,
                keyboardAppearance: getCurrentTheme(context),
              ),
            ),
            ...stackComponents
          ],
        ),
        if (currentState == InputState.error) ...[
          SizedBox(
            height: 4.h,
          ),
          Text(
            errorMessage ?? '',
            style: FormaTypographyTheme.of(context).small.semiBold(
                  color: FormaColorTheme.of(context).error300,
                ),
          )
        ]
      ],
    );
  }

  Color getLabelColor() {
    switch (currentState) {
      case InputState.focused:
        return FormaColorTheme.of(context).primary500;
      case InputState.unfocused:
        return FormaColorTheme.of(context).grey500;
      case InputState.error:
        return FormaColorTheme.of(context).error300;
      case InputState.dimmed:
        return FormaColorTheme.of(context).grey300;
    }
  }

  Color getFloatingLabelColor() {
    switch (currentState) {
      case InputState.focused:
        return FormaColorTheme.of(context).grey500;
      case InputState.unfocused:
        return FormaColorTheme.of(context).grey500;
      case InputState.error:
        return FormaColorTheme.of(context).error300;
      case InputState.dimmed:
        return FormaColorTheme.of(context).grey300;
    }
  }

  @override
  void dispose() {
    inputNode.dispose();
    if (disposeController) {
      inputController?.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }
}
