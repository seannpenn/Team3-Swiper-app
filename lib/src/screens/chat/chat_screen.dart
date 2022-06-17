import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swiper_app/service_locators.dart';
import 'package:swiper_app/src/controllers/auth_controller.dart';
import 'package:swiper_app/src/controllers/chat_controller.dart';
import 'package:swiper_app/src/models/chat_user_model.dart';

import 'package:swiper_app/src/widgets/chat_card.dart';
import 'package:swiper_app/src/widgets/input_widget.dart';

import '../../models/chat_message_model.dart';

class ChatScreen extends StatefulWidget {
  static const String route = 'chat-screen';
  final String? toUser;
  const ChatScreen({Key? key, this.toUser}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final ChatController _chatController;
  final AuthController _auth = locator<AuthController>();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFN = FocusNode();
  final ScrollController _scrollController = ScrollController();
  ChatCard? card;
  // int _selectedIndex = 0;

  ChatUser? user;
  @override
  void initState() {
    _chatController = ChatController(widget.toUser!);
    ChatUser.fromUid(uid: _auth.currentUser!.uid).then((value) {
      if (mounted) {
        setState(() {
          user = value;
        });
      }
    });
    _chatController.addListener(scrollToBottom);
    super.initState();
  }

  scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 250));
    // print('scrolling to bottom');
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        curve: Curves.easeIn, duration: const Duration(milliseconds: 250));
  }

  // @override
  // void dispose() {
  //   _chatController.removeListener(scrollToBottom);
  //   _messageFN.dispose();
  //   _messageController.dispose();
  //   _chatController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[400],
        title: const Text('Chat app'),
      ),
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: true,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(
              child: AnimatedBuilder(
                  animation: _chatController,
                  builder: (context, Widget? w) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(8),
                      controller: _scrollController,
                      child: Column(
                        children: [
                          for (ChatMessage chat in _chatController.chats)
                            ChatCard(
                              chat: chat,
                              onLongPress: () {
                                showMessageOptions(context, chat);
                              },
                              onTap: () {
                                setState(() {
                                  chat.showMessageDetails();
                                });
                                // chat.updateDetails('Hello oy updated ni');

                                print('tapped');
                              },
                            ),
                        ],
                      ),
                    );
                  }),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      onFieldSubmitted: (String text) {
                        // send();
                      },
                      focusNode: _messageFN,
                      controller: _messageController,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Colors.teal,
                      ),
                      onPressed: () {
                        user?.sendMessageTest(
                            message: 'helloooo',
                            receiptUser: 'A61llLnbcsZoxeIwDYPqByS1bYo2');
                      })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // send() {
  //   _messageFN.unfocus();
  //   if (_messageController.text.isNotEmpty) {
  //     _chatController.sendMessage(message: _messageController.text.trim());
  //     _messageController.text = '';
  //   }
  // }

  showEditDialog(BuildContext context, ChatMessage chatMessage) async {
    showDialog<ChatMessage>(
        context: context,
        //if you don't want issues on navigator.pop, rename the context in the builder to something other than context
        builder: (dContext) {
          return Dialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
            ),
            child: InputWidget(
              current: chatMessage.message,
              chat: chatMessage,
            ),
          );
        });
  }

  showMessageOptions(BuildContext context, ChatMessage chatMessage) {
    if (chatMessage.sentBy == FirebaseAuth.instance.currentUser?.uid) {
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0),
              content: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    width: double.infinity,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.teal, width: 2),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          showEditDialog(context, chatMessage);
                        },
                        child: const Text('Edit')),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.teal, width: 2),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        confirmDeleteDialog(context, chatMessage);
                      },
                      child: const Text('Delete'),
                    ),
                  )
                ],
              ),
              // Row(
              //   children: [

              //   ],
              // )
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext ctx) {
            return AlertDialog(
              content: const Text('You dont have permission on this message.'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Ok'))
              ],
            );
          });
    }
  }

  void confirmDeleteDialog(BuildContext context, ChatMessage chatMessage) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Delete this message?'),
            actions: [
              TextButton(
                  onPressed: () {
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('No')),
              // The "Yes" button
              TextButton(
                  onPressed: () {
                    // Remove the box
                    chatMessage.deleteMessage();
                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes')),
            ],
          );
        });
  }
}
