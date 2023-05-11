import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp2/app/util/Drawer/Settings/Settings.dart';
import 'package:myapp2/app/util/VariablesFile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../app/home/HomePage.dart';
import 'package:myapp2/app/util/Functions.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   bool _passwordvisible = true;
//   final _formkey = GlobalKey<FormState>();
//   var _idcontroller = TextEditingController();
//   var _passwordcontroller = TextEditingController();
//   var errormessage = 'ab';
//   bool hover_color = false;
//   Color submit_button_color = Colors.red;
//
//   void dispose() {
//     super.dispose();
//     _idcontroller.dispose();
//     _passwordcontroller.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(200, 12, 3, 42),
//       body: Stack(children: [
//         Center(
//             child: RiveAnimation.asset(
//               "assets/images/Animation2.riv",
//               fit: BoxFit.cover,
//             )),
//         Positioned.fill(
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
//               child: Container(),
//             )),
//         SafeArea(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Form(
//                 key: _formkey,
//                 child: Padding(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       SizedBox(height: 25),
//                       Text(
//                         current_user_type + " Login",
//                         style: TextStyle(
//                             fontSize: 30, fontWeight: FontWeight.bold),
//                       ),
//                       Box("${current_user_type} ID", _idcontroller,
//                           Icons.person, null, null, false),
//                       Box("Password", _passwordcontroller, Icons.lock,
//                           Icons.remove_red_eye, Icons.visibility_off, true),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Center(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text("Forgot Password ? "),
//                             InkWell(
//                                 onTap: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             ForgotPassword(),
//                                       ));
//                                 },
//                                 child: Text(
//                                   "Click Here",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.blue),
//                                 ))
//                           ],
//                         ),
//                       ),
//                       SizedBox(height: 15),
//                       Visibility(
//                           visible: errormessage.length > 2,
//                           child: Text(
//                             'Invalid Username or Password',
//                             style: TextStyle(fontSize: 15, color: Colors.red),
//                           )),
//                       SizedBox(height: 15),
//                       InkWell(
//                         onTap: () async {
//                           setState(() {
//                             isLoading = true;
//                           });
//                           if (_formkey.currentState!.validate()) {
//                             await getEmail(current_user_type,
//                                 _idcontroller.text.toString().toUpperCase());
//                           }
//                         },
//                         child: Container(
//                           padding: EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                                 color: Color.fromARGB(255, 231, 20, 216)),
//                             color: Color.fromARGB(102, 170, 25, 160),
//                             borderRadius: BorderRadius.circular(28),
//                           ),
//                           child: Center(
//                               child: Text(
//                                 "Login",
//                                 style: TextStyle(
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white),
//                               )),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ]),
//     );
//   }
//
//   Box(_lable, _controller, IconData? _icon, IconData? _icnvisible,
//       IconData? _icnnotvisible, bool _ispassword) {
//     return Column(
//       children: [
//         SizedBox(height: 25),
//         TextFormField(
//           obscureText: (_ispassword) ? _passwordvisible : false,
//           validator: (value) {
//             if (value!.isEmpty) {
//               return "Enter ${_lable}";
//             }
//           },
//           controller: _controller,
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(28),
//                 borderSide: BorderSide(
//                   color: Colors.teal,
//                 )),
//             prefixIcon: Icon(
//               _icon,
//               color: Colors.blue,
//             ),
//             suffixIcon: (_ispassword)
//                 ? InkWell(
//               onTap: () {
//                 setState(() {
//                   _passwordvisible = !_passwordvisible;
//                 });
//               },
//               child:
//               Icon(!_passwordvisible ? _icnvisible : _icnnotvisible),
//             )
//                 : null,
//             labelText: _lable,
//             labelStyle: TextStyle(
//               fontSize: 15,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Future LogIn() async {
//     Loading(context);
//     try {
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: current_user_email, password: _passwordcontroller.text.trim());
//       current_user_enrollmentno = _idcontroller.text.toString().toUpperCase();
//       await getDetails(
//           current_user_type, _idcontroller.text.toString().toUpperCase()).then((value) async=> await setDetails());
//       Navigator.popUntil(context, (route) => false);
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => HomePage()));
//       Navigator.push(
//           context, MaterialPageRoute(builder: (context) => HomePage()));
//     } on FirebaseException catch (error) {
//       Navigator.pop(context);
//       setState(() {
//         errormessage = error.message!;
//       });
//     }
//   }
//
//   Future getEmail(String collection, String id) async {
//     Loading(context);
//     try {
//       var a =
//       await FirebaseFirestore.instance.collection(collection).doc(id).get();
//       if (a.exists) {
//         await FirebaseFirestore.instance
//             .collection(collection)
//             .doc(id)
//             .get()
//             .then((value) async {
//           current_user_email = value["Email Id"];
//           Navigator.pop(context);
//           await LogIn();
//         });
//       } else {
//         Navigator.pop(context);
//         setState(() {
//           errormessage = "Oops! User not found";
//         });
//       }
//     } on FirebaseException catch (error) {
//       Navigator.pop(context);
//     }
//   }
// }

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
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login as ${current_user_type}',
                    style: GoogleFonts.ubuntu(
                      fontSize: 35,
                    ),
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
                        } else if (value!.length <= 2) {
                          return "Please enter a valid email";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
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
                        label: Text('${current_user_type} ID'),
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
                        } else if (value!.length <= 5) {
                          return "Please enter valid password";
                        } else {
                          return null;
                        }
                      },
                      obscureText: isVisible ? false : true,
                      decoration: InputDecoration(
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
                        label: Text('${current_user_type} Password'),
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
                          await logIn().whenComplete(() {
                            if (FirebaseAuth.instance.currentUser != null) {
                              current_user_enrollmentno = email.text.trim();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage()),
                                      (route) => false);
                              setDetails();
                            } else {
                              errorString =
                              'Invalid User ID or Password\n';
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text('New User? '),
                  //      TextButton(
                  //        onPressed: () {
                  //          Navigator.push(
                  //              context,
                  //              MaterialPageRoute(
                  //                  builder: (context) => const SignUp()));
                  //        },
                  //        child: Text('Sign Up'),
                  //      ),
                  //   ],
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future getEmail(String collection, String id) async {
    Loading(context);
    try {
      var a =
      await FirebaseFirestore.instance.collection(collection).doc(id).get();
      if (a.exists) {
        await FirebaseFirestore.instance
            .collection(collection)
            .doc(id)
            .get()
            .then((value) async {
          current_user_email = value["Email Id"];
          await LogIn();
        });
      } else {
        Navigator.pop(context);
        setState(() {
          errorString = "Oops! User not found";
        });
      }
    } on FirebaseException catch (error) {
      Navigator.pop(context);
    }
  }

  Future logIn() async {
    try {
      await getEmail(current_user_type, email.text.trim().toUpperCase())
          .whenComplete(() async {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: current_user_email ?? '', password: password.text.trim());
        } on FirebaseException catch (e) {
          Navigator.pop(context);

          errorString = e.message;
          setState(() {});
        }
      });
    } on FirebaseException catch (e) {
      Navigator.pop(context);

      errorString = e.message;
      setState(() {});
    }
    // Navigator.pop(context);

  }
}