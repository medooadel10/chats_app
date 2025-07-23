import 'package:chats_app/core/widgets/custom_button.dart';
import 'package:chats_app/core/widgets/custom_text_field.dart';
import 'package:chats_app/features/login/cubit/login_cubit.dart';
import 'package:chats_app/features/login/cubit/login_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    return Scaffold(
      appBar: AppBar(title: Text('Login ')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: cubit.formKey,
          child: Column(
            spacing: 14,
            children: [
              CustomTextField(
                controller: cubit.emailController,
                hintText: 'Enter email address',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email address';
                  }
                  return null;
                },
              ),
              CustomTextField(
                controller: cubit.passwordController,
                hintText: 'Enter password',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  return null;
                },
              ),
              BlocConsumer<LoginCubit, LoginState>(
                builder: (context, state) {
                  return switch (state) {
                    LoginLoadingState() => Center(
                      child: CircularProgressIndicator(),
                    ),
                    _ => CustomButton(
                      onPressed: () {
                        cubit.login();
                      },
                      text: 'Login',
                    ),
                  };
                },
                listener: (context, state) {
                  switch (state) {
                    case LoginSuccessState():
                      Fluttertoast.showToast(
                        msg: 'You are logged in successfully',
                      );
                      print(state.userCredential.user?.uid);
                    case LoginErrorState():
                      Fluttertoast.showToast(msg: state.message);
                    default:
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
