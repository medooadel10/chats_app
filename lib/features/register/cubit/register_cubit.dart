import 'dart:developer';
import 'dart:io';

import 'package:chats_app/features/register/cubit/register_state.dart';
import 'package:chats_app/features/register/models/add_user_request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitialState());
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  File? photo;

  void pickImage(bool isCamera) async {
    final imagePicker = ImagePicker();
    final imagePicked = await imagePicker.pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );
    if (imagePicked != null) {
      photo = File(imagePicked.path);
      emit(RegisterPickImage(photo!));
    }
  }

  void createUser() async {
    if (formKey.currentState!.validate()) {
      emit(RegisterLoadingState());
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text,
            );
        final db = FirebaseFirestore.instance;
        final user = AddUserRequestModel(
          uid: credential.user!.uid,
          name: nameController.text,
          email: emailController.text,
        );
        await db
            .collection('Users')
            .doc(credential.user!.uid)
            .set(user.toMap());
        emit(RegisterSuccessState());
      } on FirebaseAuthException catch (e) {
        emit(RegisterErrorState(e.message ?? e.toString()));
      } on FirebaseException catch (e) {
        log(e.message ?? e.toString());
        emit(RegisterErrorState(e.message ?? e.toString()));
      }
    }
  }
}
