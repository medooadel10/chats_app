import 'package:chat_app/core/router/routes.dart';
import 'package:chat_app/features/home/logic/home_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeProvider()
        ..getUserProfile()
        ..getAllUsers(),
      child: Consumer<HomeProvider>(
        builder: (context, value, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Home'),
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
                  icon: Icon(Icons.logout),
                ),
              ],
            ),
            body: Padding(
              padding: EdgeInsetsGeometry.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  Text(
                    'Welcome, ${value.user?.name ?? ''}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.messages,
                              arguments: value.users[index],
                            );
                          },
                          child: Row(
                            spacing: 10,
                            children: [
                              Icon(Icons.person, size: 50),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      value.users[index].name,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      value.users[index].email,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 16),
                      itemCount: value.users.length,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
