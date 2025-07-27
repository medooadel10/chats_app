import 'package:chats_app/core/services/firebase_messaging.dart';
import 'package:chats_app/core/widgets/custom_text_field.dart';
import 'package:chats_app/features/conversations/models/conversation_model.dart';
import 'package:chats_app/features/messages/cubit/messages_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MessagesScreen extends StatelessWidget {
  final ConversationModel conversation;
  const MessagesScreen({Key? key, required this.conversation})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<MessagesCubit>();
    return Scaffold(
      appBar: AppBar(title: Text(conversation.name)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            spacing: 16,
            children: [
              Expanded(
                child: BlocBuilder<MessagesCubit, MessagesState>(
                  builder: (context, state) {
                    return ListView.separated(
                      controller: cubit.scrollController,
                      itemBuilder: (context, index) {
                        final isSender =
                            FirebaseAuth.instance.currentUser!.uid ==
                            cubit.messages[index].senderUid;

                        return Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(
                            right: isSender ? 40 : 0,
                            left: isSender ? 0 : 40,
                          ),
                          decoration: BoxDecoration(
                            color: isSender
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey[200],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: isSender
                                  ? Radius.circular(0)
                                  : Radius.circular(12),
                              bottomRight: isSender
                                  ? Radius.circular(12)
                                  : Radius.circular(0),
                            ),
                          ),
                          child: Row(
                            spacing: 10,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 30,
                                child: Icon(Icons.person),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cubit.messages[index].messageContent,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      cubit.messages[index].sentAt,
                                      style: TextStyle(),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSender) ...[
                                IconButton(
                                  onPressed: () {
                                    cubit.messageController.text =
                                        cubit.messages[index].messageContent;
                                    cubit.onEdit(cubit.messages[index].id);
                                  },
                                  icon: Icon(Icons.edit, color: Colors.red),
                                ),
                                IconButton(
                                  onPressed: () {
                                    cubit.deleteMessage(
                                      cubit.messages[index].id,
                                    );
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12),
                      itemCount: cubit.messages.length,
                    );
                  },
                ),
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: cubit.messageController,
                      hintText: 'Enter your message here',
                    ),
                  ),
                  BlocConsumer<MessagesCubit, MessagesState>(
                    listener: (context, state) {
                      switch (state) {
                        case MessageSendMessageErrorState():
                          Fluttertoast.showToast(msg: state.message);
                        default:
                      }
                    },
                    builder: (context, state) {
                      if (state is MessageSendMessageLoadingState) {
                        return Center(child: CupertinoActivityIndicator());
                      }
                      return IconButton(
                        onPressed: () {
                          if (cubit.messageId != null) {
                            cubit.updateMessage();
                          } else {
                            cubit.sendMessage(conversation);
                          }
                        },
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
