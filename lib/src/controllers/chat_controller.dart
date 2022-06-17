import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swiper_app/src/models/chat_message_model.dart';
import 'package:uuid/uuid.dart';

class ChatController with ChangeNotifier {
  ChatMessage? chatMessage;
  var uuid = const Uuid();
  late StreamSubscription _chatSub;

  late String currentUser;
  List<ChatMessage> chats = [];

  ChatController(String toUser) {
    _chatSub =
        ChatMessage.userChats(toUser, FirebaseAuth.instance.currentUser!.uid)
            .listen(chatUpdateHandler);
  }

  @override
  void dispose() {
    _chatSub.cancel();
    super.dispose();
  }

  chatUpdateHandler(List<ChatMessage> update) {
    chats = update;
    notifyListeners();
  }

  Future sendMessageGlobal({required String message}) {
    return FirebaseFirestore.instance.collection('chats').add(ChatMessage(
          sentBy: FirebaseAuth.instance.currentUser!.uid,
          message: message,
        ).json);
  }

  Future sendMessagePrivate(
      {required String message,
      required String toUser,
      required String currentUser}) {
    var id = uuid.v4();

    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser)
        .collection('chats')
        .doc(toUser)
        .collection('messages')
        .doc(id)
        .set(ChatMessage(
          sentBy: FirebaseAuth.instance.currentUser!.uid,
          message: message,
        ).json);

    return FirebaseFirestore.instance
        .collection('users')
        .doc(toUser)
        .collection('chats')
        .doc(currentUser)
        .collection('messages')
        .doc(id)
        .set(ChatMessage(
          sentBy: FirebaseAuth.instance.currentUser!.uid,
          message: message,
        ).json);
  }
}
