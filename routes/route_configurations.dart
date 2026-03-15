import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../di/injection_container.dart';
import 'admin_session_router_refresh_notifier.dart';
import 'routes.dart';

class RouteConfigurations {
  static final RouteConfigurations _instance = RouteConfigurations._internal();

  static RouteConfigurations get instance => _instance;
  static late final GoRouter router;
  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();

  factory RouteConfigurations() => _instance;

  RouteConfigurations._internal();

  static void initRouter() {
    final List<RouteBase> routes = [
      GoRoute(
        path: AppRoutesPath.splash,
        name: AppRoutesName.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutesPath.login,
        name: AppRoutesName.login,
        builder: (context, state) => const LoginPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AdminShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutesPath.overview,
                name: AppRoutesName.overview,
                builder: (context, state) => const OverviewPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutesPath.users,
                name: AppRoutesName.users,
                builder: (context, state) => const UsersPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutesPath.wallets,
                name: AppRoutesName.wallets,
                builder: (context, state) => const WalletsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutesPath.payments,
                name: AppRoutesName.payments,
                builder: (context, state) => const PaymentsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutesPath.packages,
                name: AppRoutesName.packages,
                builder: (context, state) => const PackagesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutesPath.settings,
                name: AppRoutesName.settings,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ];

    router = GoRouter(
      debugLogDiagnostics: true,
      initialLocation: AppRoutesPath.splash,
      refreshListenable: getIt<AdminSessionRouterRefreshNotifier>(),
      redirect: AppRouteRedirector(sessionBloc: getIt()).redirect,
      navigatorKey: parentNavigatorKey,
      routes: routes,
    );
  }

  static Page getPage({
    required Widget child,
    required GoRouterState state,
    bool fullScreenDialog = false,
  }) {
    return MaterialPage(
      key: state.pageKey,
      child: child,
      fullscreenDialog: fullScreenDialog,
    );
  }

  static void setPageTitle(String title, BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
      ApplicationSwitcherDescription(
        label: title,
        primaryColor: Theme.of(context).primaryColor.toARGB32(),
      ),
    );
  }
}
