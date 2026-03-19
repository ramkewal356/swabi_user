import 'dart:io';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Initialize Notification
  static Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    await _requestPermission();
    await _initLocalNotification(navigatorKey);
    _firebaseListeners(navigatorKey);
  }

  /// Request permission
  static Future<void> _requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Local notification initialization with customized design & click handler
  static Future<void> _initLocalNotification(
      GlobalKey<NavigatorState> navigatorKey) async {
    // Here you can set up your custom template/styles, channels, etc.
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );
    // On notification tap (when app in foreground/background)
    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          _handleNotificationTap(response.payload!, navigatorKey);
        }
      },
    );
  }

  /// Get FCM Token
  static Future<String?> getToken() async {
    String? token = await _messaging.getToken();
    debugPrint("FCM Token: $token");
    return token;
  }

  String getPlatformType() {
    if (kIsWeb) {
      return "WEB";
    } else if (Platform.isAndroid) {
      return "ANDROID";
    } else if (Platform.isIOS) {
      return "IOS";
    } else {
      return "UNKNOWN";
    }
  }

  /// Firebase listeners (foreground, background, notification tap)
  static void _firebaseListeners(GlobalKey<NavigatorState> navigatorKey) {
    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showNotification(message);
    });

    // When app is already opened by clicking notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        // Pass your payload to handler
        _handleNotificationTap(json.encode(message.data), navigatorKey);
      }
      debugPrint("Notification Clicked: ${message.data}");
    });
  }

  /// Show local notification with payload & custom design
  static Future<void> _showNotification(RemoteMessage message) async {
    // You can extract the payload (data) here
    final payload = json.encode(message.data);

    // Here you can customize the notification appearance more if needed
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel',
      'Default',
      channelDescription: 'Default notifications',
      importance: Importance.max,
      priority: Priority.high,

      // Examples of further customization:
      // styleInformation: BigTextStyleInformation(''), // show large text
      // icon: '@mipmap/ic_notification', // Use different icon
      // color: Colors.green, // Color for notification
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      id: 0,
      title: message.notification?.title ?? 'New Notification',
      body: message.notification?.body ?? '',
      notificationDetails: details,
      payload: payload, // pass the payload as String
    );
  }

  /// Handle notification tap: open the app and navigate based on payload
  static void _handleNotificationTap(
      String payload, GlobalKey<NavigatorState> navigatorKey) {
    try {
      final data = json.decode(payload);
      // For example, use the payload to route user:
      // Here you can switch based on data fields
      // This assumes you have named routes set up.

      // Example: If your payload has a 'screen' property, navigate there
      var screen = data['screen'];
      if (screen != null && navigatorKey.currentState != null) {
        navigatorKey.currentState!.pushNamed(screen, arguments: data);
      } else {
        // Default behaviour: just open home
        navigatorKey.currentState?.pushNamed('/');
      }
    } catch (e) {
      // If decode fails, fallback to home
      navigatorKey.currentState?.pushNamed('/');
    }
  }
}
