import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:shared_preferences/shared_preferences.dart'; // Using auth_io

class AuthService {
  static const List<String> scopes = [
    'https://www.googleapis.com/auth/firebase.messaging',
  ];

  static Future<String?> getServerKey() async {
    try {
      final credentials = auth.ServiceAccountCredentials.fromJson({
        "type": "service_account",
        "project_id": "chat-app-495fc",
        "private_key_id": "2e55c91b9928500cdcc0efbe69c7d6933fd98968",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCbX9qiwYHKHBLF\ngfh11kgtO2ZnsFFTXm8vJ4WX/ERk8N2jBhIAV2UQXzqMM5YjWbHMhnS6J4Xgk5QB\nI+ONDmdaPIAm//zWduO4rH2Do60Z5IFABE16v76/KstE43y0VQEj6icStcCCKeZn\nYZcIxTc159H3FniVlP20iftjgLyczGuyzRpRPn1lq/Wrh84axI3vMPInQqB85gx4\nwoZ9alqXbNs2ruKswCKiaDVSmiFAuQ27PdYL+WHI5VymsjZu9mHFtnjiDiJr5hV8\nw8Ron4enmxKkEgAwqS2fvF2+QVS5qKGX4TMEzjLC40g4UBoCTiZWYpkyVMzU5q+s\nFuvH4zVzAgMBAAECggEABlH0A5/UcY4Kc29HKzVACAWns5Biq9NRDtLQO9pJRpky\nTXcp6fVOyUeJCvqZi67n18EhDrtx1iyaniCWw9Ocqk6AtgAUCaiaDcEydSrbbTde\nzJBVkyh+j/8jzUBlql400YBXqOACHdP/fnVj8+Q1y+MLUZOKlycRhN5XU/kAyG32\nDVLSkdvLsj5iUuJZGKaLLGOgQq0M//PdikXTATLbqIr9MO100XasQUV2IhXK8OJG\nIXTn1Xjg4pOEXAdbg7hImpLABGNMdeY4Twv7VHleZ57Tzjo5TpSYOWRWifc8fI5s\nTgO+H6rB9fDoPbCyUcv/HLDAGY2ZUEn626JbPMUdbQKBgQDOi4cs0XMXqrxjFuZZ\nUR9mmbNEplMjnWMSmBOCwHWXuBEhCqoKiBzEi4Va5VANQXFuYpsfTGaaNaxoF0qm\nITvpBq+Q1Axg2Dm/0eQFXz2LilZNdZlfz5WlkXy7c002zaGh5jp9Iwiar2YeiiUk\nEy6H34S0cdtnvC2MIcWXUA+EdwKBgQDAk8BHu+f+ONr/6sDLvjRBWTktkAvdIHkN\nvhwgRdgT9p2MoTWanJCCN9HVRNHgx7zfqgiW/XnwAhEHbPkTtpi30dS0wu3YMFxe\novzW0wbU+68RCjuo/iB3XR2AfjkikT1ZYD7G1wMKfiiv2183UKz3yUor6bdMjkBy\nbxrH/vzB5QKBgCLypueldPTvNbsKd+Vq/YYtwZB/GBgxnD7cLoj0KbGHOpa9qDHp\n//wdo23S2S21Ag1sb9Tm54F2TXq7Xi0n+Gwgbnpx9ro4O+VCDXP/Pnmq6ZlnqZD1\nnduK93D8PHdmac/sFb9wuxb5UK0gMNKe0EO7RUgG79nolEheuoE00btXAoGAJynl\nILGGLJ1DbGhBbS3xUpjil/GDeCTyeWkAL1AE8Ypl4AOo8xiECvdvJQAp7pywPIxH\n0u0Zr0W8UNZIkUnBJSD3MQuzcxPitRxQbx/bc9T7dWuvVl7YG25EYa1J0U3YPCTm\nn2l6pNejTqA+bPFrO7kj7GpLbLZBRQRzXdjtbkECgYEAy2XfDKrPCcaeaV6gbQhI\n9vz1WvTtI7OAisyBWGYIXXeoMHwCRZN6Eky3UXpt2I1sfUntZUf2P0hSoARwXRmc\nm54wwDz8KdxQeoELf+pNGDL6dMG36HC/MqrxRtJSQJlT9MPPLlRAPRQ5cFbkLtp0\n6deOQ40Opf8vKz3SKzu8Rtc=\n-----END PRIVATE KEY-----\n",
        "client_email":
            "firebase-adminsdk-fbsvc@chat-app-495fc.iam.gserviceaccount.com",
        "client_id": "114727451074012780701",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40chat-app-495fc.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com",
      });

      final client = await auth.clientViaServiceAccount(credentials, scopes);
      final serverKey = client.credentials.accessToken.data;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('FCM_ACCESS_TOKEN', serverKey);
      return serverKey;
    } catch (_) {}
    return null;
  }

  static Future<String?> getStoredAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('FCM_ACCESS_TOKEN');
  }
}
