import 'package:chat_app/core/router/routes.dart';
import 'package:chat_app/features/home/ui/home_screen.dart';
import 'package:chat_app/features/login/ui/login_screen.dart';
import 'package:chat_app/features/register/ui/register_screen.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.register:
        return MaterialPageRoute(builder: (context) => RegisterScreen());
      case Routes.login:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (context) => HomeScreen());
      default:
        return null;
    }
  }
}
