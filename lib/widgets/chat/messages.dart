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
              //! Now we need a unique key, we can create it with the ValueKey()
              //! and use some unique value, and every message here has a unique
              //! value. It has a unique document ID so we can reach out to chat
              //! docs and access document ID.
              //* Now we won't see a difference here, but behind the scenes this
              //* ensures that Flutter will always be able to efficiently rerender
              //* and update this list.
              //* It might not need that.
              //* It might be able to efficiently update this list even without the keys.
              //* But it certainly also won't hurt.
              key: ValueKey(currentMessage.id),
            );
          },
        );
      },
    );
  }
}
