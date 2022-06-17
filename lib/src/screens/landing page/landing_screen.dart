import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swiper_app/service_locators.dart';
import 'package:swiper_app/src/controllers/auth_controller.dart';
import 'package:swiper_app/src/controllers/navigation/navigation_service.dart';
import 'package:swiper_app/src/models/chat_user_model.dart';
import 'package:swiper_app/src/screens/chat/chat_home_screen.dart';

import 'package:swiper_app/src/screens/home/home_screen.dart';
import 'package:swiper_app/src/screens/landing%20page/friend_request_page.dart';
import 'package:swiper_app/src/screens/landing%20page/friends_page.dart';
import 'package:swiper_app/src/screens/profile/profile_screen.dart';
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
    // locator<NavigationService>().pushReplacementNamed(HomeScreen.route),
    const ChatHomeScreen()
  ];
  late final ChatUser? currentUser;

  @override
  void initState() {
    ChatUser.fromUid(uid: _auth.currentUser!.uid).then((value) {
      if (mounted) {
        setState(() {
          currentUser = value;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SwipeR', style: TextStyle(fontFamily: 'Sniglet')),
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
        child: Container(
          decoration: const BoxDecoration(
            // borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(35), topRight: Radius.circular(35)),
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color.fromARGB(255, 56, 208, 193),
                Color.fromARGB(194, 1, 61, 85)
              ],
            ),
          ),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35)),
                  color: Colors.white,
                ),
                child: DrawerHeader(
                  child: Row(
                    children: [
                      InkWell(
                        // onTap: () {
                        //   ImageService.updateProfileImage();
                        // },
                        child: AvatarImage(
                            uid: FirebaseAuth.instance.currentUser!.uid),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      UserNameFromDB(
                          uid: FirebaseAuth.instance.currentUser!.uid)
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    // ListTile(
                    //   leading: const Icon(
                    //     Icons.home,
                    //     size: 40,
                    //   ),
                    //   title: const Center(child: Text('Home')),
                    //   // subtitle: const Text("This is the 1st item"),
                    //   trailing: const Icon(Icons.more_vert),
                    //   onTap: () {
                    //     print('Home tapped');
                    //     locator<NavigationService>()
                    //         .replaceLastRouteStackRecord(HomeScreen.route);
                    //   },
                    // ),
                    ListTile(
                      leading: const Icon(
                        Icons.add,
                        size: 40,
                      ),
                      title: const Center(child: Text('Requests')),
                      // subtitle: const Text("This is the 1st item"),
                      trailing: const Icon(Icons.more_vert),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const FriendRequestScreen()),
                        );
                        print('Requests tapped');
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FriendScreen()),
                        );
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35)),
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: ListTile(
                  leading: const Icon(Icons.logout_sharp),
                  title: const Text('Log out'),
                  onTap: () async {
                    _auth.logout();
                  },
                ),
              )
            ],
          ),
        ),
      ),
      body: _children[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,

          backgroundColor: Color.fromARGB(255, 255, 255, 255),
          unselectedIconTheme: const IconThemeData(
            color: Colors.grey,
          ),
          unselectedItemColor: Colors.grey,

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
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      locator<NavigationService>()
          .replaceLastRouteStackRecord(ProfileScreen.route);
    }
    if (_selectedIndex == 1) {
      locator<NavigationService>()
          .replaceLastRouteStackRecord(HomeScreen.route);
    }
    if (_selectedIndex == 2) {
      locator<NavigationService>()
          .replaceLastRouteStackRecord(ChatHomeScreen.route);
    }
  }
}
