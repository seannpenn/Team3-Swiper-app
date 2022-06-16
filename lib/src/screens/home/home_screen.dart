import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';
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

  ChatUser? user ;
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
      body: SafeArea(
        child: AnimatedBuilder(
            animation: _userController,
            builder: (context, Widget? w) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: AlignmentDirectional.topStart,
                  fit: StackFit.loose,
                  children: [
                    for (ChatUser userData in _userController.users)
                      if (user != null && userData.uid != FirebaseAuth.instance.currentUser!.uid && userData.image != '')
                        ServiceCard(
                          uid: userData.uid,
                          urlImage: userData.image,
                        ),

                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        tooltip: 'Reset',
                        onPressed: () {
                          cardController.canRewind;
                        },
                        child: const Icon(Icons.reset_tv),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

}
