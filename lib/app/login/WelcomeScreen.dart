import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import '../../app/Login/LoginChoisePage.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Welcome",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold))
        ],
      ),
      nextScreen: LoginChoisePage(),
      splashIconSize: 300,
      duration: 1800,
    );
  }
}
