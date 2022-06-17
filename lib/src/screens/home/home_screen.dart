import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:swiper_app/src/controllers/navigation/navigation_service.dart';
import 'package:swiper_app/src/controllers/user_controller.dart';
import 'package:swiper_app/src/models/chat_user_model.dart';

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

  ChatUser? currentUser;
  ServiceCard? card;
  List<String> users = [];

  @override
  void initState() {
    ChatUser.fromUid(uid: _auth.currentUser!.uid).then((value) {
      if (mounted) {
        setState(() {
          currentUser = value;
        });
      }
    });
    getUsers();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 178, 232, 239),
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
                    for (int i = 0; i < users.length; i++)
                      if (user.uid != FirebaseAuth.instance.currentUser!.uid &&
                          user.image != '' &&
                          user.friends.contains(users[i]) &&
                          user.request.contains(users[i]))
                        ServiceCard(
                          user: user,
                          uid: user.uid,
                          urlImage: user.image,
                          bio: user.bio,
                        ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: InkWell(
                      onTap: () {
                      },
                      child: const Icon(
                        Icons.replay_circle_filled,
                        size: 40,
                        color: Colors.teal,
                      ),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }

  getUsers() {
    userRef.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        users.add(doc.id);
      }
    });
  }
}
