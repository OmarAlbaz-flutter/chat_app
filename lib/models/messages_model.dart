import 'package:chat_app/constants.dart';

class MessagesModel {
  final String message;
  final String id;
  final String senderName;
  MessagesModel(
    this.message,
    this.id,
    this.senderName,
  );

  factory MessagesModel.fromJson(jsonData) {
    return MessagesModel(
      jsonData[kMessage],
      jsonData[kId],
      jsonData['senderName'] ?? 'Anonymous',
    );
  }
}
