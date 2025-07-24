import 'package:chats_app/core/router/routes.dart';
import 'package:chats_app/features/conversations/cubit/conversations_cubit.dart';
import 'package:chats_app/features/conversations/models/conversation_model.dart';
import 'package:chats_app/features/conversations/ui/conversations_screen.dart';
import 'package:chats_app/features/login/cubit/login_cubit.dart';
import 'package:chats_app/features/login/ui/login_screen.dart';
import 'package:chats_app/features/messages/cubit/messages_cubit.dart';
import 'package:chats_app/features/messages/ui/messages_screen.dart';
import 'package:chats_app/features/register/cubit/register_cubit.dart';
import 'package:chats_app/features/register/ui/register_screen.dart';
import 'package:chats_app/features/splash/ui/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (context) => SplashScreen());
      case Routes.login:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => LoginCubit(),
            child: LoginScreen(),
          ),
        );
      case Routes.register:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => RegisterCubit(),
            child: RegisterScreen(),
          ),
        );
      case Routes.conversations:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ConversationsCubit()..getAllConversations(),
            child: ConversationsScreen(),
          ),
        );
      case Routes.messages:
        final args = settings.arguments as ConversationModel;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => MessagesCubit(),
            child: MessagesScreen(conversation: args),
          ),
        );
      default:
        return MaterialPageRoute(builder: (context) => Container());
    }
  }
}
