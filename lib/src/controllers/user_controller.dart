import 'dart:async';


import 'package:flutter/material.dart';

import 'package:swiper_app/src/models/chat_user_model.dart';

class UserController with ChangeNotifier {
  
  late StreamSubscription _userSub;
  late StreamSubscription _threadSub;
  List<ChatUser> users = [];
  List<ChatUser> threads = [];

  UserController() {
    _userSub = ChatUser.appUsers().listen(userCountHandler);
    _threadSub = ChatUser.currentThreads().listen(userCountHandler);
  }

  @override
  void dispose() {
    _userSub.cancel();
    _threadSub.cancel();
    super.dispose();
  }

  userCountHandler(List<ChatUser> update) {
    users = update;
    threads = update;
    notifyListeners();
  }
  
}