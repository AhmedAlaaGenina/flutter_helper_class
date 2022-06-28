import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../screens/notification_screen.dart';
import 'local_notification_api.dart';

class NotificationApi {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;

  /// How to use it?
  /// in main()
  // await NotificationApi.init();


  static Future<void> init() async {

    // Enabling background Message
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Enabling foreground notifications for Android
    // by Creating A channel on Android devices
    await LocalNotificationApi.localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
            LocalNotificationApi.androidNotificationChannel);

    // Enabling foreground notifications for IOS
    await firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

     LocalNotificationApi.init();
     NotificationApi.requestPermission();
     NotificationApi.foregroundNotification();
     NotificationApi.setupInteractedMessage();
    
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

    print('User granted permission: ${settings.authorizationStatus}');
  }

  /// Handle background message only not notification
  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  /// Handle Foreground message and notification
  static void foregroundNotification() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        /// here handle ui of notification
        /// to get notification must use flutter_local_notifications

        print('Message also contained a notification: ${message.notification}');

        /// Interacted with UI in [(Foreground)] (when app is opened)
        /// in LocalNotificationApi.showNotification
        LocalNotificationApi.showNotification(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          payload:
              "notification.payload", // value that pass from notification to app
        );
      }
    });
  }

  /// Interacted with UI in [(Background or Terminated)] (when app is Closed)
  static Future<void> setupInteractedMessage() async {
    // Get any messages which caused the application to open from
    // a [(Terminated)] state.
    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the [(Background)] via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  static void _handleMessage(RemoteMessage message) {
    // It is assumed that all messages contain a data field with the key 'type'
    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen

    // if app in Background or Terminated that will work fine

    /// if (message.data['type'] == 'chat') {
    print("Opened Notification");
    print(message.data);
    rootScaffoldMessengerKey.currentState
        ?.showSnackBar(const SnackBar(content: Text("Opened Notification")));

    ///key.currentContext!
    Navigator.of(rootNavigatorKey.currentContext!).push(MaterialPageRoute(
      builder: (context) => const NotificationScreen(),
    ));

    /// }
  }
}
