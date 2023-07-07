import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No chats. Start one'));
        }
        final documents = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: documents.length,
          itemBuilder: (context, index) {
            final currentMessage = documents[index];
            return MessageBubble(
              message: currentMessage['text'],
              isOwner: currentMessage['userId'] ==
                  FirebaseAuth.instance.currentUser!.uid,
            );
          },
        );
      },
    );
  }
}
