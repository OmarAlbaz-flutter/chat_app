import 'package:chat_app/constants.dart';
import 'package:chat_app/models/messages_model.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:flutter/material.dart';

class CustomChatBubbleFriend extends StatelessWidget {
  const CustomChatBubbleFriend({
    required this.message,
    super.key,
  });

  final MessagesModel message;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.senderName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            BubbleSpecialOne(
              text: message.message,
              color: kSecondaryColor,
              tail: true,
              textStyle: const TextStyle(
                color: kPrimaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              isSender: false,
            ),
          ],
        ),
      ),
    );
  }
}
