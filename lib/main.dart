import 'dart:developer';

import 'package:chats_app/core/router/app_router.dart';
import 'package:chats_app/core/router/routes.dart';
import 'package:chats_app/core/services/firebase_messaging.dart';
import 'package:chats_app/core/style/themes.dart';
import 'package:chats_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log(await FirebaseMessaging.instance.getToken() ?? 'Null');
  await FirebaseMessagingService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppThemes.theme,
      onGenerateRoute: AppRouter().onGenerateRoute,
      initialRoute: Routes.splash,
    );
  }
}
