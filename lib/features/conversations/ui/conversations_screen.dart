import 'package:chats_app/core/router/routes.dart';
import 'package:chats_app/features/conversations/cubit/conversations_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConversationsScreen extends StatelessWidget {
  const ConversationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ConversationsCubit>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversations'),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.login,
                (route) => false,
              );
            },
            icon: Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
      body: BlocBuilder<ConversationsCubit, ConversationsState>(
        builder: (context, state) {
          if (state is ConversationsLoadingState) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.separated(
            padding: EdgeInsets.all(16),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.messages,
                  arguments: cubit.conversations[index],
                );
              },
              child: Row(
                spacing: 10,
                children: [
                  CircleAvatar(radius: 30, child: Icon(Icons.person)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cubit.conversations[index].name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(cubit.conversations[index].email),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            separatorBuilder: (context, index) => SizedBox(height: 16),
            itemCount: cubit.conversations.length,
          );
        },
      ),
    );
  }
}
