import 'package:fashion/core/constant/constants.dart';
import 'package:fashion/core/helpers/helpers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';

class _AppPaths {
  _AppPaths._();

  static const String initLocation = '/';
  static const String authScreen = "/authScreen";
  static const String homeScreen = '/homeScreen';
  static const String filterScreen = 'filterScreen';
  static const String favouriteScreen = 'favouriteScreen';
  static const String myClosetScreen = '/myClosetScreen';
  static const String clothesItemScreen = 'clothesItemScreen';
  static const String chatScreen = 'chatScreen';
  static const String addItemScreen = 'addItemScreen';
  static const String orderScreen = 'orderScreen';
  static const String myOrderScreen = '/myOrdersScreen';
  static const String requestsScreen = 'requestsScreen';
  static const String profileScreen = '/profileScreen';
  static const String accountScreen = '/accountScreen';
  static const String settingScreen = 'settingScreen';
  static const String preferencesScreen = 'preferencesScreen';
  static const String photoInstructionScreen = 'photoInstructionScreen';
  static const String cliqPayment = 'cliqPayment';
}

class RouteConfigurations {
  static final RouteConfigurations _instance = RouteConfigurations._internal();

  static RouteConfigurations get instance => _instance;
  static late final GoRouter router;
  static final GlobalKey<NavigatorState> parentNavigatorKey =
      GlobalKey<NavigatorState>();

  /// We Added TO Handel Bottom Navigation
  static final GlobalKey<NavigatorState> homeTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> myOrdersTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> myClosetTabNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> profileTabNavigatorKey =
      GlobalKey<NavigatorState>();

  factory RouteConfigurations() => _instance;

  RouteConfigurations._internal() {
    final routes = [
      GoRoute(
        parentNavigatorKey: parentNavigatorKey,
        path: _AppPaths.authScreen,
        name: AppRoutes.authScreen,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            key: state.pageKey,
            child: const AuthScreen(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: parentNavigatorKey,
        path: _AppPaths.accountScreen,
        name: AppRoutes.accountScreen,
        pageBuilder: (context, state) {
          var isCreate = state.extra ?? true;
          return getPage(
            state: state,
            child: AccountScreen(isCreate: isCreate as bool),
          );
        },
      ),

      /// Bottom Navigation
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: parentNavigatorKey,
        branches: [
          StatefulShellBranch(
            navigatorKey: homeTabNavigatorKey,
            routes: [
              GoRoute(
                path: _AppPaths.homeScreen,
                name: AppRoutes.homeScreen,
                pageBuilder: (context, GoRouterState state) {
                  return getPage(
                    child: const HomeScreen(),
                    state: state,
                  );
                },
                routes: [
                  GoRoute(
                    parentNavigatorKey: parentNavigatorKey,
                    path: _AppPaths.filterScreen,
                    name: AppRoutes.filterScreen,
                    pageBuilder: (context, state) {
                      return getPage(
                        state: state,
                        child: const FilterScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    parentNavigatorKey: parentNavigatorKey,
                    path: _AppPaths.favouriteScreen,
                    name: AppRoutes.favouriteScreen,
                    pageBuilder: (context, state) {
                      return getPage(
                        state: state,
                        child: const FavouriteScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    parentNavigatorKey: parentNavigatorKey,
                    path: '${_AppPaths.clothesItemScreen}/:id',
                    name: AppRoutes.clothesItemScreen,
                    pageBuilder: (context, state) {
                      var fromNotification = state.extra ?? false;
                      return getPage(
                        state: state,
                        child: ClothesItemDetailsScreen(
                          itemId: state.pathParameters['id'] ?? "No Id",
                          fromNotification: fromNotification as bool,
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    parentNavigatorKey: parentNavigatorKey,
                    path: _AppPaths.cliqPayment,
                    name: AppRoutes.cliqPayment,
                    pageBuilder: (context, state) {
                      var price = state.extra;
                      return getPage(
                        state: state,
                        child: CliqPaymentScreen(price: price as double),
                        fullScreenDialog: true,
                      );
                    },
                  ),
                  GoRoute(
                    parentNavigatorKey: parentNavigatorKey,
                    path: _AppPaths.chatScreen,
                    name: AppRoutes.chatScreen,
                    pageBuilder: (context, state) {
                      var clothesId = state.extra;
                      return getPage(
                        state: state,
                        child: Chat(clothesId: clothesId as String),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: myOrdersTabNavigatorKey,
            routes: [
              GoRoute(
                path: _AppPaths.myOrderScreen,
                name: AppRoutes.myOrderScreen,
                pageBuilder: (context, state) {
                  var fromNotification = state.extra ?? false;
                  return getPage(
                    child: MyOrdersScreen(
                        fromNotification: fromNotification as bool),
                    state: state,
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: myClosetTabNavigatorKey,
            routes: [
              GoRoute(
                path: _AppPaths.myClosetScreen,
                name: AppRoutes.myClosetScreen,
                pageBuilder: (context, state) {
                  return getPage(
                    child: const MyClosetScreen(),
                    state: state,
                  );
                },
                routes: [
                  GoRoute(
                    parentNavigatorKey: parentNavigatorKey,
                    path: _AppPaths.addItemScreen,
                    name: AppRoutes.addItemScreen,
                    pageBuilder: (context, state) {
                      return getPage(
                        state: state,
                        child: const AddItemScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    parentNavigatorKey: parentNavigatorKey,
                    path: _AppPaths.orderScreen,
                    name: AppRoutes.orderScreen,
                    pageBuilder: (context, state) {
                      return getPage(
                        state: state,
                        child: const OrdersScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    parentNavigatorKey: parentNavigatorKey,
                    path: _AppPaths.requestsScreen,
                    name: AppRoutes.requestsScreen,
                    pageBuilder: (context, state) {
                      var fromNotification = state.extra ?? false;
                      return getPage(
                        state: state,
                        child: RequestsScreen(
                            fromNotification: fromNotification as bool),
                      );
                    },
                  ),
                  GoRoute(
                    parentNavigatorKey: parentNavigatorKey,
                    path: _AppPaths.photoInstructionScreen,
                    name: AppRoutes.photoInstructionScreen,
                    pageBuilder: (context, state) {
                      return getPage(
                        state: state,
                        child: const PhotoInstructionScreen(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: profileTabNavigatorKey,
            routes: [
              GoRoute(
                path: _AppPaths.profileScreen,
                name: AppRoutes.profileScreen,
                pageBuilder: (context, state) {
                  return getPage(
                    child: const ProfileScreen(),
                    state: state,
                  );
                },
                routes: [
                  GoRoute(
                    parentNavigatorKey: parentNavigatorKey,
                    path: _AppPaths.settingScreen,
                    name: AppRoutes.settingScreen,
                    pageBuilder: (context, state) {
                      return getPage(
                        state: state,
                        child: const SettingsScreen(),
                      );
                    },
                  ),
                  GoRoute(
                    parentNavigatorKey: parentNavigatorKey,
                    path: _AppPaths.preferencesScreen,
                    name: AppRoutes.preferencesScreen,
                    pageBuilder: (context, state) {
                      return getPage(
                        state: state,
                        child: const PreferencesScreen(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
        pageBuilder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return getPage(
            child: BottomNavigation(child: navigationShell),
            state: state,
          );
        },
      ),
    ];
    router = GoRouter(
      debugLogDiagnostics: true,
      redirect: (context, state) {
        String currentLocation = state.matchedLocation;
        bool isFirstTimeOpenApp =
            CacheHelper.getData(key: CacheKeys.isFirstTimeOpenApp) ?? true;
        final bool userAuthenticated =
            FirebaseAuth.instance.currentUser != null;
        bool isUserExists =
            CacheHelper.getData(key: CacheKeys.userExists) ?? false;
        final bool onStartScreen = currentLocation == _AppPaths.initLocation;
        final bool onLoginScreen = currentLocation == _AppPaths.authScreen;
        final bool onAccountScreen = currentLocation == _AppPaths.accountScreen;
        if (isFirstTimeOpenApp) {
          // make isFirstTimeOpenApp false
          CacheHelper.setData(key: CacheKeys.isFirstTimeOpenApp, value: false);
          // because user maybe still authenticated if he remove the app
          if (isFirstTimeOpenApp) FirebaseAuth.instance.signOut();
        }

        // if (!userAuthenticated || isFirstTimeOpenApp) {
        //   // make isFirstTimeOpenApp false
        //   CacheHelper.setData(key: CacheKeys.isFirstTimeOpenApp, value: false);
        //   // because user maybe authenticated if he remove the app
        //   if (isFirstTimeOpenApp) FirebaseAuth.instance.signOut();
        //   return onLoginScreen ? null : _AppPaths.authScreen;
        // }

        if (userAuthenticated) {
          if (!isUserExists) {
            return onAccountScreen ? null : _AppPaths.accountScreen;
          }
          if (onStartScreen || onLoginScreen) {
            return _AppPaths.homeScreen;
          }
        }
        if (!userAuthenticated && onStartScreen) {
          return _AppPaths.homeScreen;
        }

        return null;
      },
      navigatorKey: parentNavigatorKey,
      // initialLocation: _AppPaths.authScreen,
      initialLocation: _AppPaths.homeScreen,
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
        primaryColor: Theme.of(context).primaryColor.value,
      ),
    );
  }
}
