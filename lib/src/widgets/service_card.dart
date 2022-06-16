import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:swiper_app/service_locators.dart';
import 'package:swiper_app/src/controllers/auth_controller.dart';
import 'package:swiper_app/src/models/chat_user_model.dart';

class ServiceCard extends StatelessWidget {
  final String uid, urlImage;
  ChatUser? user;
  final AuthController _auth = locator<AuthController>();
  ServiceCard({Key? key, required this.uid, required this.urlImage, this.user})
      : super(key: key);

  void initState() {
    ChatUser.fromUid(uid: _auth.currentUser!.uid)
        .then(((value) => {user = value}));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SwipableStack(
        itemCount: 1,
        onWillMoveNext: (index, directions) {
          final allowed = [SwipeDirection.right, SwipeDirection.left];

          return allowed.contains(directions);
        },
        onSwipeCompleted: (index, direction) {
          if (direction == SwipeDirection.right) {
            print(user!.uid);
            print(uid + 'added');
            user!.sendRequest(uid, user!.uid);
          } else {
            print('Rejected');
          }
          print('$index, $direction');
        },
        horizontalSwipeThreshold: 0.8,
        verticalSwipeThreshold: 0.8,
        builder: (BuildContext context, properties) {
          return SizedBox.expand(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(urlImage),
                    fit: BoxFit.cover,
                    alignment: const Alignment(-0.3, 0),
                  ),
                ),
                child: Center(
                    child: Column(
                  children: [
                    const Text(
                      '{Hi Im Sean, I can work out with you :D}',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.orange,
                          backgroundColor: Colors.black),
                    ),
                    Text(uid)
                  ],
                )),
              ),
            ),
          );
        },
      ),
    );
  }
}
