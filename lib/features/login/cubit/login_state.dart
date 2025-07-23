// Cant be inherit from this sealed class outside the file
import 'package:firebase_auth/firebase_auth.dart';

sealed class LoginState {}

// final Cant be inherit from the class
final class LoginInitialState extends LoginState {}

final class LoginLoadingState extends LoginState {}

final class LoginSuccessState extends LoginState {
  final UserCredential userCredential;

  LoginSuccessState(this.userCredential);
}

final class LoginErrorState extends LoginState {
  final String message;

  LoginErrorState(this.message);
}
