import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Functions.dart';
import 'package:myapp2/app/util/VariablesFile.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({Key? key}) : super(key: key);

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  bool flag1 = true;
  bool flag2 = false;
  String __name = "";
  String __code = "";
  String __flag = "";
  String __ref = "";
  final _formkey = GlobalKey<FormState>();
  final _branch = SingleValueDropDownController();
  final _semester = SingleValueDropDownController();
  final _subject = SingleValueDropDownController();
  List<String> SubjectNames = [];
  List<DropDownValueModel> SubjectList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Courses"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Visibility(
                visible: flag1 && !flag2,
                child: Column(
                  children: [
                    DropField(context, "Branch", Courses, _branch, true),
                    DropField(context, "Semester", Semesters, _semester, true)
                  ],
                ),
              ),
              Visibility(
                visible: !flag1 && !flag2,
                child: Column(
                  children: [
                    DropField(context, "Subject", SubjectList, _subject, true),
                  ],
                ),
              ),
              Visibility(
                visible: !flag1 && flag2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "Subject Name : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        TextSpan(
                          text: __name,
                        )
                      ],
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                        text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "Subject Code : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        TextSpan(
                          text: __code,
                        )
                      ],
                    )),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                        text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text: "Type : ",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        TextSpan(
                          text: __flag == "false" ? "Main" : "Elective",
                        )
                      ],
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: !flag1 && flag2
            ? null
            : ButtonField(context, "Cancle", Cancle, "Next", Next, _formkey),
      ),
    );
  }

  Cancle() {
    Navigator.pop(context);
  }

  Next() async {
    Loading(context);
    if (flag1) {
      buildSubjectList();
      setState(() {
        flag1 = !flag1;
      });
      Navigator.pop(context);
    } else if (!flag1 && !flag2) {
      await FirebaseFirestore.instance
          .collection('Courses')
          .doc(_branch.dropDownValue!.value)
          .collection(_semester.dropDownValue!.value)
          .doc(_subject.dropDownValue!.value)
          .get()
          .then((value) {
        __name = value["Subject Name"];
        __code = value["Subject Code"];
        __ref = value["Course reference"];
        __flag = value["isElective"].toString();
      });
      setState(() {
        flag2 = true;
        Navigator.pop(context);
      });
    }
  }

  Future buildSubjectList() async {
    await FirebaseFirestore.instance
        .collection('Courses')
        .doc(_branch.dropDownValue!.value)
        .collection(_semester.dropDownValue!.value)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          SubjectNames.add(doc["Subject Name"]);
        });
      });
    });
    for (int i = 0; i < SubjectNames.length; i++) {
      setState(() {
        SubjectList.add(DropDownValueModel(
            name: "${SubjectNames[i]}", value: "${SubjectNames[i]}"));
      });
    }
  }
}
