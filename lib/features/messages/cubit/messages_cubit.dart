import 'package:bloc/bloc.dart';
import 'package:chats_app/features/messages/models/add_message_request_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

part 'messages_state.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesInitial());

  final messageController = TextEditingController();
  void sendMessage(String receiverId) async {
    if (messageController.text.isEmpty) {
      emit(MessageSendMessageErrorState('Please enter message content'));
      return;
    }
    final db = FirebaseFirestore.instance;
    final id = DateTime.now().millisecondsSinceEpoch;
    final messageModel = AddMessageRequestModel(
      id: id.toString(),
      messageContent: messageController.text,
      senderUid: FirebaseAuth.instance.currentUser!.uid,
      receiverUid: receiverId,
      sentAt: DateTime.now().toIso8601String(),
    );
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
}
