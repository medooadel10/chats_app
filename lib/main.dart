import 'package:chat_app/core/router/app_router.dart';
import 'package:chat_app/core/router/routes.dart';
import 'package:chat_app/core/style/app_themes.dart';
import 'package:chat_app/features/register/ui/register_screen.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppThemes.lightTheme,
      onGenerateRoute: AppRouter().onGenerateRoute,
      initialRoute: user == null ? Routes.login : Routes.home,
    );
  }
}
