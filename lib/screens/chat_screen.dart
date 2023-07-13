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
  Future<void> registerNotification() async {
    //* 1. Instantiate Firebase Messaging
    _firebaseMessaging = FirebaseMessaging.instance;

    //* 6. Request permission
    //* On iOS, this helps to take the user permissions
    //* Requesting permission (Notification): you must first ask the users
    //* permission (iOS). Now, on android this (the following) will do nothing
    //* but on iOS it will ask for (Notifications) permission
    final notificationSettings = await _firebaseMessaging.requestPermission();

    //? On Apple based platforms, once a permission request has been handled by
    //? the user (authorized or denied), it is NOT possible to re-request permission.
    //? The user must instead update permission via the device Settings UI:
    //* If the user denied permission altogether, they must enable app permission fully.
    //* If the user accepted requested permission (without sound),
    //* they must specifically enable the sound option themselves.
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }

    //* 2. Handle Foreground Notifications those are received while the App
    //* in Foreground
    //! Listen to messages whilst you application is in the foreground, listen
    //! to the 'onMessage' Stream.
    FirebaseMessaging.onMessage.listen(_onForegroundNotification);

    //* 3. Handle Background Notifications those are received while tha App
    //* in Background or Terminated (Killed or Mobile Screen is Locked)
    //! There are a few things to keep in mind about your background message handler:
    //!   1. It must not be an anonymous function.
    //!   2. It must be a top-level function (e.g. not a class method which requires initialization).
    FirebaseMessaging.onBackgroundMessage(_onBackgroundNotification);

    //* 4. Handle Background Notifications when Pressed it to Open the App
    FirebaseMessaging.onMessageOpenedApp.listen(_onNotificationOpenedApp);

    //* 5. Get the FCM (Firebase Cloud Messaging) Token to Send Notification
    //* Message to a Specific User from the Server Side.
    // Once your application has started, you can call the getToken method on
    // the Cloud Messaging module to get the unique device token
    // (if using a different push notification provider, such as Amazon SNS,
    // you will need to call getAPNSToken on iOS):
    // It request a registration token for sending messages to users from your
    // app server side or other trusted server environment.
    // Get the token each time the application loads
    String? fcmToken = await _firebaseMessaging.getToken();
    debugPrint(fcmToken);
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
    showNotificationDialog(message);
  }

  //* 4. Define the Background Notifications those open the App
  //* (Background -> Foreground)
  Future<void> _onNotificationOpenedApp(RemoteMessage message) async {
    debugPrint('Got a message whilst in Background or Terminated!');
    debugPrint('Handling a message that open the App: ${message.messageId}');
    showNotificationDialog(message);
  }

  void showNotificationDialog(RemoteMessage message) {
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

//* 3. Define the background message handler
//! Outside of any class
Future<void> _onBackgroundNotification(RemoteMessage message) async {
  debugPrint('Got a message whilst in the background!');
  debugPrint("Handling a background message: ${message.messageId}");
  debugPrint('Message data: ${message.data}');
  debugPrint('Message notification: ${message.notification?.title}');
  debugPrint('Message notification: ${message.notification?.body}');
}
