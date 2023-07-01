import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
import 'package:myapp2/app/util/VariablesFile.dart';
import 'package:myapp2/app/util/Drawer/SideMenu.dart';
import '../../util/Functions.dart';

class LiveClassPage extends StatefulWidget {
  const LiveClassPage({Key? key}) : super(key: key);

  @override
  State<LiveClassPage> createState() => _LiveClassPageState();
}

class _LiveClassPageState extends State<LiveClassPage> {
  final _formkey = GlobalKey<FormState>();

  final serverText = TextEditingController();

  bool isAudioMuted = true;
  bool isVideoMuted = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        title: Text("Live Class"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 200,
              width: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/Liveclass.png"),
                      fit: BoxFit.fill)),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  TextEditingController _controller = TextEditingController();
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "Enter Session ID",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
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
                                onPressed: () async {
                                  if (_formkey.currentState!.validate()) {
                                    Session(_controller.text);
                                  }
                                },
                                child: Text("Join")),
                          ],
                        );
                      });
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  child: Text(" Join Session "),
                )),
            Visibility(
                visible: cuType != "Student",
                child: SizedBox(
                  height: 20,
                )),
            Visibility(
              visible: cuType != "Student",
              child: ElevatedButton(
                  onPressed: () async {
                    Loading(context);
                    var roomID = await getRandomString();
                    TextEditingController _controller1 =
                        TextEditingController(text: roomID);
                    TextEditingController _controller2 =
                        TextEditingController();

                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              title: Text(
                                "New Session",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                              content: Form(
                                key: _formkey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextFormField(
                                      obscureText: false,
                                      enabled: false,
                                      maxLines: 1,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter Subject";
                                        }
                                      },
                                      controller: _controller1,
                                      decoration: InputDecoration(
                                        disabledBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.grey),
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
                                          borderSide:
                                              BorderSide(color: Colors.grey),
                                        ),
                                        labelText: "Session ID",
                                        labelStyle: TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "Note : Please Note Down SessionID",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TFormField(context, "Subject", _controller2,
                                        true, false)
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancle")),
                                TextButton(
                                    onPressed: () async {
                                      if (_formkey.currentState!.validate()) {
                                        await createSession(
                                                context,
                                                _controller1.text,
                                                _controller2.text)
                                            .whenComplete(() {
                                          SimpleSnackBar(context,
                                              "Session Sucessfully Created");
                                        });
                                      }
                                    },
                                    child: Text("Create")),
                                TextButton(
                                    onPressed: () async {
                                      if (_formkey.currentState!.validate()) {
                                        await createSession(
                                                context,
                                                _controller1.text,
                                                _controller2.text)
                                            .whenComplete(() {
                                          Session(_controller1.text);
                                        });
                                      }
                                    },
                                    child: Text("Create & Join")),
                              ]);
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    child: Text("Start Session "),
                  )),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Future createSession(context, String _id, String _subject) async {
    Loading(context);
    await FirebaseFirestore.instance.collection("Live Class").doc(_id).set({
      "Session Id": _id,
      "Creation Time": DateTime.now(),
      "Host": cuName,
      "Subject": _subject,
    }).whenComplete(() => Navigator.pop(context));
  }

  Session(String _roomID) async {
    Map<FeatureFlag, Object> featureFlags = {
      FeatureFlag.isAddPeopleEnabled: false,
    };

    var options = JitsiMeetingOptions(
      roomNameOrUrl: _roomID,
      isAudioMuted: isAudioMuted,
      isVideoMuted: isVideoMuted,
      userDisplayName: "${cuId} ${cuName}",
      userAvatarUrl: cuPhoto,
      featureFlags: featureFlags,
    );

    await JitsiMeetWrapper.joinMeeting(
      options: options,
    );
  }
}
