// import 'dart:io';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
// // import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';
// import 'package:myapp2/app/util/VariablesFile.dart';
// import '../../../app/util/NotificationIcon.dart';
// import '../../../app/util/PopupButton.dart';
// import 'package:myapp2/app/util/Drawer/SideMenu.dart';
//
// import '../../Login/LoginChoisePage.dart';
// import '../../util/Functions.dart';
//
// class LiveClassPage extends StatefulWidget {
//   const LiveClassPage({Key? key}) : super(key: key);
//
//   @override
//   State<LiveClassPage> createState() => _LiveClassPageState();
// }
//
// class _LiveClassPageState extends State<LiveClassPage> {
//   TextEditingController _controller = TextEditingController();
//   final _formkey = GlobalKey<FormState>();
//
//   final serverText = TextEditingController();
//
//   bool isAudioMuted = true;
//   bool isVideoMuted = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: SideMenu(),
//       appBar: AppBar(
//         title: Text("Live Class"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//                 onPressed: () {
//                   showDialog(
//                       context: context,
//                       builder: (context) {
//                         return AlertDialog(
//                           title: Text(
//                             "Enter Session ID",
//                             style: TextStyle(fontWeight: FontWeight.bold,
//                                 fontSize: 25),
//                           ),
//                           content: Form(
//                             key: _formkey,
//                             child: TextFormField(
//                               obscureText: false,
//                               enabled: true,
//                               maxLines: 1,
//                               validator: (value) {
//                                 if (value!.isEmpty) {
//                                   return "Enter Session ID";
//                                 }
//                               },
//                               controller: _controller,
//                               decoration: InputDecoration(
//                                 disabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.grey),
//                                 ),
//                                 border: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                       color: Colors.teal,
//                                     )),
//                                 focusedBorder: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                       color: Theme
//                                           .of(context)
//                                           .primaryColor,
//                                       width: 2,
//                                     )),
//                                 enabledBorder: const OutlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.grey),
//                                 ),
//                                 labelText: "Session ID",
//                                 labelStyle: TextStyle(
//                                   fontSize: 15,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           actions: [
//                             TextButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Text("Cancle")),
//                             TextButton(
//                                 onPressed: () async {
//                                   if (_formkey.currentState!.validate()) {
//                                     // Session(_controller.text);
//                                   }
//                                 },
//                                 child: Text("Join")),
//                           ],
//                         );
//                       });
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 50, vertical: 20),
//                   child: Text(" Join Session "),
//                 )
//             ),
//             Visibility(
//                 visible: current_user_type != "Student",
//                 child: SizedBox(height: 20,)),
//             Visibility(
//               visible: current_user_type != "Student",
//               child: ElevatedButton(
//                   onPressed: () async {
//                     Loading(context);
//                     var roomID = await getRandomString();
//                     print(
//                         "-----------------------------------------------------------");
//                     print(roomID);
//                     print(
//                         "-----------------------------------------------------------");
//                     if (roomID.isNotEmpty) {
//                       Navigator.pop(context);
//                       // Session(roomID);
//                     }
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 50, vertical: 20),
//                     child: Text("Start Session "),
//                   )
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Session(String _roomID) async {
//     Map<FeatureFlag, Object> featureFlags = {
//       FeatureFlag.isAddPeopleEnabled: false,
//     };
//
//     var options = JitsiMeetingOptions(
//       roomNameOrUrl: _roomID,
//       isAudioMuted: isAudioMuted,
//       isVideoMuted: isVideoMuted,
//       userDisplayName: "${current_user_enrollmentno} ${current_user_name}",
//       userAvatarUrl: current_user_photo,
//       featureFlags: featureFlags,
//     );
//
//     await JitsiMeetWrapper.joinMeeting(
//       options: options,
//     );
//   }
//
//
// }
