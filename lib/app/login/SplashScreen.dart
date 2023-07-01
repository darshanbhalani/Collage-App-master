import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/home/HomePage.dart';
import 'package:myapp2/app/login/WelcomeScreen.dart';
import 'package:myapp2/app/util/Functions.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.5,
              child: Image.asset('assets/images/icon.png')),
        ],
      ),
      nextScreen: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              getLocalDetails();
              return HomePage();
            } else {
              return WelcomeScreen();
            }
          }),
      splashIconSize: 1000,
      duration: 1500,
    );
  }
}
