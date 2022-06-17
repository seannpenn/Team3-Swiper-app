import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swiper_app/src/models/chat_user_model.dart';
import 'package:swiper_app/src/widgets/avatars.dart';

import '../models/chat_message_model.dart';

class ThreadCard extends StatelessWidget {
  final Function()? onLongPress;
  // final Function()? onTap;

  ThreadCard({Key? key, required this.user, this.onLongPress, this.receiptId})
      : super(key: key);

  // final ChatController _chatController = ChatController();
  final String ?receiptId;
  final ChatUser user;
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: printTest,
      onLongPress: onLongPress,
      child: Row(
        children: [
          AvatarImage(uid: user.uid),
          Container(
            
            decoration: BoxDecoration(color: Colors.teal[400]),
            child: FutureBuilder<ChatUser>(
                future: ChatUser.fromUid(uid: user.uid),
                builder: (context, AsyncSnapshot<ChatUser> snap) {
                  if (snap.hasData) {
                    return Text(snap.data!.username, style: const TextStyle(color: Colors.black),);
                  }
                  return const Text('');
                }),
          ),
        ],
      ),
     
    );
  }
  printTest(){
    print('Testing route for chat');
  }
}
