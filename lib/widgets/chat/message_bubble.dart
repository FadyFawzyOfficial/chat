import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//! I want to improve to ensure that this always is rendered in an efficient way.
//! Let's use some keys. You learned that when you're working with lists of data,
//! there can be issues with Flutter, updating your widgets and to ensure that
//! Flutter is always able to efficiently update data in lists or widgets & lists.
//! We add a new property which is of type key & we name it key & we simply then
//! have a named argument here in the constructor where we point at the key.
class MessageBubble extends StatelessWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> message;
  final bool isOwner;
  final String username;
  final String messageText;
  final String imageUrl;

  MessageBubble({Key? key, required this.message})
      : isOwner = message['userId'] == FirebaseAuth.instance.currentUser!.uid,
        username = message['username'],
        messageText = message['text'],
        imageUrl = message['imageUrl'],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              isOwner ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              width: 150,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: isOwner
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadiusDirectional.only(
                  topStart: const Radius.circular(12),
                  topEnd: const Radius.circular(12),
                  bottomEnd: isOwner
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomStart: isOwner
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                ),
              ),
              child: Column(
                crossAxisAlignment:
                    isOwner ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    messageText,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        PositionedDirectional(
          start: isOwner ? null : 125,
          end: isOwner ? 125 : null,
          child: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        ),
      ],
    );
  }
}
