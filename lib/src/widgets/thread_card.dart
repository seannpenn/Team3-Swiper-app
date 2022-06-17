import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swiper_app/src/models/chat_user_model.dart';
import 'package:swiper_app/src/screens/chat/chat_screen.dart';
import 'package:swiper_app/src/widgets/avatars.dart';

class ThreadCard extends StatelessWidget {
  final Function()? onLongPress;
  // final Function()? onTap;

  ThreadCard({Key? key, required this.user, this.onLongPress, this.receiptId})
      : super(key: key);

  // final ChatController _chatController = ChatController();
  final String? receiptId;
  final ChatUser user;
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatScreen(toUser: user.uid)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              color: Colors.teal[400]),
          child: Row(
            children: [
              AvatarImage(uid: user.uid),
              Container(
                margin: EdgeInsets.only(left: 15),
                child: FutureBuilder<ChatUser>(
                    future: ChatUser.fromUid(uid: user.uid),
                    builder: (context, AsyncSnapshot<ChatUser> snap) {
                      if (snap.hasData) {
                        return Text(
                          snap.data!.username,
                          style: const TextStyle(color: Colors.black),
                        );
                      }
                      return const Text('');
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
