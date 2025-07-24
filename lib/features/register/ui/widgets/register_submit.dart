import 'package:chats_app/core/router/routes.dart';
import 'package:chats_app/core/widgets/custom_button.dart';
import 'package:chats_app/features/register/cubit/register_cubit.dart';
import 'package:chats_app/features/register/cubit/register_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterSubmit extends StatelessWidget {
  const RegisterSubmit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        switch (state) {
          case RegisterSuccessState():
            Fluttertoast.showToast(
              msg: 'The account has been registered successfully',
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.conversations,
              (route) => false,
            );
          case RegisterErrorState():
            Fluttertoast.showToast(msg: state.message);
          default:
        }
      },
      builder: (context, state) {
        return switch (state) {
          RegisterLoadingState() => Center(child: CupertinoActivityIndicator()),
          _ => CustomButton(
            onPressed: () {
              cubit.createUser();
            },
            text: 'Register',
          ),
        };
      },
    );
  }
}
