import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Functions.dart';
import 'package:myapp2/app/util/VariablesFile.dart';
import '../../../../app/util/NotificationIcon.dart';
import '../../../../app/util/PopupButton.dart';

class CreateNewClass extends StatefulWidget {
  const CreateNewClass({Key? key}) : super(key: key);

  @override
  State<CreateNewClass> createState() => _CreateNewClassState();
}

class _CreateNewClassState extends State<CreateNewClass> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _className = TextEditingController();
  final TextEditingController _finalYear = TextEditingController();
  final TextEditingController _initYear = TextEditingController();
  final SingleValueDropDownController _teachers =
      SingleValueDropDownController();
  final SingleValueDropDownController _department =
      SingleValueDropDownController();
  final SingleValueDropDownController _semester =
      SingleValueDropDownController();

  List<String> teacherID = [];
  List<String> teacherF = [];
  List<String> teacherL = [];
  List<DropDownValueModel> teachersList = [];
  List selected_teachers = [];
  List tPhoto = [];

  @override
  void initState() {
    buildTeachersList();
    super.initState();
  }

  @override
  void dispose() {
    _className.dispose();
    _department.dispose();
    _semester.dispose();
    _initYear.dispose();
    _finalYear.dispose();
    _teachers.dispose();
    super.dispose();
  }

  Clear() {
    setState(() {
      _className.clear();
      _initYear.clear();
      _finalYear.clear();
      _teachers.setDropDown(null);
      _semester.setDropDown(null);
      _department.setDropDown(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create New Class"),
          actions: [
            NotificationIcon(),
            PopupButton(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: ListView(
            children: [
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    TFormField(context, "Class Name", _className, true, false),
                    DropField(context, "Branch", Courses, _department, true),
                    DropField(context, "Semester", Semesters, _semester, true),
                    TFormField(context, "Joining Year", _initYear, true, false),
                    TFormField(context, "Final Year", _finalYear, true, false),
                    DropField(context, "Mentor", teachersList, _teachers, true),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ButtonField(
              context, "Clear", Clear, "Submit", createClass, _formkey),
        ));
  }

  Future getTeacherNames() async {
    await FirebaseFirestore.instance
        .collection('Teacher')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          teacherID.add(doc["ID"]);
          teacherL.add(doc["Last Name"]);
          teacherF.add(doc["First Name"]);
          tPhoto.add(doc['Photo']);
        });
      });
    });
  }

  Future buildTeachersList() async {
    await getTeacherNames();
    for (int i = 0; i < teacherID.length; i++) {
      setState(() {
        teachersList.add(DropDownValueModel(
            name: "${teacherID[i]} - ${teacherF[i]}  ${teacherL[i]}",
            value: i));
      });
    }
  }

  Future createClass() async {
    Loading(context);
    String __class =
        '${_className.text} (${_initYear.text} - ${_finalYear.text})';
    var a =
        await FirebaseFirestore.instance.collection('Class').doc(__class).get();
    if (!a.exists) {
      await FirebaseFirestore.instance.collection('Class').doc(__class).set({
        'Class Name': __class,
        'Department': _department.dropDownValue!.value,
        'Joined Year': _initYear.text,
        'Final Year': _finalYear.text,
        'Semester': _semester.dropDownValue!.value,
        'Mentor': _teachers.dropDownValue!.name,
        'Mentor ID': teacherID[_teachers.dropDownValue!.value],
        'Mentor Last Name': teacherL[_teachers.dropDownValue!.value],
        'Mentor First Name': teacherF[_teachers.dropDownValue!.value],
        "Photo":
            "https://firebasestorage.googleapis.com/v0/b/collage-app-f0196.appspot.com/o/grey.png?alt=media&token=2533766b-6ac8-41de-9007-1819fe3c2b17",
        "Students": FieldValue.arrayUnion([""]),
        "Teachers": FieldValue.arrayUnion([""]),
        "Subjects": FieldValue.arrayUnion([""]),
      }).onError((error, _) {
        ErrorSnackBar(context, error.toString());
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection('Class')
            .doc('${_className.text} (${_initYear.text} - ${_finalYear.text})')
            .collection('Teacher')
            .doc(teacherID[_teachers.dropDownValue!.value])
            .set({
          'Teacher ID': teacherID[_teachers.dropDownValue!.value],
          'First Name': teacherF[_teachers.dropDownValue!.value],
          'Last Name': teacherL[_teachers.dropDownValue!.value],
          'Name': teachersList[_teachers.dropDownValue!.value],
          'Photo': tPhoto[_teachers.dropDownValue!.value],
        }).whenComplete(() async {
          await FirebaseFirestore.instance
              .collection('Teacher')
              .doc(teacherID[_teachers.dropDownValue!.value])
              .update({
            'Class': FieldValue.arrayUnion([__class]),
          });
          Navigator.pop(context);
          SimpleSnackBar(context, "Class Created.");
        });
      });
    } else {
      ErrorSnackBar(context,
          "Class is already available with same Name,Joinning Year and Final Year");
    }
  }
}

class UpdateClassDetails extends StatefulWidget {
  const UpdateClassDetails({Key? key}) : super(key: key);

  @override
  State<UpdateClassDetails> createState() => _UpdateClassDetailsState();
}

class _UpdateClassDetailsState extends State<UpdateClassDetails> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _className = TextEditingController();
  final TextEditingController _finalYear = TextEditingController();
  final TextEditingController _initYear = TextEditingController();
  final __className = SingleValueDropDownController();
  final _teachers = SingleValueDropDownController();
  final _department = SingleValueDropDownController();
  final _semester = SingleValueDropDownController();
  bool flag1 = true;
  bool flag2 = false;
  bool flag3 = false;
  String? temp;
  List<String> teacherID = [];
  List<String> teacherF = [];
  List<String> teacherL = [];
  List<DropDownValueModel> teachersList = [];
  List selected_teachers = [];
  List tPhoto = [];
  List<String> classNames = [];
  List<DropDownValueModel> classList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Class Details"),
        actions: [
          NotificationIcon(),
          PopupButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              Visibility(
                visible: flag1 && !flag2,
                child: Column(
                  children: [
                    DropField(context, "Branch", Courses, _department, true),
                    DropField(context, "Semester", Semesters, _semester, true),
                  ],
                ),
              ),
              Visibility(
                visible: !flag1 && !flag2,
                child: DropField(
                    context, "Class Name", classList, __className, true),
              ),
              Visibility(
                visible: !flag1 && flag2,
                child: Column(
                  children: [
                    TFormField(context, "Class Name", _className, false, false),
                    DropField(context, "Branch", Courses, _department, false),
                    DropField(context, "Semester", Semesters, _semester, false),
                    TFormField(
                        context, "Joining Year", _initYear, false, false),
                    TFormField(context, "Final Year", _finalYear, false, false),
                    DropField(
                        context, "Mentor", teachersList, _teachers, flag3),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomSheet: !flag1 && flag2 && !flag3
          ? Delete_Update(context, Delete, Update)
          : BottomSheetButtons(context, _formkey, Next),
    );
  }

  Delete() {
    DeleteAccountPopUp(
        context,
        "Sure Do You want to Delete Class ${_className.text.toString()} ?",
        del);
  }

  Update() {
    setState(() {
      flag3 = !flag3;
    });
  }

  del() async {
    Navigator.pop(context);
    Loading(context);
    await FirebaseFirestore.instance
        .collection('Class')
        .doc(_className.text)
        .delete()
        .whenComplete(() {
      Navigator.pop(context);
      SimpleSnackBar(context, "Class Deleted.");
    });
  }

  Next() async {
    Loading(context);
    if (flag1 == true && flag2 == false) {
      await buildClassList();
      setState(() {
        flag1 = !flag1;
      });
      Navigator.pop(context);
    } else if (flag1 == false && flag2 == false) {
      print(__className.dropDownValue!.value);
      await FirebaseFirestore.instance
          .collection('Class')
          .doc(__className.dropDownValue!.value)
          .get()
          .then((value) {
        _className.text = value["Class Name"];
        _finalYear.text = value["Final Year"];
        _initYear.text = value["Joined Year"];
        temp = value["Mentor"];
        _teachers.setDropDown(
          DropDownValueModel(name: value["Mentor"], value: value["Mentor"]),
        );
      });
      buildTeachersList();
      setState(() {
        flag2 = !flag2;
      });
      Navigator.pop(context);
    } else if (flag1 == false && flag2 == true && flag3 == true) {
      if (temp != _teachers.dropDownValue!.value) {
        var x = _teachers.dropDownValue!.value
            .toString()
            .replaceAll(" ", ":")
            .split(":");
        await FirebaseFirestore.instance
            .collection('Class')
            .doc(_className.text)
            .update({
          "Mentor ID": x[0],
          "Mentor First Name": x[2],
          "Mentor Last Name": x[4],
          "Mentor": _teachers.dropDownValue!.value,
        }).whenComplete(() {
          Navigator.pop(context);
          SimpleSnackBar(context, "Class Details Updated");
        });
      }
    }
  }

  Future getTeacherNames() async {
    await FirebaseFirestore.instance
        .collection('Teacher')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          teacherID.add(doc["ID"]);
          teacherL.add(doc["Last Name"]);
          teacherF.add(doc["First Name"]);
          tPhoto.add(doc['Photo']);
        });
      });
    });
  }

  Future buildTeachersList() async {
    await getTeacherNames();
    for (int i = 0; i < teacherID.length; i++) {
      setState(() {
        teachersList.add(DropDownValueModel(
            name: "${teacherID[i]} - ${teacherF[i]}  ${teacherL[i]}",
            value: "${teacherID[i]} - ${teacherF[i]}  ${teacherL[i]}"));
      });
    }
  }

  Future buildClassList() async {
    await FirebaseFirestore.instance
        .collection('Class')
        .where("Department", isEqualTo: _department.dropDownValue!.value)
        .where("Semester", isEqualTo: _semester.dropDownValue!.value)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          classNames.add(doc["Class Name"]);
        });
      });
    });
    for (int i = 0; i < classNames.length; i++) {
      setState(() {
        classList.add(DropDownValueModel(
            name: "${classNames[i]}", value: "${classNames[i]}"));
      });
    }
  }
}
