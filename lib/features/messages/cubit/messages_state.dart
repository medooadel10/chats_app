part of 'messages_cubit.dart';

sealed class MessagesState {}

final class MessagesInitial extends MessagesState {}

final class MessageSendMessageLoadingState extends MessagesState {}

final class MessageSendMessageSuccessState extends MessagesState {}

final class MessageSendMessageErrorState extends MessagesState {
  final String message;

  MessageSendMessageErrorState(this.message);
}
