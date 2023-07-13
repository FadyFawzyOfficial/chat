import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  const MessageInput({super.key});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _messageController = TextEditingController();
  var _message = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              autocorrect: true,
              enableSuggestions: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Send a message ...',
              ),
              onChanged: (message) => setState(() => _message = message),
            ),
          ),
          IconButton(
            onPressed: _message.trim().isEmpty ? null : _sendMessage,
            icon: const Icon(Icons.send_rounded),
            color: Theme.of(context).primaryColor,
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    // Close or Hide the Keyboard
    FocusScope.of(context).unfocus();
    final userId = FirebaseAuth.instance.currentUser!.uid;
    //! So when we create a new message here in a new message widget,
    //! we want to store the username next to the userId so that we already have
    //! the username here and we don't need to fetch it again.
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    final username = userData['username'] as String;
    final imageUrl = userData['imageUrl'] as String;

    FirebaseFirestore.instance.collection('chat').add(
      {
        'text': _message,
        'time': Timestamp.now(),
        'userId': userId,
        'username': username,
        'imageUrl': imageUrl,
      },
    );

    _messageController.clear();
    _message = '';
  }
}
