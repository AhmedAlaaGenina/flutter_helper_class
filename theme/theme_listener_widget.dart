import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:typo_color_them/theme/bloc/theme_bloc.dart';

class ThemeListener extends StatefulWidget {
  final Widget child;

  const ThemeListener({super.key, required this.child});

  @override
  State<ThemeListener> createState() => _ThemeListenerState();
}

class _ThemeListenerState extends State<ThemeListener>
    with WidgetsBindingObserver {
  Brightness? _previousBrightness;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Store the initial brightness
    _previousBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    // Initialize the theme when the widget is created
    context.read<ThemeBloc>().add(const ThemeInitialize());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    // Only trigger an update if brightness actually changed
    if (brightness != _previousBrightness) {
      _previousBrightness = brightness;
      final themeBloc = context.read<ThemeBloc>();
      final state = themeBloc.state;

      if (state.themeMode == ThemeMode.system) {
        // Force theme rebuild by emitting a new state
        final newThemeData = state.createThemeData();
        themeBloc.add(ThemeUpdated(newThemeData));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
