import 'dart:async';
import 'dart:math';

import 'package:fashion/config/routes/routes.dart';
import 'package:fashion/core/notification_manager/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

/// Local Notification Api
class LocalNotificationApi {
  /// init local notification
  static final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// init android icon
  static const android = AndroidInitializationSettings('app_icon');

  static const DarwinInitializationSettings ios = DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );
  static const DarwinInitializationSettings macOS =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  static const LinuxInitializationSettings linux =
      LinuxInitializationSettings(defaultActionName: 'Open notification');

  /// init channel
  static const AndroidNotificationChannel androidNotificationChannel =
      AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  /// when tap in notification to open specific screen or anything
  static Future init() async {
    const initSettings = InitializationSettings(
      android: android,
      iOS: ios,
      macOS: macOS,
      linux: linux,
    );

    final bool? resultIos = await localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    final bool? resultMac = await localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    final notificationAppLaunchDetails =
        await localNotificationsPlugin.getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.didNotificationLaunchApp) {
      onTapNotification(notificationAppLaunchDetails.notificationResponse!);
    }

    await localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,

      /// on did receive notification response = for when app is opened via notification while in foreground on android
      onDidReceiveNotificationResponse: onTapNotification,
    );
  }

  /// Cancel notification
  static Future<void> cancelNotification() async {
    await localNotificationsPlugin.cancel(0);
  }

  /// show notification
  static Future showNotification({
    int? id,
    String? title,
    String? body,
    String? payload,
  }) async {
    localNotificationsPlugin.show(
      id ?? Random().nextInt(100),
      title,
      body,
      _notificationDetails(),
      payload: payload,
    );
  }

  /// notification Details
  static NotificationDetails _notificationDetails() {
    return NotificationDetails(
      android: _androidNotificationDetails(),
      iOS: const DarwinNotificationDetails(),
      macOS: const DarwinNotificationDetails(),
      linux: const LinuxNotificationDetails(),
    );
  }

  /// Android Notification Details
  static AndroidNotificationDetails _androidNotificationDetails() {
    return AndroidNotificationDetails(
      androidNotificationChannel.id, // channel id
      androidNotificationChannel.name, // channel name
      channelDescription:
          androidNotificationChannel.description, //channel description
      importance: Importance.max,
      playSound: true,
      icon: 'app_icon',
      priority: Priority.high,
    );
  }

  static Map convertPayloadToMap(String payload) {
    final String nPayload = payload.substring(1, payload.length - 1);
    List<String> split = [];
    nPayload.split(",").forEach((String s) => split.addAll(s.split(":")));
    Map mapped = {};
    for (int i = 0; i < split.length + 1; i++) {
      if (i % 2 == 1) {
        mapped.addAll({split[i - 1].trim().toString(): split[i].trim()});
      }
    }
    return mapped;
  }

  static void onTapNotification(NotificationResponse details) {
    debugPrint("onDidReceiveNotificationResponse: ${details.payload}");
    var map = convertPayloadToMap(details.payload!);

    ///key.currentContext!
    if (RouteConfigurations.parentNavigatorKey.currentState != null) {
      if (map[NotificationType.type] == NotificationType.newRequest) {
        RouteConfigurations.parentNavigatorKey.currentState!.context
            .pushNamed(AppRoutes.requestsScreen, extra: true);
      } else if (map[NotificationType.type] == NotificationType.orderAction) {
        RouteConfigurations.router
            .goNamed(AppRoutes.myOrderScreen, extra: true);
      }
    }
  }

  @pragma('vm:entry-point')
  static void notificationTapBackground(
      NotificationResponse notificationResponse) {
    // handle actions
    debugPrint(
        "onDidReceiveBackgroundNotificationResponse: ${notificationResponse.payload}");
  }
}
