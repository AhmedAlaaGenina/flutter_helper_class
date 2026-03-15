import 'package:admin_panel_standalone/config/router/app_routes.dart';
import 'package:admin_panel_standalone/features/auth/presentation/bloc/session/admin_session_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouteRedirector {
  AppRouteRedirector({required AdminSessionBloc sessionBloc})
    : _sessionBloc = sessionBloc;

  final AdminSessionBloc _sessionBloc;

  String? redirect(BuildContext context, GoRouterState state) {
    final sessionStatus = _sessionBloc.state.status;
    final isSplashRoute = state.matchedLocation == AppRoutesPath.splash;
    final isLoginRoute = state.matchedLocation == AppRoutesPath.login;

    if (sessionStatus == AdminSessionStatus.unknown) {
      return isSplashRoute ? null : AppRoutesPath.splash;
    }

    if (sessionStatus == AdminSessionStatus.unauthenticated) {
      if (isLoginRoute) return null;
      return AppRoutesPath.login;
    }

    if (isLoginRoute || isSplashRoute) {
      return AppRoutesPath.overview;
    }

    return null;
  }
}
