import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Functions.dart';
import 'package:myapp2/app/util/VariablesFile.dart';

class BroadcastMessage extends StatefulWidget {
  const BroadcastMessage({Key? key}) : super(key: key);

  @override
  State<BroadcastMessage> createState() => _BroadcastMessageState();
}

class _BroadcastMessageState extends State<BroadcastMessage> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  late DatabaseReference firebaseMsgDbRef;

  @override
  void initState() {
    this.firebaseMsgDbRef =
        FirebaseDatabase.instance.ref().child('Stream/Classes');
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Broadcast Message"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: TextFormField(
                    controller: controller,
                    maxLines: 5,
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
                      labelText: "Broadcast Message",
                      labelStyle: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        bottomSheet: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ButtonField(
                context, "Cancle", Cancle, "Send", Send, _formkey)));
  }

  Cancle() {
    Navigator.of(context).pop();
  }

  Send() async{
    Loading(context);
    List<String> classList = [];
    final postTime = DateTime.now();
    await FirebaseFirestore.instance
        .collection('Class')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          classList.add(doc["Class Name"]);
        });
      });
    });
    print(classList);
    for (int i = 0; i < classList.length; i++) {
      FirebaseDatabase.instance.ref().child('Stream/Classes').child(classList[i]).push().set({
        'senderType': "Admin",
        'senderId': cuId,
        'senderName': "Admin Department ( ${cuFirstName} ${cuLastName} )",
        'senderPhotoUrl': cuPhoto,
        'text': controller.text,
        'time': postTime.format('D, M j, H:i'),
      });
    }
    Navigator.pop(context);
    SimpleSnackBar(context, "Broadcast message succesfully sended to all classes.");
  }
}
