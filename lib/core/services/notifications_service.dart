import 'dart:convert';

import 'package:chats_app/core/services/fcm_auth_service.dart';
import 'package:dio/dio.dart';

class NotificationsService {
  static final Dio _dio = Dio();
  static const String _projectId = "chat-app-495fc";
  static const String _fcmUrl =
      "https://fcm.googleapis.com/v1/projects/$_projectId/messages:send";

  static Future<void> sendFcmNotification({
    required String title,
    required String body,
    required String fcmToken,
  }) async {
    try {
      String? accessToken = await AuthService.getStoredAccessToken();
      accessToken ??= await AuthService.getServerKey();

      Map<String, dynamic> notificationPayload = {
        "message": {
          "token": fcmToken,
          "notification": {"title": title, "body": body},
          "data": {},
          "android": {
            "notification": {
              "click_action": "FLUTTER_NOTIFICATION_CLICK",
              "sound": "default",
            },
            "priority": "high",
          },
          "apns": {
            "payload": {
              "aps": {
                "sound": "default",
                "content_available": true,
                "mutable_content": true,
              },
            },
            "headers": {
              "apns-priority": "10",
              "apns-topic": "com.linesteel.client",
            },
          },
        },
      };

      final _ = await _dio.post(
        _fcmUrl,
        options: Options(
          headers: {
            "Authorization": "Bearer $accessToken",
            "Content-Type": "application/json",
          },
        ),
        data: jsonEncode(notificationPayload),
      );
    } catch (_) {}
  }
}
