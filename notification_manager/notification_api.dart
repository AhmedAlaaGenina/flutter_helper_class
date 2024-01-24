import 'package:fashion/config/routes/routes.dart';
import 'package:fashion/core/notification_manager/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:go_router/go_router.dart';

class NotificationApi {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<String?> getDeviceToken() async => await messaging.getToken();

  /// How to use it?
  /// in main()
  // await NotificationApi.init();

  static Future<void> init() async {
    // Enabling foreground notifications for Android
    // by Creating A channel on Android devices
    await LocalNotificationApi.localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
            LocalNotificationApi.androidNotificationChannel);
    LocalNotificationApi.localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // Enabling foreground notifications for IOS
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    LocalNotificationApi.init();
    NotificationApi.requestPermission();
    NotificationApi.foregroundNotification();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(const Duration(milliseconds: 500), () async {
        await NotificationApi.setupInteractedMessage();
      });
    });
    // Enabling background Message
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    var token = await getDeviceToken();
    debugPrint("token: $token");
  }

  static void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }

  /// Handle background message only not notification
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    debugPrint("Handling a background message: ${message.data}");
  }

  /// Handle foreground message and notification
  static void foregroundNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        /// here handle ui of notification
        /// to get notification must use flutter_local_notifications

        debugPrint(
            'Message also contained a notification: ${message.notification}');

        /// Interacted with UI in [(Foreground)] (when app is opened)
        /// in LocalNotificationApi.showNotification
        LocalNotificationApi.showNotification(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          payload: message.data
              .toString(), // value that pass from notification to app
        );
      }
    });
  }

  /// Interacted with UI in [(Background or Terminated)] (when app is Closed)
  static Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a [(Terminated)] state.
    messaging.getInitialMessage().then(_handleMessage);

    // Also handle any interaction when the app is in the [(Background)] via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  static void _handleMessage(RemoteMessage? message) {
    if (message == null) return;
    // It is assumed that all messages contain a data field with the key 'type'
    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen

    // if app in Background or Terminated that will work fine
    debugPrint("Opened Notification Data : ${message.data}");
    ///we can use normal navigatorKey.currentContext! to Do what we want
    if (RouteConfigurations.parentNavigatorKey.currentState != null) {
      if (message.data[NotificationType.type] == NotificationType.newRequest) {
        RouteConfigurations.parentNavigatorKey.currentState!.context
            .pushNamed(AppRoutes.requestsScreen, extra: true);
      } else if (message.data[NotificationType.type] ==
          NotificationType.orderAction) {
        RouteConfigurations.router
            .goNamed(AppRoutes.myOrderScreen, extra: true);
      }
    }
  }
}
