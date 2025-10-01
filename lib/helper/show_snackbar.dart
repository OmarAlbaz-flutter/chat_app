import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String showMessage) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(showMessage),
      behavior: SnackBarBehavior.floating,
      backgroundColor: kPrimaryColor,
    ),
  );
}
