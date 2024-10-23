import 'dart:developer' as dev;

import 'package:fluentIQ/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentIQ/screens/auth/signup_login_page.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      // Reloading current user data each time when the app starts
      await FirebaseAuth.instance.currentUser?.reload();

      if (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.emailVerified) {
        // Navigate to home screen
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        // Navigate to login screen
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User not found. The user may have been deleted.'),
        ));
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        // Handle other FirebaseAuthExceptions if needed
        dev.log('Error checking authentication: $e');
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Something went wrong! (Check internet connection and "TAP ANYWHERE")'),
        ));
      }
    } catch (e) {
      // Handle generic errors
      dev.log('Unexpected error checking authentication: $e');
    } finally {
      // Set loading to false regardless of the result
      // setState(() {
      //   isLoading = false;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size mq = MediaQuery.of(context).size;

    return Scaffold(
      body: InkWell(
        onTap: _checkAuthentication,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash_background.png'),
              fit: BoxFit.cover, // This makes the image cover the entire screen
            ),
          ),
        ),
      ),
    );
  }
}
