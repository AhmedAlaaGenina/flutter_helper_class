import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Local Notification Api
class LocalNotificationApi {
  /// init local notification
  static final FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();
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

    final bool? resultIos = await localNotifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    final bool? resultMac = await localNotifications
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    await localNotifications.initialize(
      initSettings,
      // onDidReceiveBackgroundNotificationResponse: (details) {
      //   print("onDidReceiveBackgroundNotificationResponse: ${details.payload}");
      // },
      /// on did receive notification response = for when app is opened via notification while in foreground on android
      onDidReceiveNotificationResponse: onTapNotification,
    );
  }

  /// show notification
  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    localNotifications.show(
      id,
      title,
      body,
      _notificationDetails(),
      payload: payload,
    );
  }

  /// notification Details
  static NotificationDetails _notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        androidNotificationChannel.id, // channel id
        androidNotificationChannel.name, // channel name
        channelDescription: androidNotificationChannel.description,
        //channel description
        importance: Importance.max,
        playSound: true,
        icon: 'app_icon',
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
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
    // if (navigatorKey.currentContext != null) {
    //   Navigator.of(navigatorKey.currentContext!).push(
    //     MaterialPageRoute(
    //       builder: (context) => RejectedDetails(
    //         transactionId: map['idTransaction'],
    //         courseId: map['courseId'],
    //       ),
    //     ),
    //   );
    // }
  }
}
