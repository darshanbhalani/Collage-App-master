import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Drawer/AdminPanel/UploadViaFile.dart';
import 'package:myapp2/app/util/Functions.dart';
import '../../../../app/util/VariablesFile.dart';

class AddNewStudent extends StatefulWidget {
  const AddNewStudent({Key? key}) : super(key: key);

  @override
  State<AddNewStudent> createState() => _AddNewStudentState();
}

class _AddNewStudentState extends State<AddNewStudent> {
  final _formkey = GlobalKey<FormState>();
  var _id = TextEditingController();
  var _first_name = TextEditingController();
  var _middle_name = TextEditingController();
  var _last_name = TextEditingController();
  var _email = TextEditingController();
  var _phoneno = TextEditingController();
  var _validity = TextEditingController();
  final _branch = SingleValueDropDownController();
  final _class = SingleValueDropDownController();
  final _semester = SingleValueDropDownController();
  final _bloodgroup = SingleValueDropDownController();
  var _joining_year = TextEditingController();
  bool _showprofile = true;
  String lableDate = "";
  String _birthdate = "";
  DateTime? _date;
  List<String> classNames = [];
  List<DropDownValueModel> classList = [];

  @override
  void initState() {
    buildClassList();
    super.initState();
  }

  void dispose() {
    _id.dispose();
    _first_name.dispose();
    _middle_name.dispose();
    _last_name.dispose();
    _bloodgroup.dispose();
    _joining_year.dispose();
    _validity.dispose();
    _class.dispose();
    _branch.dispose();
    _semester.dispose();
    _email.dispose();
    _phoneno.dispose();
    super.dispose();
  }

  void Clear() {
    setState(() {
      _id.clear();
      _first_name.clear();
      _middle_name.clear();
      _last_name.clear();
      _date = null;
      _bloodgroup.setDropDown(null);
      _joining_year.clear();
      _validity.clear();
      _class.setDropDown(null);
      _branch.setDropDown(null);
      _semester.setDropDown(null);
      _email.clear();
      _phoneno.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add New Student"),
          actions: [
            PopupMenuButton(
                position: PopupMenuPosition.under,
                itemBuilder: ((context) {
                  return [
                    PopupMenuItem(
                      child: const Text('Refresh'),
                      onTap: () {
                        setState(() {});
                      },
                    ),
                    PopupMenuItem(
                      child: const Text('Upload via File'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UploadViaFile(),
                            ));
                      },
                    ),
                  ];
                })),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  TFormField(context, "Student ID", _id, true, false),
                  TFormField(context, "First Name", _first_name, true, false),
                  TFormField(context, "Middle Name", _middle_name, true, false),
                  TFormField(context, "Last Name", _last_name, true, false),
                  DateField(context, "Birth Date", _birthdate, 2000, 2025),
                  DropField(
                      context, "Blood Group", BloodGroups, _bloodgroup, true),
                  TFormField(
                      context, "Joining Year", _joining_year, true, false),
                  TFormField(context, "Validity", _validity, true, false),
                  DropField(context, "Class", classList, _class, true),
                  DropField(context, "Branch", Courses, _branch, true),
                  DropField(context, "Semester", Semesters, _semester, true),
                  TFormField(context, "Email ID", _email, true, false),
                  TFormField(context, "Phone No", _phoneno, true, false),
                  SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ButtonField(
              context, "Clear", Clear, "Submit", SubmitDetails, _formkey),
        ));
  }

  Future SubmitDetails() async {
    Loading(context);
    var a = await FirebaseFirestore.instance
        .collection('Student')
        .doc(_id.text.toString().toUpperCase())
        .get();
    if (!a.exists) {
      String x = "";
      String y = "";
      await FirebaseFirestore.instance
          .collection('Class')
          .doc(_class.dropDownValue!.value)
          .get()
          .then((value) {
        x = value["Department"];
        y = value["Semester"];
      });
      final z =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(_email.text);
      if (x == _branch.dropDownValue!.value &&
          y == _semester.dropDownValue!.value) {
        if (z.isEmpty) {
          await signUp(context, _email.text).whenComplete(() async {
            await FirebaseFirestore.instance
                .collection('Student')
                .doc(_id.text.toString().toUpperCase())
                .set({
              "Photo":
                  "https://firebasestorage.googleapis.com/v0/b/flutter-classroom-48dd1.appspot.com/o/images%2Fdefault%2Fprofile.png?alt=media&token=91a6a65f-2732-4256-861f-e9642a0f2cd7",
              "Show Profile": _showprofile,
              "ID": _id.text.toString().toUpperCase(),
              "First Name": _first_name.text.toUpperCase(),
              "Middle Name": _middle_name.text.toUpperCase(),
              "Last Name": _last_name.text.toUpperCase(),
              "Email Id": _email.text,
              "Phone No": _phoneno.text,
              "Joining Year": _joining_year.text,
              "Validity": _validity.text,
              "Branch": _branch.dropDownValue!.value,
              "Class": _class.dropDownValue!.value,
              "Semester": _semester.dropDownValue!.value,
              "Birth Date": _birthdate,
              "Blood Group": _bloodgroup.dropDownValue!.value,
              "Year": ""
            }).whenComplete(() async {
              await FirebaseFirestore.instance
                  .collection('Class')
                  .doc(_class.dropDownValue!.value)
                  .update({
                'Students': FieldValue.arrayUnion(
                    ["${_id.text.toString().toUpperCase()}"]),
              }).onError((error, _) {
                ErrorSnackBar(context, error.toString());
              });
              Navigator.pop(context);
              SimpleSnackBar(context, "New Student Created.");
            });
          });
        } else {
          ErrorSnackBar(context, "Email is already in use.");
        }
      } else {
        ErrorSnackBar(context,
            "Select appropriate class according students branch and semester.");
      }
    } else {
      ErrorSnackBar(context, "Student Id already assigned.");
    }
  }

  DateField(context, String _label, String _controller, int _start, int _end) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            _date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(_start),
              lastDate: DateTime.now(),
            );
            setState(() {
              lableDate = DateTimeFormat.format(_date!,
                  format: AmericanDateFormats.dayOfWeek);
              _birthdate = lableDate;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey)),
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _date != null ? Text(lableDate) : Text("Birth Date")
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }

  Future buildClassList() async {
    await FirebaseFirestore.instance
        .collection('Class')
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

class UpdateStudentDetails extends StatefulWidget {
  const UpdateStudentDetails({Key? key}) : super(key: key);

  @override
  State<UpdateStudentDetails> createState() => _UpdateStudentDetailsState();
}

class _UpdateStudentDetailsState extends State<UpdateStudentDetails> {
  final _formkey = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _fname = TextEditingController();
  final _mname = TextEditingController();
  final _lname = TextEditingController();
  final _bloodgroup = SingleValueDropDownController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _joiningyear = TextEditingController();
  final _branch = SingleValueDropDownController();
  final _class = SingleValueDropDownController();
  final _semester = SingleValueDropDownController();
  final _validity = TextEditingController();
  bool flag1 = true;
  bool flag2 = false;
  bool flag3 = true;
  String lableDate = "";
  String _birthdate = "";
  DateTime? _date;
  String? __class;
  List<String> classNames = [];
  List<DropDownValueModel> classList = [];

  @override
  void initState() {
    buildClassList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: flag1
            ? Text("Search Student")
            : Text("Student : ${_id.text.toString().toUpperCase()}"),

      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              Visibility(
                  visible: flag1,
                  child: TFormField(context, "Student ID", _id, true, false)),
              Visibility(
                visible: !flag1,
                child: Column(
                  children: [
                    TFormField(context, "First Name", _fname, flag2, false),
                    TFormField(context, "Middle Name", _mname, flag2, false),
                    TFormField(context, "Last Name", _lname, flag2, false),
                    // DateField(context, "Birth Date", _birthdate, 2000),
                    DropField(context, "Blood Group", BloodGroups, _bloodgroup,
                        flag2),
                    TFormField(
                        context, "Joining Year", _joiningyear, flag2, false),
                    TFormField(context, "Validity", _validity, flag2, false),
                    DropField(context, "Class", classList, _class, flag2),
                    DropField(context, "Branch", Courses, _branch, flag2),
                    DropField(context, "Semester", Semesters, _semester, flag2),
                    TFormField(context, "Email ID", _email, flag2, false),
                    TFormField(context, "Phone No", _phone, flag2, false),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: !flag3
          ? Delete_Update(context, Delete, Update)
          : BottomSheetButtons(context, _formkey, Next),
    );
  }

  Delete() {
    DeleteAccountPopUp(
        context,
        "Sure Do You want to Delete Student with ID : ${_id.text.toString().toUpperCase()} ?",
        del);
  }

  del() async {
    Navigator.pop(context);
    Loading(context);
    await FirebaseFirestore.instance
        .collection("Class")
        .doc(_class.dropDownValue!.value)
        .update({
      'Students':
          FieldValue.arrayRemove(["${_id.text.toString().toUpperCase()}"]),
    });
    await FirebaseFirestore.instance
        .collection("Student")
        .doc(_id.text.toString().toUpperCase())
        .delete();
    // App app = FirebaseAdmin.instance.initializeApp(AppOptions(credential: FirebaseAdmin.instance.certificates.credentials));
    // FirebaseAuth auth = FirebaseAuth.fromApp(app);
    // UserRecord userRecord = await auth.getUserByEmail(email);
    // await auth.deleteUser(userRecord.uid);
    Navigator.pop(context);
    SimpleSnackBar(context, "Account Deleted.");
  }

  Update() {
    setState(() {
      flag2 = !flag2;
      flag3 = !flag3;
    });
  }

  Future Next() async {
    Loading(context);
    if (flag1) {
      String temp = _id.text.toString().toUpperCase();
      var a = await FirebaseFirestore.instance
          .collection("Student")
          .doc(temp)
          .get();
      if (a.exists) {
        await FirebaseFirestore.instance
            .collection('Student')
            .doc(temp)
            .get()
            .then((snap) {
          _id.text = snap["ID"];
          _fname.text = snap["First Name"];
          _mname.text = snap["Middle Name"];
          // _birthdate = snap["Birth Date"];
          _lname.text = snap["Last Name"];
          // _date=DateFormat("MMMM d, y",).parse(snap["Birth Date"]);
          _bloodgroup.setDropDown(
            DropDownValueModel(
                name: snap["Blood Group"], value: snap["Blood Group"]),
          );
          _email.text = snap["Email Id"];
          _phone.text = snap["Phone No"];
          _joiningyear.text = snap["Joining Year"];
          __class = snap["Class"];
          _class.setDropDown(
            DropDownValueModel(name: snap["Class"], value: snap["Class"]),
          );
          _branch.setDropDown(
            DropDownValueModel(name: snap["Branch"], value: snap["Branch"]),
          );
          _semester.setDropDown(
            DropDownValueModel(name: snap["Semester"], value: snap["Semester"]),
          );
          _validity.text = snap["Validity"];
        }).whenComplete(() {
          Navigator.pop(context);

          setState(() {
            flag1 = !flag1;
            flag3 = !flag3;
          });
        });
      } else {
        Navigator.of(context).pop();

        ErrorSnackBar(context, "Oops ! Student not found.");
      }
    } else {
      await FirebaseFirestore.instance
          .collection('Student')
          .doc(_id.text)
          .update({
        "First Name": _fname.text,
        "Middle Name": _mname.text,
        "Last Name": _lname.text,
        "Email Id": _email.text,
        "Phone No": _phone.text,
        "Joining Year": _joiningyear.text,
        "Validity": _validity.text,
        "Branch": _branch.dropDownValue!.value,
        "Class": _class.dropDownValue!.value,
        "Semester": _semester.dropDownValue!.value,
        "Blood Group": _bloodgroup.dropDownValue!.value,
      }).whenComplete(() async {
        if (__class != _class.dropDownValue!.value) {
          await FirebaseFirestore.instance
              .collection('Class')
              .doc(__class)
              .update({
            'Students': FieldValue.arrayRemove(["${_id.text}"]),
          });
          await FirebaseFirestore.instance
              .collection('Class')
              .doc(_class.dropDownValue!.value)
              .update({
            'Students': FieldValue.arrayUnion(["${_id.text}"]),
          }).whenComplete(() {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Student Details Updated')),
            );
          });
        } else {
          Navigator.pop(context);
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Student Details Updated')),
          );

        }
      });
    }
  }

  Box(context, _flag, IconData _icon, _lable, _function) {
    return Visibility(
      visible: _flag,
      child: InkWell(
        onTap: () {},
        child: Container(
          height: 50,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).primaryColor,
          ),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(_icon),
              SizedBox(
                width: 10,
              ),
              Text(
                _lable,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ],
          )),
        ),
      ),
    );
  }

  Future buildClassList() async {
    await FirebaseFirestore.instance
        .collection('Class')
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

  DateField(context, String _label, String _controller, int _start) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            _date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(_start),
              lastDate: DateTime.now(),
            );
            setState(() {
              lableDate = DateTimeFormat.format(_date!,
                  format: AmericanDateFormats.dayOfWeek);
              _birthdate = lableDate;
            });
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey)),
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _date != null ? Text(lableDate) : Text("Birth Date")
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }
}
