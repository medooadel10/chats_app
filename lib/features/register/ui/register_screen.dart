import 'package:chat_app/core/widgets/custom_button.dart';
import 'package:chat_app/core/widgets/custom_text_field.dart';
import 'package:chat_app/features/register/logic/register_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterProvider(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Register')),
        body: SingleChildScrollView(
          padding: EdgeInsetsDirectional.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          child: Consumer<RegisterProvider>(
            builder: (context, value, child) {
              return Form(
                key: value.formKey,
                child: Column(
                  spacing: 16,
                  children: [
                    CustomTextField(
                      controller: value.nameController,
                      hintText: 'Enter Full Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter full name';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: value.emailController,
                      hintText: 'Enter email address',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: value.phoneController,
                      hintText: 'Enter Phone Number',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                    ),
                    CustomTextField(
                      controller: value.passwordController,
                      hintText: 'Enter password',
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
                          value.register(context);
                        },
                        text: 'Register',
                      ),

                    Row(
                      children: [
                        Text('Already have an account ? '),
                        TextButton(onPressed: () {}, child: Text('Sign In')),
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
