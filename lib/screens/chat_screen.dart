import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(context) {
    final firestoreInstance = FirebaseFirestore.instance
        .collection('chats/Gp5Ct54QgPYeVJZf4hq4/messages');
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: StreamBuilder(
        stream: firestoreInstance.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No chats. Start one'));
          }
          final documents = snapshot.data!.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) => Text(documents[index]['text']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        // Send a dummy message to test the Firebase Firestore
        onPressed: () => firestoreInstance.add(
          {'text': 'This message is from the Mobile App'},
        ),
      ),
    );
  }
}