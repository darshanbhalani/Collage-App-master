import 'package:flutter/material.dart';
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
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/Scafoldbg.jpg"),
              fit: BoxFit.fitWidth,
            )),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/Login.png"),
                          fit: BoxFit.fill)),
                ),
                SizedBox(
                  height: 20,
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
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                      "Note : Please contect admin if you don't have account"),
                ),
                const SizedBox(
                  height: 60,
                ),
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
          cuType = _lable;
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
