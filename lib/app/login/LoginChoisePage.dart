import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp2/app/Login/LoginPage.dart';
import 'package:myapp2/app/util/VariablesFile.dart';

class LoginChoisePage extends StatefulWidget {
  const LoginChoisePage({Key? key}) : super(key: key);

  @override
  State<LoginChoisePage> createState() => _LoginChoisePageState();
}

class _LoginChoisePageState extends State<LoginChoisePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login as",
                  style: GoogleFonts.ubuntu(
                    fontSize: 35,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Box("Student"),
                SizedBox(
                  height: 10,
                ),
                Box("Teacher"),
                SizedBox(
                  height: 10,
                ),
                Box("Admin"),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Note : Please contect admin if you don't have account"),
              ],
            ),
          ),
        ),
      ],
    ));
  }

  Box(_lable) {
    return Container(
      //margin: const EdgeInsets.symmetric(horizontal: 25),
      width: 300,
      height: 55,
      decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(25)),
      child: TextButton(
        onPressed: () {
          current_user_type = _lable;
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LogIn(),
              ));
        },
        child: Text(
          _lable,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
