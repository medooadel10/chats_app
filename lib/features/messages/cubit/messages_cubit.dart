import 'package:bloc/bloc.dart';
import 'package:chats_app/core/models/user_model.dart';
import 'package:chats_app/core/services/notifications_service.dart';
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
      final response = await FirebaseFirestore.instance
          .collection('Users')
          .doc(conversation.uid)
          .get();
      final String fcmToken = response.data()?['fcmToken'] ?? '';
      NotificationsService.sendFcmNotification(
        title: 'New message from ${conversation.name}',
        body: messageModel.messageContent,
        fcmToken: fcmToken,
      );
    } on FirebaseException catch (e) {
      emit(MessageSendMessageErrorState(e.message ?? e.toString()));
    }
  }

  List<MessageModel> messages = [];
  void getMessages(ConversationModel conversation) async {
    emit(MessageLoadingState());
    final db = FirebaseFirestore.instance;
    db.collection('Messages').snapshots().listen((event) {
      final documents = event.docs;
      List<MessageModel> allMessages = [];
      for (var doc in documents) {
        allMessages.add(MessageModel.fromMap(doc.data()));
      }
      final filteredMessages = allMessages.where(
        (element) =>
            (element.senderUid == FirebaseAuth.instance.currentUser!.uid &&
                element.receiverUid == conversation.uid) ||
            (element.receiverUid == FirebaseAuth.instance.currentUser!.uid &&
                element.senderUid == conversation.uid),
      );
      messages = filteredMessages.toList();
      if (!isClosed) emit(MessageSuccessState(messages));
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  final ScrollController scrollController = ScrollController();

  void deleteMessage(String id) async {
    await FirebaseFirestore.instance.collection('Messages').doc(id).delete();
  }

  void updateMessage() async {
    await FirebaseFirestore.instance
        .collection('Messages')
        .doc(messageId)
        .update({'messageContent': messageController.text});

    messageId = null;
    messageController.text = '';
    emit(MessageUpdateStatus(false));
  }

  String? messageId;
  void onEdit(String id) {
    messageId = id;
    emit(MessageUpdateStatus(true));
  }
}
