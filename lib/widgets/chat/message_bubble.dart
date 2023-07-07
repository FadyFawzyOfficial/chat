import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//! I want to improve to ensure that this always is rendered in an efficient way.
//! Let's use some keys. You learned that when you're working with lists of data,
//! there can be issues with Flutter, updating your widgets and to ensure that
//! Flutter is always able to efficiently update data in lists or widgets & lists.
//! We add a new property which is of type key & we name it key & we simply then
//! have a named argument here in the constructor where we point at the key.
class MessageBubble extends StatelessWidget {
  final String message;
  final bool isOwner;
  final String userId;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isOwner,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isOwner ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          width: 150,
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
              //! The flaw is that I'm fetching that username here in the message bubble.
              //! I'm fetching it with my FutureBuilder, which I added here this one.
              //! And that means that for every new message bubble that's being
              //! rendered, I reach out to Firebase and I fetch that data.
              //* This can be good or bad. This can hammer this API quite a bit.
              //! Now, the good news is, since this isn't a list, it should only
              //! fetch the username for the messages that are actually being rendered.
              //! And in addition, fire store also caches data locally.
              //! So it's not going to make a million requests here probably.
              //! Instead, it should cache data and not send too many requests.
              //! Still, this is not something you might want here.
              //! You maybe don't want to send a new request for every message bubble
              //! that's being rendered. Therefore we could agree that we don't
              //! want to fetch this here, but that instead when we create a message.
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (context, snapshot) {
                  return Text(
                    snapshot.connectionState == ConnectionState.waiting
                        ? 'Loading...'
                        : snapshot.data?['username'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
