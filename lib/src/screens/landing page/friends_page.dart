import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:swiper_app/src/controllers/user_controller.dart';
import 'package:swiper_app/src/models/chat_user_model.dart';
import 'package:swiper_app/src/widgets/avatars.dart';

import 'package:swiper_app/src/widgets/service_card.dart';

import '../../../service_locators.dart';
import '../../controllers/auth_controller.dart';

class FriendScreen extends StatefulWidget {
  static const String route = 'friend-screen';
  const FriendScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  final userRef = FirebaseFirestore.instance.collection('users');
  final AuthController _auth = locator<AuthController>();
  final cardController = SwipableStackController();
  final UserController _userController = UserController();

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
        title: const Text('Friend'),
      ),
      body: SafeArea(
          child: StreamBuilder<ChatUser>(
              stream: ChatUser.fromUidStream(
                  uid: FirebaseAuth.instance.currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      children: const [
                        Text('Fetching Data'),
                        CircularProgressIndicator()
                      ],
                    ),
                  );
                }
                return SizedBox(
                  height: 1920,
                  width: 1080,
                  child: ListView.builder(
                      itemCount: snapshot.data!.friends.length,
                      itemBuilder: (context, index) {
                        final friends = snapshot.data!.friends[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Dismissible(
                              key: ObjectKey(friends),
                              background: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                color: Colors.red,
                                child: const Icon(Icons.close,
                                    color: Colors.white, size: 32),
                              ),
                              secondaryBackground: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                color: Colors.orange,
                                child: const Icon(Icons.chat,
                                    color: Colors.white, size: 32),
                              ),
                              onDismissed: (direction) async {
                                switch (direction) {
                                  case DismissDirection.endToStart:
                                    if (mounted) {
                                      setState(() {
                                        //filled.value
                                        
                                      });
                                    }
                                    break;
                                  case DismissDirection.startToEnd:
                                    if (mounted) {
                                      setState(() {
                                        //filled.value
                                        snapshot.data!.deleteFriend(
                                            snapshot.data!.request[index],
                                            snapshot.data!.uid);
                                      });
                                    }
                                    break;
                                }
                              },
                              child: Container(
                                color: Colors.teal,
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AvatarImage(
                                      uid: snapshot.data!.friends[index],
                                      radius: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: UserNameFromDB(
                                        uid: snapshot.data!.friends[index],
                                      ),
                                    ),
                                    // Text(
                                    //   snapshot.data!.friends[index],
                                    //   style: TextStyle(fontSize: 25),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              })),
    );
  }
}
