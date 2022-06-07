import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:swiper_app/src/controllers/navigation/navigation_service.dart';
import 'package:swiper_app/src/controllers/user_controller.dart';
import 'package:swiper_app/src/models/chat_user_model.dart';
import 'package:swiper_app/src/screens/chat/chat_screen.dart';
import 'package:swiper_app/src/screens/profile/profile_screen.dart';
import 'package:swiper_app/src/services/image_service.dart';
import 'package:swiper_app/src/widgets/avatars.dart';
import 'package:swiper_app/src/widgets/service_card.dart';

import '../../../service_locators.dart';
import '../../controllers/auth_controller.dart';

class HomeScreen extends StatefulWidget {
  static const String route = 'home-screen';
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userRef = FirebaseFirestore.instance.collection('users');
  final AuthController _auth = locator<AuthController>();
  final cardController = SwipableStackController();
  final UserController _userController = UserController();


  ChatUser? user;
  int userCount = 1;
  ServiceCard? card;
  List<String> users = [];

  @override
  void initState() {
    ChatUser.fromUid(uid: _auth.currentUser!.uid).then((value) {
      if (mounted) {
        setState(() {
          user = value;
        });
      }
    });
    // _chatController.addListener(scrollToBottom);
    super.initState();
    print(userCount);
  }

  @override
  void dispose() {
    // _chatController.removeListener(scrollToBottom);
    // _messageFN.dispose();
    // _messageController.dispose();
    // _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: true,
      
      body: SafeArea(
        child: AnimatedBuilder(
            animation: _userController,
            builder: (context, Widget? w) {
              return Stack(
                alignment: AlignmentDirectional.topStart,
                fit: StackFit.loose,
                children: [
                  for (ChatUser user in _userController.users)
                    if (user.uid != FirebaseAuth.instance.currentUser!.uid)
                      SwipableStack(
                          itemCount: 1,
                          builder: (BuildContext context, properties) {
                            return ServiceCard(
                              uid: user.uid,
                              urlImage: user.image,
                            );
                          })
                ],
              );
            }),
      ),
    );
  }

  // getUsers() {
  //   userRef.get().then((QuerySnapshot snapshot) {
  //     for (var doc in snapshot.docs) {
  //       users.add(doc.id);
  //     }
  //   });
  // }

  // testPrint(String id) {
  //   print(id);
  // }
}
