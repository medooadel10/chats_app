import 'package:chat_app/core/style/app_colors.dart';
import 'package:chat_app/core/widgets/custom_text_field.dart';
import 'package:chat_app/features/home/models/user_model.dart';
import 'package:chat_app/features/messages/logic/messages_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesScreen extends StatelessWidget {
  final UserModel user;
  const MessagesScreen({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MessagesProvider()..getAllMessages(user),
      child: Scaffold(
        appBar: AppBar(title: Text(user.name)),
        body: Consumer<MessagesProvider>(
          builder: (context, value, child) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                child: Column(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          bool isSender =
                              FirebaseAuth.instance.currentUser!.uid ==
                              value.messages[index].senderUid;
                          return Row(
                            mainAxisAlignment: isSender
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                width: 200,
                                decoration: BoxDecoration(
                                  color: isSender
                                      ? AppColors.primaryColor
                                      : Colors.grey,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: isSender
                                        ? Radius.circular(12)
                                        : Radius.circular(0),
                                    topRight: Radius.circular(12),
                                    topLeft: Radius.circular(12),
                                    bottomLeft: isSender
                                        ? Radius.circular(0)
                                        : Radius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  value.messages[index].content,
                                  style: TextStyle(
                                    color: isSender
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 14),
                        itemCount: value.messages.length,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            controller: value.messageController,
                            hintText: 'Send a message...',
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            value.sendMessage(user);
                          },
                          icon: Icon(Icons.send),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
