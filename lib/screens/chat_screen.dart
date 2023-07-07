import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/chat/message_input.dart';
import '../widgets/chat/messages.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(context) {
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
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: const [
            Expanded(
              child: Messages(),
            ),
            MessageInput(),
          ],
        ),
      ),
    );
  }
}
