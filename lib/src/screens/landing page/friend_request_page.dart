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
  const FriendRequestScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<FriendRequestScreen> createState() => _FriendRequestScreenState();
}

class _FriendRequestScreenState extends State<FriendRequestScreen> {
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
        title: const Text('Friend Requests'),
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
                  child: snapshot.data!.request.isNotEmpty
                      ? ListView.builder(
                          itemCount: snapshot.data!.request.length,
                          itemBuilder: (context, index) {
                            final request = snapshot.data!.request[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Dismissible(
                                  key: ObjectKey(request),
                                  background: Container(
                                    alignment: Alignment.centerLeft,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    color: Colors.orange,
                                    child: Icon(Icons.check,
                                        color: Colors.white, size: 32),
                                  ),
                                  secondaryBackground: Container(
                                    alignment: Alignment.centerRight,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    color: Colors.red,
                                    child: Icon(Icons.close,
                                        color: Colors.white, size: 32),
                                  ),
                                  onDismissed: (direction) async {
                                    switch (direction) {
                                      case DismissDirection.endToStart:
                                        if (mounted) {
                                          setState(() {
                                            //filled.value
                                            snapshot.data!.declineRequest(
                                                snapshot.data!.request[index],
                                                snapshot.data!.uid);
                                          });
                                        }
                                        break;
                                      case DismissDirection.startToEnd:
                                        if (mounted) {
                                          setState(() {
                                            //filled.value
                                            snapshot.data!.acceptRequest(
                                                snapshot.data!.request[index],
                                                snapshot.data!.uid);
                                          });
                                        }
                                        break;
                                    }
                                  },
                                  child: Container(
                                    color: Colors.teal,
                                    // decoration: ShapeDecoration(
                                    //   shape: RoundedRectangleBorder(
                                    //       borderRadius:
                                    //           BorderRadius.all(Radius.circular(20))),
                                    //   color: Colors.green[400],
                                    // ),
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                        bottom: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data!.request[index],
                                          style: TextStyle(fontSize: 25),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          })
                      : Center(
                          child: Text(
                              "That's sad! You don't have any requests!",
                              style: TextStyle(fontSize: 18))),
                );
              })),
    );
  }
}
