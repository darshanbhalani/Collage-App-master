import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Drawer/Settings/Settings.dart';
import 'package:myapp2/app/util/VariablesFile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../app/home/HomePage.dart';
import 'package:myapp2/app/util/Functions.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  bool isVisible = false;
  String? errorString;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
              child: SingleChildScrollView(
                child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 200,
                        width: 300,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/${cuType}.png"),
                                fit: BoxFit.fill)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          controller: email,
                          validator: (value) {
                            if (value == null) {
                              return "ID can't be empty";
                            } else if (value.length <= 2) {
                              return "Please enter a valid email";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white70,
                            constraints:
                                BoxConstraints(maxHeight: 60, maxWidth: 300),
                            prefixIcon: Icon(Icons.email),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            label: Text('${cuType} ID'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: TextFormField(
                          controller: password,
                          validator: (value) {
                            if (value == null) {
                              return "Password can't be empty";
                            } else if (value.length <= 5) {
                              return "Please enter valid password";
                            } else {
                              return null;
                            }
                          },
                          obscureText: isVisible ? false : true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white70,
                            constraints:
                                BoxConstraints(maxHeight: 60, maxWidth: 300),
                            prefixIcon: Icon(Icons.key_off),
                            suffixIcon: IconButton(
                              onPressed: () {
                                isVisible = !isVisible;
                                setState(() {});
                              },
                              icon: (isVisible)
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.remove_red_eye),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            label: Text('${cuType} Password'),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Forgot Password? '),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPassword(),
                                  ));
                            },
                            child: Text('Click Here'),
                          ),
                        ],
                      ),
                      Text(
                        errorString ?? '',
                        style: TextStyle(color: Colors.red),
                      ),
                      Container(
                        //margin: const EdgeInsets.symmetric(horizontal: 25),
                        width: 300,
                        height: 55,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(25)),
                        child: TextButton(
                          onPressed: () async {
                            if (_key.currentState!.validate()) {
                              await Login().whenComplete(() {
                                if (FirebaseAuth.instance.currentUser != null) {
                                  cuId = email.text.trim().toUpperCase();
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()),
                                      (route) => false);
                                  setDetails();
                                } else {
                                  errorString = 'Invalid User ID or Password\n';
                                  setState(() {});
                                }
                              });
                            }
                          },
                          child: const Text(
                            'Log In',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future Login() async {
    Loading(context);
    var a = await FirebaseFirestore.instance
        .collection(cuType)
        .doc(email.text.trim().toUpperCase())
        .get();
    if (a.exists) {
      await FirebaseFirestore.instance
          .collection(cuType)
          .doc(email.text.trim().toUpperCase())
          .get()
          .then((value) async {
        cuEmail = value["Email Id"];
      }).whenComplete(() async {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: cuEmail, password: password.text.trim());
        } on FirebaseException catch (e) {
          Navigator.pop(context);
          errorString = "Oops! Unvalid ID or Password";
          setState(() {});
        }
      });
    } else {
      Navigator.pop(context);
      setState(() {
        errorString = "Oops! Unvalid ID or Password";
      });
    }
  }
}
