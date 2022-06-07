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

  // final TextEditingController _messageController = TextEditingController();
  // final FocusNode _messageFN = FocusNode();
  // final ScrollController _scrollController = ScrollController();
  // ChatCard? card;
  int _selectedIndex = 0;

  // ChatUser? user;
  // String? user;
  int userCount = 1;
  ServiceCard? card;
  List<String> users = [];

  @override
  void initState() {
    getUsers();
    // ChatUser.totalFollowers().then((value) => userCount = value);
    // ChatUser.fromUid(uid: _auth.currentUser!.uid).then((value) {
    //   if (mounted) {
    //     setState(() {
    //       user = value;
    //     });
    //   }
    // });
    // _chatController.addListener(scrollToBottom);
    super.initState();
    print(userCount);
  }

  // scrollToBottom() async {
  //   await Future.delayed(const Duration(milliseconds: 250));
  //   print('scrolling to bottom');
  //   _scrollController.animateTo(_scrollController.position.maxScrollExtent,
  //       curve: Curves.easeIn, duration: const Duration(milliseconds: 250));
  // }

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
      appBar: AppBar(
        title: const Text('Swip3'),
        backgroundColor: Colors.teal[400],
        actions: [
          Builder(builder: (context) {
            return IconButton(
              onPressed: () async {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          }),
        ],
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      ImageService.updateProfileImage();
                    },
                    child: AvatarImage(
                        uid: FirebaseAuth.instance.currentUser!.uid),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  UserNameFromDB(uid: FirebaseAuth.instance.currentUser!.uid)
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(
                      Icons.home,
                      size: 40,
                    ),
                    title: const Center(child: Text('Home')),
                    // subtitle: const Text("This is the 1st item"),
                    trailing: const Icon(Icons.more_vert),
                    onTap: () {
                      print('Home tapped');
                      locator<NavigationService>()
                          .pushReplacementNamed(HomeScreen.route);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                      size: 40,
                    ),
                    title: const Center(child: Text('Friends')),
                    // subtitle: const Text("This is the 1st item"),
                    trailing: const Icon(Icons.more_vert),
                    onTap: () {
                      print('Friends tapped');
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.edit_note,
                      size: 40,
                    ),
                    title: const Center(child: Text('Edit Profile')),
                    // subtitle: const Text("This is the 1st item"),
                    trailing: const Icon(Icons.more_vert),
                    onTap: () {
                      print('Edit Profile tapped');
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout_sharp),
              title: const Text('Log out'),
              onTap: () async {
                _auth.logout();
              },
            )
          ],
        ),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
            animation: _userController,
            builder: (context, Widget? w) {
              return Stack(
                alignment: AlignmentDirectional.topStart,
                fit: StackFit.loose,
                children: [
                  for (ChatUser user in _userController.users)
                    SwipableStack(
                        itemCount: 1,
                        builder: (BuildContext context, properties) {
                          return ServiceCard(
                            uid: user.uid,
                            urlImage: user.image,
                            // uid: 'YnalBPZuvCOctbEHUI0u3umpGQW2',
                            // urlImage:
                            //     'https://firebasestorage.googleapis.com/v0/b/team3-swiper-app.appspot.com/o/profiles%2FYnalBPZuvCOctbEHUI0u3umpGQW2%2Fimage_picker3548547769139398435.jpg?alt=media&token=e99c19e4-2563-4889-8983-fac91e1273af',
                          );
                        })
                ],
              );
            }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedIconTheme: const IconThemeData(
          color: Colors.grey,
        ),
        unselectedItemColor: Colors.deepOrangeAccent,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Messages',
          ),
        ],
        // currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      locator<NavigationService>().pushReplacementNamed(ProfileScreen.route);
    }
    if (_selectedIndex == 2) {
      locator<NavigationService>().pushReplacementNamed(ChatScreen.route);
    }
  }

  getUsers() {
    userRef.get().then((QuerySnapshot snapshot) {
      for (var doc in snapshot.docs) {
        users.add(doc.id);
      }
    });
  }

  testPrint(String id) {
    print(id);
  }
}
