import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Top-level function for notification response handling
@pragma('vm:entry-point')
void onDidReceiveNotificationResponse(NotificationResponse response) async {
  final String? payload = response.payload;
  if (payload != null) {
    debugPrint('Notification payload: $payload');
    FirebaseMessagingService.handleNotificationData(payload);
  }
}

class FirebaseMessagingService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Android notification channel
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  Future<void> initialize() async {
    // Request permissions for iOS
    await _requestPermissions();

    // Initialize Local Notifications
    await _initLocalNotifications();

    // Create notification channel for Android
    await _createNotificationChannel();

    // Fetch FCM Token
    await _getFCMToken();

    // Set foreground notification options for iOS
    await _setForegroundNotificationPresentationOptions();

    // Handle foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Foreground message received: ${message.notification?.title}");
      debugPrint("Message data: ${message.data}");
      showLocalNotification(message);
    });

    // Handle notification click when the app is in background/terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("User tapped on notification: ${message.notification?.title}");
      handleNotificationTap(message);
    });

    // Handle initial message when app is launched from notification
    _handleInitialMessage();
  }

  /// Request notification permissions (iOS)
  Future<void> _requestPermissions() async {
    try {
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );
      debugPrint("User permission status: ${settings.authorizationStatus}");

      // Check if permissions are granted
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        debugPrint('User granted provisional permission');
      } else {
        debugPrint('User declined or has not accepted permission');
      }
    } catch (e) {
      debugPrint("Error requesting permissions: $e");
    }
  }

  /// Set iOS foreground notification presentation options
  Future<void> _setForegroundNotificationPresentationOptions() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Show Local Notification when app is in foreground
  static Future<void> showLocalNotification(RemoteMessage? message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
          icon: '@mipmap/ic_launcher',
        );

    // iOS notification details
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'default.caf',
      badgeNumber: 1,
      categoryIdentifier: 'MESSAGE_CATEGORY',
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotificationsPlugin.show(
      message.hashCode,
      message?.notification?.title ?? 'إشعار جديد',
      message?.notification?.body ?? 'لديك إشعار جديد',
      platformDetails,
      payload: jsonEncode(message?.data),
    );
  }

  /// Initialize Local Notifications
  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings (simplified - no deprecated parameters)
    const DarwinInitializationSettings iosInitSettings =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
          // onDidReceiveLocalNotification is deprecated and removed
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _localNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  /// Create notification channel for Android
  Future<void> _createNotificationChannel() async {
    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
  }

  /// Handle notification tap from Firebase
  static void handleNotificationTap(RemoteMessage message) {
    final data = message.data;
    debugPrint('Notification tapped with data: $data');
    handleNotificationData(jsonEncode(data));
  }

  /// Handle initial message when app is launched from notification
  Future<void> _handleInitialMessage() async {
    RemoteMessage? initialMessage = await _firebaseMessaging
        .getInitialMessage();

    if (initialMessage != null) {
      debugPrint('App launched from notification: ${initialMessage.data}');
      handleNotificationTap(initialMessage);
    }
  }

  /// Process notification data and navigate accordingly
  static void handleNotificationData(String payload) {}

  /// Retrieve and print the FCM Token
  Future<String?> _getFCMToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      debugPrint("FCM Token: $token");
      FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({'fcmToken': token});
      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((String token) {
        debugPrint("FCM Token refreshed: $token");
        // Send the new token to your server
        FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .update({'fcmToken': token});
      });

      return token;
    } catch (e) {
      debugPrint("Error fetching FCM token: $e");
      return null;
    }
  }

  /// Get the current FCM token
  Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      debugPrint("Error getting FCM token: $e");
      return null;
    }
  }

  /// Clear all notifications
  Future<void> clearAllNotifications() async {
    await _localNotificationsPlugin.cancelAll();
  }

  /// Clear iOS badge count
  Future<void> clearBadgeCount() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Get current notification settings
  Future<NotificationSettings> getNotificationSettings() async {
    return await _firebaseMessaging.getNotificationSettings();
  }
}
