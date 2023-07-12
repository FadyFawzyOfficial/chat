import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../widgets/chat/message_input.dart';
import '../widgets/chat/messages.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {
    super.initState();
    registerNotification();
  }

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

  // COMPLETED: Register with FCM
  void registerNotification() {
    //* 1. Instantiate Firebase Messaging
    _firebaseMessaging = FirebaseMessaging.instance;

    //* 2. Handle Foreground Notifications those are received while the App
    //* in Foreground
    //! Listen to messages whilst you application is in the foreground, listen
    //! to the 'onMessage' Stream.
    FirebaseMessaging.onMessage.listen(_onForegroundNotification);
  }

  //* 2. This utility method to handle the notifications received in Foreground
  // The stream contains a RemoteMessage, detailing various information about
  // the payload, such as where it was from, the unique ID, sent time,
  // whether it contained a notification & more. Since the message was retrieved
  // whilst your application is in the foreground, you can directly access your
  // Flutter application's state & context.
  // Notification messages which arrive whilst the application is in the foreground
  // will not display a visible notification by default, on both Android & iOS.
  // It is, however, possible to override this behavior:
  //     On Android, you must create a "High Priority" notification channel.
  //     On iOS, you can update the presentation options for the application.
  Future<void> _onForegroundNotification(RemoteMessage message) async {
    debugPrint('Got a message whilst in the foreground!');
    debugPrint('Handling a foreground message: ${message.messageId}');
    debugPrint('Message data: ${message.data}');

    if (message.notification != null) {
      debugPrint(
          'Message also contained a notification: ${message.notification}');
      debugPrint('Message notification: ${message.notification!.title}');
      debugPrint('Message notification: ${message.notification!.body}');
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message.notification?.title ?? 'No Title'),
        content: Text(message.notification?.body ?? 'No Body'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
