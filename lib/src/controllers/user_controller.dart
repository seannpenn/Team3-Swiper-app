import 'dart:async';


import 'package:flutter/material.dart';

import 'package:swiper_app/src/models/chat_user_model.dart';

class UserController with ChangeNotifier {
  
  late StreamSubscription _userSub;
  List<ChatUser> users = [];

  UserController() {
    _userSub = ChatUser.appUsers().listen(userCountHandler);
  }

  @override
  void dispose() {
    _userSub.cancel();
    super.dispose();
  }

  userCountHandler(List<ChatUser> update) {
    users = update;
    notifyListeners();
  }
  
}