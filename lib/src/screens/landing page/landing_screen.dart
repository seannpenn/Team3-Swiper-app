import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swiper_app/service_locators.dart';
import 'package:swiper_app/src/controllers/auth_controller.dart';
import 'package:swiper_app/src/controllers/navigation/navigation_service.dart';
import 'package:swiper_app/src/screens/chat/chat_screen.dart';
import 'package:swiper_app/src/screens/home/home_screen.dart';
import 'package:swiper_app/src/screens/profile/profile_screen.dart';
import 'package:swiper_app/src/services/image_service.dart';
import 'package:swiper_app/src/widgets/avatars.dart';

class LandingScreen extends StatefulWidget {
  static const String route = 'landing-screen';
  const LandingScreen({Key? key}) : super(key: key);

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final AuthController _auth = locator<AuthController>();
  int _selectedIndex = 1;
  final List _children = [
    const ProfileScreen(),
    const HomeScreen(),
    const ChatScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
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

        selectedItemColor: Colors.teal[800],
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // if (_selectedIndex == 0) {
    //   locator<NavigationService>().pushReplacementNamed(ProfileScreen.route);
    // }
    // if (_selectedIndex == 2) {
    //   locator<NavigationService>().pushReplacementNamed(ChatScreen.route);
    // }
  }
}
