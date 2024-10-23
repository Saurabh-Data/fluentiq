import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluentIQ/screens/auth/signup_login_page.dart';

import '../screens/drawer_content/daily_quizzes_screen.dart';
import '../screens/drawer_content/english_lyrics_screen.dart';
import '../screens/drawer_content/notifications_screen.dart';
import '../screens/auth/profile/profile_screen.dart';
import '../screens/drawer_content/word_game_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // User profile section
          const UserAccountsDrawerHeader(
            accountName: Text('User Name'),
            accountEmail: Text('user@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text('U'),
            ),
          ),
          // Menu items
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profile'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text('Daily Quizzes'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DailyQuizzesScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.games),
            title: const Text('Meaning Word Games'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WordGame()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text('English Lyrics'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const EnglishLyricsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationsScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              //logout function
              await FirebaseAuth.instance.signOut().then((value) async {
                // for replacing home screen with login screen
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              });
              // Close the drawer
            },
          ),
        ],
      ),
    );
  }
}
