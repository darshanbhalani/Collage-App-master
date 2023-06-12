import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import '../../../app/util/NotificationIcon.dart';
import '../../../app/util/PopupButton.dart';
import 'package:myapp2/app/util/Drawer/SideMenu.dart';

import '../../Login/LoginChoisePage.dart';
import '../../util/Functions.dart';

class LiveClassPage extends StatefulWidget {
  const LiveClassPage({Key? key}) : super(key: key);

  @override
  State<LiveClassPage> createState() => _LiveClassPageState();
}

class _LiveClassPageState extends State<LiveClassPage> {
  TextEditingController _controller =TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(),
      appBar: AppBar(
        title: Text("Live Class"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: (){
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "Enter Session ID",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                          ),
                          content: Form(
                            key: _formkey,
                            child: TextFormField(
                              obscureText: false,
                              enabled: true,
                              maxLines: 1,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter Session ID";
                                }
                              },
                              controller: _controller,
                              decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.teal,
                                    )),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor,
                                      width: 2,
                                    )),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                labelText: "Session ID",
                                labelStyle: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Cancle")),
                            TextButton(
                                onPressed: () async{
                                  // if (_formkey.currentState!.validate()) {
                                  // }
                                },
                                child: Text("Join")),
                          ],
                        );
                      });
                },
                child: Text("Join Session")
            ),
            ElevatedButton(
                onPressed: (){},
                child: Text("Create Session")
            ),
          ],
        ),
      ),
    );
  }
}
