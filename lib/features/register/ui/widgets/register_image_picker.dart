import 'dart:io';

import 'package:chats_app/core/widgets/custom_button.dart';
import 'package:chats_app/features/register/cubit/register_cubit.dart';
import 'package:chats_app/features/register/cubit/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterImagePicker extends StatelessWidget {
  const RegisterImagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<RegisterCubit>();
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterPickImage) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Select an Option'),
                content: Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          cubit.pickImage(false);
                        },
                        text: 'Open Galley',
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        onPressed: () {
                          cubit.pickImage(true);
                        },
                        text: 'Open Camera',
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            radius: 60,
            child: cubit.photo != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.file(
                      cubit.photo!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  )
                : Icon(Icons.camera),
          ),
        );
      },
    );
  }
}
