import 'package:chats_app/core/widgets/custom_button.dart';
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
            children: [
              Expanded(
                child: BlocBuilder<MessagesCubit, MessagesState>(
                  builder: (context, state) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        final isSender =
                            FirebaseAuth.instance.currentUser!.uid ==
                            cubit.messages[index].senderUid;

                        return Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(right: isSender ? 40 : 0),
                          decoration: BoxDecoration(
                            color: isSender
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
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
                                      isSender
                                          ? cubit.messages[index].senderName
                                          : cubit.messages[index].receiverName,
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
                          cubit.sendMessage(conversation);
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
