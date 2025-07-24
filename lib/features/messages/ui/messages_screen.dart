import 'package:chats_app/core/widgets/custom_button.dart';
import 'package:chats_app/core/widgets/custom_text_field.dart';
import 'package:chats_app/features/conversations/models/conversation_model.dart';
import 'package:chats_app/features/messages/cubit/messages_cubit.dart';
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
              const Spacer(),
              Row(
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
                          cubit.sendMessage(conversation.uid);
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
