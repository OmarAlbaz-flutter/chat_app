import 'package:chat_app/constants.dart';
import 'package:chat_app/models/messages_model.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:chat_app/widgets/custom_chat_bubble.dart';
import 'package:chat_app/widgets/custom_chat_bubble_friend.dart';
import 'package:chat_bubbles/message_bars/message_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  static String id = 'ChatPage';

  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessageCollection);

  final ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)?.settings.arguments as String? ??
        FirebaseAuth.instance.currentUser?.email;

    return StreamBuilder<QuerySnapshot>(
      stream: messages
          .orderBy(
            kCreatedAt,
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<MessagesModel> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(
              MessagesModel.fromJson(
                snapshot.data!.docs[i],
              ),
            );
          }

          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                leading: InkWell(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacementNamed(
                      context,
                      LoginPage.id,
                    );
                  },
                  child: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: kPrimaryColor,
                automaticallyImplyLeading: false,
                title: Text(
                  "XelilovChat",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                centerTitle: true,
              ),
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      kSecondaryColor,
                      kPrimaryColor,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        controller: controller,
                        itemCount: messagesList.length,
                        itemBuilder: (context, index) {
                          return messagesList[index].id == email
                              ? CustomChatBubbleMine(
                                  message: messagesList[index],
                                )
                              : CustomChatBubbleFriend(
                                  message: messagesList[index],
                                );
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      color: kSecondaryColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: MessageBar(
                          messageBarColor: kSecondaryColor,
                          onSend: (value) {
                            messages.add(
                              {
                                kMessage: value,
                                kCreatedAt: DateTime.now(),
                                kId: email,
                                'senderName': FirebaseAuth
                                        .instance.currentUser!.displayName ??
                                    'Anonymous',
                              },
                            );
                            controller.animateTo(
                              0,
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeIn,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
              backgroundColor: kPrimaryColor,
              body: Center(
                child: Text(
                  "Loading...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                  ),
                ),
              ));
        }
      },
    );
  }
}
