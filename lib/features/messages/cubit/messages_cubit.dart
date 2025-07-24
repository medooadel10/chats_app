import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:chats_app/core/models/user_model.dart';
import 'package:chats_app/features/conversations/models/conversation_model.dart';
import 'package:chats_app/features/messages/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesInitial());

  final messageController = TextEditingController();
  void sendMessage(ConversationModel conversation) async {
    if (messageController.text.isEmpty) {
      emit(MessageSendMessageErrorState('Please enter message content'));
      return;
    }
    emit(MessageSendMessageLoadingState());
    final db = FirebaseFirestore.instance;
    final id = DateTime.now().millisecondsSinceEpoch;
    final messageModel = MessageModel(
      id: id.toString(),
      messageContent: messageController.text,
      senderUid: FirebaseAuth.instance.currentUser!.uid,
      receiverUid: conversation.uid,
      sentAt: DateTime.now().toIso8601String(),
      receiverEmail: conversation.email,
      receiverName: conversation.name,
      senderEmail: user.email,
      senderName: user.name,
    );
    messageController.clear();
    try {
      await db
          .collection('Messages')
          .doc(id.toString())
          .set(messageModel.toMap());
      emit(MessageSendMessageSuccessState());
    } on FirebaseException catch (e) {
      emit(MessageSendMessageErrorState(e.message ?? e.toString()));
    }
  }

  final List<MessageModel> messages = [];
  void getMessages(ConversationModel conversation) async {
    emit(MessageLoadingState());
    final db = FirebaseFirestore.instance;
    final response = await db
        .collection('Messages')
        .where('senderUid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('receiverUid', isEqualTo: conversation.uid)
        .get();
    log(response.docs.length.toString());
    final documents = response.docs;
    for (var doc in documents) {
      messages.add(MessageModel.fromMap(doc.data()));
    }
    emit(MessageSuccessState(messages));
  }
}
