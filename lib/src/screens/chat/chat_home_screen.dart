import 'package:flutter/material.dart';
import 'package:swiper_app/src/controllers/chat_controller.dart';
import 'package:swiper_app/src/controllers/navigation/navigation_service.dart';
import 'package:swiper_app/src/controllers/user_controller.dart';
import 'package:swiper_app/src/models/chat_user_model.dart';
import 'package:swiper_app/src/screens/chat/chat_screen.dart';

import 'package:swiper_app/src/widgets/chat_card.dart';
import 'package:swiper_app/src/widgets/thread_card.dart';

import '../../../service_locators.dart';

class ChatHomeScreen extends StatefulWidget {
  static const String route = 'chat-home-screen';
  const ChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  final ChatController _chatController = ChatController();
  final UserController _userController = UserController();
  final ScrollController _scrollController = ScrollController();
  ChatCard? card;
  // int _selectedIndex = 0;

  ChatUser? user;
  @override
  void initState() {
    // ChatUser.fromUid(uid: _auth.currentUser!.uid).then((value) {
    //   if (mounted) {
    //     setState(() {
    //       user = value;
    //     });
    //   }
    // });
    _chatController.addListener(scrollToBottom);
    super.initState();
  }

  scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 250));
    // print('scrolling to bottom');
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        curve: Curves.easeIn, duration: const Duration(milliseconds: 250));
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: true,
      body: Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            AnimatedBuilder(
                animation: _chatController,
                builder: (context, Widget? w) {
                  return Column(
                    children: [
                      for (ChatUser threads in _userController.threads)
                        ThreadCard(user: threads,)
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
