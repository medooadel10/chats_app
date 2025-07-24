part of 'conversations_cubit.dart';

sealed class ConversationsState {}

final class ConversationsInitial extends ConversationsState {}

final class ConversationsLoadingState extends ConversationsState {}

final class ConversationsSuccessState extends ConversationsState {
  final List<ConversationModel> conversations;

  ConversationsSuccessState(this.conversations);
}

final class ConversationsErrorState extends ConversationsState {
  final String message;

  ConversationsErrorState(this.message);
}
