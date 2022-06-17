import 'package:flutter/material.dart';
import 'package:swipable_stack/swipable_stack.dart';
import 'package:swiper_app/src/models/chat_user_model.dart';

class ServiceCard extends StatelessWidget {
  final String urlImage, bio;
  ChatUser? user;
  ChatUser? toUser;
  ServiceCard(
      {Key? key,
      required this.toUser,
      required this.urlImage,
      this.bio = '',
      this.user})
      : super(key: key);

  void initState() {
    ChatUser.fromUid(uid: toUser!.uid).then(((value) => {user = value}));
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
            print(toUser!.uid + 'added');
            user!.sendRequest(toUser!.uid, user!.uid);
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
                    colorFilter: ColorFilter.mode(
                        Color.fromARGB(255, 158, 155, 155).withOpacity(0.3),
                        BlendMode.multiply),
                    image: NetworkImage(urlImage),
                    fit: BoxFit.cover,
                    alignment: const Alignment(-0.3, 0),
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.only(top: 400, left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          '@${toUser?.username}',
                          style: const TextStyle(
                            fontSize: 30,
                            color: Color.fromARGB(255, 249, 249, 249),
                            fontFamily: 'Merriweather',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          bio,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 249, 249, 249),
                              fontFamily: 'Merriweather'),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 15, color: Colors.red),
                          Text(
                            'location here',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 249, 249, 249),
                              fontFamily: 'Merriweather',
                            ),
                          ),
                        ],
                      ),
                      // Text(uid)
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
