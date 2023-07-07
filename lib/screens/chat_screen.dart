import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/chat/messages.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(context) {
    final firestoreInstance = FirebaseFirestore.instance
        .collection('chats/Gp5Ct54QgPYeVJZf4hq4/messages');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          PopupMenuButton(
            onSelected: (_) => FirebaseAuth.instance.signOut(),
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'Sign Out',
                child: Row(
                  children: [
                    Icon(
                      Icons.exit_to_app_rounded,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 8),
                    const Text('Sign Out'),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: const [
          Expanded(
            child: Messages(),
          ),
        ],
      ),
    );
  }
}
