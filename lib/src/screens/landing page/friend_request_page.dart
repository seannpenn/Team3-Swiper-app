import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:swiper_app/src/controllers/user_controller.dart';
import 'package:swiper_app/src/models/chat_user_model.dart';

import 'package:swiper_app/src/widgets/service_card.dart';

import '../../../service_locators.dart';
import '../../controllers/auth_controller.dart';

class FriendRequestScreen extends StatefulWidget {
  static const String route = 'friend-request-screen';
  const FriendRequestScreen({Key? key}) : super(key: key);

  @override
  State<FriendRequestScreen> createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
  final userRef = FirebaseFirestore.instance.collection('users');
  final AuthController _auth = locator<AuthController>();
  final cardController = SwipableStackController();
  final UserController _userController = UserController();

  ChatUser? currentUser;
  int itemCount = 0;

  @override
  void initState() {
    // ChatUser.fromUid(uid: _auth.currentUser!.uid).then((value) {
    //   if (mounted) {
    //     setState(() {
    //       currentUser = value;
    //     });
    //   }
    // });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        title: const Text('Friend Requests'),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
            animation: _userController,
            builder: (context, Widget? w) {
              return Column(
                children: [
                  for (ChatUser user in _userController.users)
                    if (user.uid == FirebaseAuth.instance.currentUser!.uid)
                      for (int i = 0; i < user.request.length; i++)
                      
                        Text(user.request[i],style: const TextStyle(color: Colors.black, fontSize: 30),)
                ],
              );
            }),
      ),
    );
  }
}
