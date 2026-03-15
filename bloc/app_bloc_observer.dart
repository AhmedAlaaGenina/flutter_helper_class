import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  void _log(
    String message, {
    String name = 'BLOC',
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      developer.log(message, name: name, error: error, stackTrace: stackTrace);
    }
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    _log('🟢 [CREATED] ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    _log('⚡ [EVENT] ${bloc.runtimeType} => ${event.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // Cubits use onChange. Blocs use onTransition.
    // This prevents double-logging for Blocs.
    if (bloc is! Bloc) {
      _log(
        '🔵 [CUBIT CHANGE] ${bloc.runtimeType}\n'
        '   ├─ From: ${change.currentState}\n'
        '   └─ To:   ${change.nextState}',
      );
    }
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    _log(
      '🚀 [BLOC TRANSITION] ${bloc.runtimeType}\n'
      '   ├─ Event: ${transition.event.runtimeType}\n'
      '   ├─ From:  ${transition.currentState}\n'
      '   └─ To:    ${transition.nextState}',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    _log(
      '🚨 [ERROR] ${bloc.runtimeType}\n'
      '   └─ Message: $error',
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    _log('🔴 [CLOSED] ${bloc.runtimeType}');
  }
}
