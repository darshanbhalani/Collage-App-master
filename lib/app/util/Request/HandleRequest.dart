import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Functions.dart';
import '../VariablesFile.dart';

class HandleRequest extends StatefulWidget {
  final bool handle;
  final String flag1;
  final String flag2;
  final String doc;
  final String id;
  final String name;
  final String branch;
  final String semester;
  final String cls;
  final String title;
  final String purpose;
  final Timestamp requesttime;
  final String type;
  final bool flag;
  final String feedback;
  final String approvedby;
  final String rejectedby;
  final String rejectedtime;
  final String approvedtime;

  const HandleRequest(
      {required this.handle,
      required this.flag1,
      required this.flag2,
      required this.doc,
      required this.id,
      required this.name,
      required this.branch,
      required this.semester,
      required this.cls,
      required this.title,
      required this.purpose,
      required this.requesttime,
      required this.type,
      required this.flag,
      required this.feedback,
      required this.approvedby,
      required this.rejectedby,
      required this.approvedtime,
      required this.rejectedtime});

  @override
  State<HandleRequest> createState() => _HandleRequestState();
}

class _HandleRequestState extends State<HandleRequest> {
  TextEditingController _feedback = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.doc),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListView(
          children: [
            ShowField("ID", widget.id, false),
            ShowField("Name", widget.name, false),
            ShowField("Branch", widget.branch, false),
            Visibility(
                visible: widget.flag2 == "Approved",
                child: Column(
                  children: [
                    ShowField("Semester", widget.semester, false),
                    ShowField("Class", widget.cls, false),
                  ],
                )),
            ShowField("Title", widget.title, false),
            ShowField("Purpose", widget.purpose, false),
            ShowField(
                "Request Time", widget.requesttime.toDate().toString(), false),
            Visibility(
                visible: widget.flag2 == "Approved Request",
                child: Column(
                  children: [
                    ShowField("Approved by", widget.approvedby, false),
                    ShowField("Approved Time", widget.approvedtime, false),
                  ],
                )),
            Visibility(
                visible: widget.flag2 == "Rejected Request",
                child: Column(
                  children: [
                    ShowField("Rejected by", widget.rejectedby, false),
                    ShowField("Rejected Time", widget.rejectedtime, false),
                  ],
                )),
          ],
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: widget.handle,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () async {
                  LeftBTN();
                },
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Center(
                      child: Text(
                    "Reject",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
              InkWell(
                onTap: () async {
                  await RightBTN();
                },
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Center(
                      child: Text(
                    "Approve",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future LeftBTN() async {
    Box(context, "Reject");
  }

  Future RightBTN() async {
    Box(context, "Approve");
  }

  Box(context, String _lable) {
    final _formkey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${_lable} ?",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  )
                ],
              ),
              content: Form(
                key: _formkey,
                child: TextFormField(
                  obscureText: false,
                  enabled: true,
                  maxLines: 4,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter feedback";
                    }
                  },
                  controller: _feedback,
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
                    labelText: "Feedback",
                    labelStyle: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      _feedback.clear();
                      Navigator.pop(context);
                    },
                    child: Text("No")),
                TextButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        Process("Approved");
                      }
                    },
                    child: Text("Yes")),
              ],
            ),
          );
        });
  }

  Future Process(String _lable) async {
    Loading(context);
    var request_time = DateTime.now();
    await FirebaseFirestore.instance
        .collection("${_lable} Request")
        .doc(widget.doc)
        .set({
      "Doc": widget.doc,
      "Title": widget.title,
      "Purpose": widget.purpose,
      "ID": widget.id,
      "Name": widget.name,
      "Branch": widget.branch,
      "Class": widget.cls,
      "Semester": widget.semester,
      "Request Time": widget.requesttime,
      "${_lable} Time": request_time,
      "Type": widget.type,
      "Flag": true,
      "Feedback": _feedback.text,
      "${_lable} By": cuName,
    }).whenComplete(() async {
      await FirebaseFirestore.instance
          .collection("Pending Request")
          .doc(widget.doc)
          .delete()
          .whenComplete(() {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context);
      });
    });
  }
}
