import 'dart:developer';

import 'package:chat_app/features/home/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  UserModel? user;
  void getUserProfile() async {
    final response = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    final data = response.data()!;
    user = UserModel.fromMap(data);
    notifyListeners();
  }

  List<UserModel> users = [];
  void getAllUsers() async {
    final response = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    for (var doc in response.docs) {
      final user = UserModel.fromMap(doc.data());
      users.add(user);
    }
    notifyListeners();
  }
}
