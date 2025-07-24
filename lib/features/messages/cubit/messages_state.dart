part of 'messages_cubit.dart';

sealed class MessagesState {}

final class MessagesInitial extends MessagesState {}

final class MessageSendMessageLoadingState extends MessagesState {}

final class MessageSendMessageSuccessState extends MessagesState {}

final class MessageSendMessageErrorState extends MessagesState {
  final String message;

  MessageSendMessageErrorState(this.message);
}

final class MessageLoadingState extends MessagesState {}

final class MessageErrorState extends MessagesState {
  final String message;

  MessageErrorState(this.message);
}

final class MessageSuccessState extends MessagesState {
  final List<MessageModel> messages;

  MessageSuccessState(this.messages);
}
