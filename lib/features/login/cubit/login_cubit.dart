import 'package:bloc/bloc.dart';
import 'package:chats_app/features/login/cubit/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    if (formKey.currentState!.validate()) {
      emit(LoginLoadingState());
      try {
        final credentail = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );
        emit(LoginSuccessState(credentail));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          emit(LoginErrorState('No user found for that email.'));
        } else if (e.code == 'wrong-password') {
          emit(LoginErrorState('Wrong password provided for that user.'));
        } else {
          emit(LoginErrorState('InCorrect Info'));
        }
      } catch (e) {
        print('An unexpected error occurred: $e');
        emit(LoginErrorState('Wrong password provided for that user.'));
      }
    }
  }
}
