import 'package:chat_app/features/home/models/user_model.dart';
import 'package:chat_app/features/messages/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessagesProvider extends ChangeNotifier {
  final messageController = TextEditingController();
  void sendMessage(UserModel user) async {
    try {
      final messageId = DateTime.now().millisecondsSinceEpoch.toString();
      final message = MessageModel(
        id: messageId,
        content: messageController.text,
        receiverUid: user.uid,
        senderUid: FirebaseAuth.instance.currentUser!.uid,
        sendAt: DateTime.now().toString(),
      );
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());
      messageController.clear();
    } catch (e) {
      print(e.toString());
    }
  }

  List<MessageModel> messages = [];

  void getAllMessages(UserModel user) async {
    final response = FirebaseFirestore.instance
        .collection('messages')
        .where(
          'senderUid',
          whereIn: [user.uid, FirebaseAuth.instance.currentUser!.uid],
        )
        .where(
          'receiverUid',
          whereIn: [user.uid, FirebaseAuth.instance.currentUser!.uid],
        )
        .snapshots();

    response.listen((event) {
      messages.clear();
      for (var doc in event.docs) {
        final message = MessageModel.fromMap(doc.data());
        messages.add(message);
      }
      notifyListeners();
    });
  }
}
