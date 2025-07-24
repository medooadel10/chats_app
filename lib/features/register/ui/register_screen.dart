import 'package:chats_app/core/widgets/custom_text_field.dart';
import 'package:chats_app/features/register/cubit/register_cubit.dart';
import 'package:chats_app/features/register/ui/widgets/register_image_picker.dart';
import 'package:chats_app/features/register/ui/widgets/register_submit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          spacing: 10,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: cubit.formKey,
                  child: Column(
                    spacing: 16,
                    children: [
                      RegisterImagePicker(),
                      CustomTextField(
                        controller: cubit.nameController,
                        hintText: 'Enter your name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: cubit.emailController,
                        hintText: 'Enter your email',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: cubit.passwordController,
                        hintText: 'Enter your password',
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        controller: cubit.confirmPasswordController,
                        hintText: 'Enter your confirm password',
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter confirm password';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            RegisterSubmit(),
          ],
        ),
      ),
    );
  }
}
