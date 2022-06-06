import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swiper_app/src/controllers/chat_controller.dart';
import 'package:swiper_app/src/controllers/navigation/navigation_service.dart';
import 'package:swiper_app/src/models/chat_user_model.dart';
import 'package:swiper_app/src/screens/chat/chat_screen.dart';
import 'package:swiper_app/src/services/image_service.dart';
import 'package:swiper_app/src/widgets/avatars.dart';

import '../../../service_locators.dart';
import '../../controllers/auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  static const String route = 'profile-screen';
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _auth = locator<AuthController>();
  // final ChatController _chatController = ChatController();

  // final TextEditingController _messageController = TextEditingController();
  // final FocusNode _messageFN = FocusNode();
  // final ScrollController _scrollController = ScrollController();
  // ChatCard? card;
  int _selectedIndex = 0;

  ChatUser? user;
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
                  // const DrawerHeader(
                  //   child: Text('Menu drawer'),
                  //   decoration: BoxDecoration(
                  //     color: Colors.red,
                  //   ),
                  // ),
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
                      // locator<NavigationService>().pushReplacementNamed(HomeScreen.route);
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  ImageService.updateProfileImage();
                },
                child: AvatarImage(
                  uid: FirebaseAuth.instance.currentUser!.uid,
                  radius: 80,
                ),
              ),
              Text('${user?.username}'),
              Text('${user?.email}'),
              const Text('This is profile screen'),
              // IconButton(
              //     onPressed: () {
              //       locator<NavigationService>()
              //           .pushReplacementNamed(ChatScreen.route);
              //     },
              //     icon: const Icon(Icons.chat)),
            ],
          ),
        ),
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
    // if(_selectedIndex == 1){
    //   locator<NavigationService>().pushReplacementNamed(HomeScreen.route);
    // }
    if (_selectedIndex == 2) {
      locator<NavigationService>().pushReplacementNamed(ChatScreen.route);
    }
  }
}
