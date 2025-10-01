import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/models/messages_model.dart';
import 'package:chat_app/constants.dart';

class CustomChatBubbleMine extends StatelessWidget {
  const CustomChatBubbleMine({super.key, required this.message});

  final MessagesModel message;

  @override
  Widget build(BuildContext context) {
    String? displayName = FirebaseAuth.instance.currentUser!.displayName;

    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              displayName ?? 'Anonymous',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            BubbleSpecialOne(
              text: message.message,
              isSender: true,
              color: kPrimaryColor,
              textStyle: const TextStyle(
                color: kSecondaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
