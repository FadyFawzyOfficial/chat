import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isOwner;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isOwner,
  });

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
          child: Text(
            message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
