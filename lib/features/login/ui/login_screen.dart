import 'package:chat_app/core/router/routes.dart';
import 'package:chat_app/core/widgets/custom_button.dart';
import 'package:chat_app/core/widgets/custom_text_field.dart';
import 'package:chat_app/features/login/logic/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginProvider(),
      child: Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Consumer<LoginProvider>(
            builder: (context, value, child) {
              return Form(
                key: value.formKey,
                child: Column(
                  spacing: 16,
                  children: [
                    CustomTextField(
                      controller: value.emailController,
                      hintText: 'Enter Email',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter full name';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: value.passwordController,
                      hintText: 'Enter Password',
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                    if (value.isLoading)
                      CircularProgressIndicator()
                    else
                      CustomButton(
                        onPressed: () {
                          value.login(context);
                        },
                        text: 'Login',
                      ),
                    Row(
                      children: [
                        Text('Are you haven\'nt an account? '),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, Routes.register);
                          },
                          child: Text('Sign Up'),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
