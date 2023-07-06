import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => const Text('This Works!'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/Gp5Ct54QgPYeVJZf4hq4/messages')
              .snapshots()
              .listen(
            (messages) {
              for (var document in messages.docs) {
                print(document['text']);
              }
            },
          );
        },
      ),
    );
  }
}
