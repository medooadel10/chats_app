import 'package:chats_app/core/router/routes.dart';
import 'package:chats_app/features/login/cubit/login_cubit.dart';
import 'package:chats_app/features/login/ui/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => LoginCubit(),
            child: LoginScreen(),
          ),
        );
      default:
        return MaterialPageRoute(builder: (context) => Container());
    }
  }
}
