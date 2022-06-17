import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swiper_app/src/models/chat_user_model.dart';

import '../models/chat_message_model.dart';

class ChatCard extends StatelessWidget {
  final Function()? onLongPress;
  final Function()? onTap;
  final ChatMessage chat;
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  ChatCard({Key? key, required this.chat, this.onLongPress, this.onTap})
      : super(key: key);

  // final ChatController _chatController = ChatController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (chat.tapped != false)
            Text(
              chat.tapped ? chat.dateFormatter(chat.ts.toDate()) : '',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          // Text(chat.tapped ? Moment.fromDateTime(chat.ts.toDate()).format('MMMM dd, yyyy hh:mm aa') : ''),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              mainAxisAlignment: chat.sentBy != currentUserId
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: [
                FutureBuilder<ChatUser>(
                    future: ChatUser.fromUid(uid: chat.sentBy),
                    builder: (context, AsyncSnapshot<ChatUser> snap) {
                      if (snap.hasData) {
                        return Text(
                          chat.sentBy == currentUserId
                              ? 'You sent:'
                              : '${snap.data?.username} sent',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        );
                      }

                      return const Text('');
                    }),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: chat.sentBy == currentUserId ? 100 : 10,
                bottom: 15,
                top: 10,
                right: chat.sentBy == currentUserId ? 10 : 100),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: chat.sentBy == currentUserId
                      ? const Radius.circular(16)
                      : const Radius.circular(0),
                  bottomLeft: chat.sentBy == currentUserId
                      ? const Radius.circular(16)
                      : const Radius.circular(16),
                  bottomRight: chat.sentBy == currentUserId
                      ? const Radius.circular(30)
                      : const Radius.circular(16),
                  topRight: chat.sentBy == currentUserId
                      ? const Radius.circular(0)
                      : const Radius.circular(16)),
              color: chat.sentBy == currentUserId
                  ? Colors.teal[400]
                  : Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    color: chat.sentBy == currentUserId
                        ? Colors.teal[400]
                        : Colors.grey[100],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              chat.message,
                              style: TextStyle(
                                  color: chat.sentBy == currentUserId
                                      ? Colors.white
                                      : Color.fromARGB(255, 20, 69, 78),
                                  letterSpacing: 0.5,
                                  fontFamily: 'Nunito'),
                            )),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (chat.message != 'Message Deleted.')
                              chat.sentBy == currentUserId
                                  ? Text(
                                      chat.edited ? 'edited' : '',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: chat.sentBy == currentUserId
                                              ? Colors.white
                                              : Color.fromARGB(255, 20, 69, 78),
                                          letterSpacing: 0.5),
                                    )
                                  : Text(
                                      chat.edited ? 'edited' : '',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: chat.sentBy == currentUserId
                                              ? Colors.white
                                              : Color.fromARGB(255, 20, 69, 78),
                                          letterSpacing: 0.5),
                                    ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        //'Message seen by ${chat.seenBy}')
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
