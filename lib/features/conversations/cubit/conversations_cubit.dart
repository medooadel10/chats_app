import 'package:bloc/bloc.dart';
import 'package:chats_app/core/models/user_model.dart';
import 'package:chats_app/features/conversations/models/conversation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'conversations_state.dart';

class ConversationsCubit extends Cubit<ConversationsState> {
  ConversationsCubit() : super(ConversationsInitial());

  List<ConversationModel> conversations = [];
  void getAllConversations() async {
    emit(ConversationsLoadingState());
    final db = FirebaseFirestore.instance;
    final response = await db
        .collection('Users')
        .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    for (var doc in response.docs) {
      final data = doc.data();
      conversations.add(ConversationModel.fromMap(data));
    }
    emit(ConversationsSuccessState(conversations));
  }

  void getProfile() async {
    final db = FirebaseFirestore.instance;
    db
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
          final data = value.data();
          user = UserModel.fromMap(data ?? {});
        });
  }
}
