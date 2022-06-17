import 'package:flutter/material.dart';
import 'package:swiper_app/src/controllers/chat_controller.dart';
import 'package:swiper_app/src/controllers/navigation/navigation_service.dart';
import 'package:swiper_app/src/models/chat_user_model.dart';
import 'package:swiper_app/src/screens/chat/chat_screen.dart';

import 'package:swiper_app/src/widgets/chat_card.dart';

import '../../../service_locators.dart';

class ChatHomeScreen extends StatefulWidget {
  static const String route = 'chat-home-screen';
  const ChatHomeScreen({Key? key}) : super(key: key);

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  final ChatController _chatController = ChatController();

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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          SingleChildScrollView(
            // padding: const EdgeInsets.all(8),
            controller: _scrollController,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  // height: sizeV * 10,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(5, 0, 0, 0),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Text(
                        'Chats',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    splashColor: Colors.teal,
                    onTap: () {
                      locator<NavigationService>()
                          .replaceLastRouteStackRecord(ChatScreen.route);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChatScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 5,
                              right: 20,
                            ),
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.amber),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Text('Global Chat'),
                              ),
                              Container(
                                width: 60,
                                padding: const EdgeInsets.only(top: 10.0),
                                child: const Text(
                                  'hello',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(color: Color.fromARGB(48, 0, 150, 135), thickness: 2),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
