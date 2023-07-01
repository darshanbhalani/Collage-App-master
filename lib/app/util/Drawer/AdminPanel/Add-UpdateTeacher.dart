import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../app/util/NotificationIcon.dart';
import '../../../../app/util/PopupButton.dart';
import '../../../../app/util/VariablesFile.dart';
import 'package:myapp2/app/util/Functions.dart';

class AddNewTeacher extends StatefulWidget {
  const AddNewTeacher({Key? key}) : super(key: key);

  @override
  State<AddNewTeacher> createState() => _AddNewTeacherState();
}

class _AddNewTeacherState extends State<AddNewTeacher> {
  final _formkey = GlobalKey<FormState>();
  var _id = TextEditingController();
  var _first_name = TextEditingController();
  var _middle_name = TextEditingController();
  var _last_name = TextEditingController();
  var _phoneno = TextEditingController();
  var _email = TextEditingController();
  var _joining_year = TextEditingController();
  final _department = SingleValueDropDownController();
  final _bloodgroup = SingleValueDropDownController();
  final _branch = SingleValueDropDownController();
  bool _showprofile = true;
  String lableDate = "";
  String _birthdate = "";
  DateTime? _date;

  void dispose() {
    _first_name.dispose();
    _middle_name.dispose();
    _last_name.dispose();
    _email.dispose();
    super.dispose();
  }

  void Clear() {
    setState(() {
      _id.clear();
      _first_name.clear();
      _middle_name.clear();
      _last_name.clear();
      _bloodgroup.setDropDown(null);
      _joining_year.clear();
      _date = null;
      _branch.setDropDown(null);
      _email.clear();
      _phoneno.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add New Teacher Details"),
          actions: [
            NotificationIcon(),
            PopupButton(),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Form(
              key: _formkey,
              child: Column(
                children: [
                  TFormField(context, "Teacher ID", _id, true, false),
                  TFormField(context, "First Name", _first_name, true, false),
                  TFormField(context, "Middle Name", _middle_name, true, false),
                  TFormField(context, "Last Name", _last_name, true, false),
                  DateField(context, "Birth Date", _birthdate, 1950, 2025),
                  DropField(
                      context, "Blood Group", BloodGroups, _bloodgroup, true),
                  TFormField(
                      context, "Joining Year", _joining_year, true, false),
                  DropField(context, "Department", Courses, _department, true),
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

  DateField(context, String _label, String _controller, int _start, int _end) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            _date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(_start),
              lastDate: DateTime(_end),
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

  Future SubmitDetails() async {
    String __id = _id.text.toString().toUpperCase();
    Loading(context);
    var a =
        await FirebaseFirestore.instance.collection('Teacher').doc(__id).get();
    if (!a.exists) {
      final z = await FirebaseAuth.instance
          .fetchSignInMethodsForEmail(_email.text.trim());
      if (z.isEmpty) {
        signUp(context, _email.text.trim()).whenComplete(() async {
          await FirebaseFirestore.instance.collection('Teacher').doc(__id).set({
            "Photo":
                "https://firebasestorage.googleapis.com/v0/b/flutter-classroom-48dd1.appspot.com/o/images%2Fdefault%2Fprofile.png?alt=media&token=91a6a65f-2732-4256-861f-e9642a0f2cd7",
            "Show Profile": _showprofile,
            "ID": __id,
            "First Name": _first_name.text.toUpperCase(),
            "Middle Name": _middle_name.text.toUpperCase(),
            "Last Name": _last_name.text.toUpperCase(),
            "Email Id": _email.text,
            "Phone No": _phoneno.text,
            "Joining Year": _joining_year.text,
            "Department": _department.dropDownValue!.value,
            "Status": "Lecturer",
            "Birth Date": _birthdate,
            "Blood Group": _bloodgroup.dropDownValue!.value,
          });
          Navigator.pop(context);
          SimpleSnackBar(context, "New Teacher Created.");
        });
      } else {
        ErrorSnackBar(context, "Email is already in use.");
      }
    } else {
      ErrorSnackBar(context, "Teacher Id already assigned.");
    }
  }
}

class UpdateTeacherDetails extends StatefulWidget {
  const UpdateTeacherDetails({Key? key}) : super(key: key);

  @override
  State<UpdateTeacherDetails> createState() => _UpdateTeacherDetailsState();
}

class _UpdateTeacherDetailsState extends State<UpdateTeacherDetails> {
  final _formkey = GlobalKey<FormState>();
  var _id = TextEditingController();
  var _fname = TextEditingController();
  var _mname = TextEditingController();
  var _lname = TextEditingController();
  var _phone = TextEditingController();
  var _email = TextEditingController();
  var _joiningyear = TextEditingController();
  final _department = SingleValueDropDownController();
  final _bloodgroup = SingleValueDropDownController();
  String lableDate = "";
  DateTime? _date;
  bool flag1 = true;
  bool flag2 = false;
  bool flag3 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: flag1
            ? Text("Search Teacher")
            : Text("Teacher : ${_id.text.toString().toUpperCase()}"),
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
                  visible: flag1,
                  child: TFormField(context, "Teacher ID", _id, true, false)),
              Visibility(
                visible: !flag1,
                child: Column(
                  children: [
                    TFormField(context, "First Name", _fname, flag2, false),
                    TFormField(context, "Middle Name", _mname, flag2, false),
                    TFormField(context, "Last Name", _lname, flag2, false),
                    DropField(context, "Blood Group", BloodGroups, _bloodgroup,
                        flag2),
                    TFormField(
                        context, "Joining Year", _joiningyear, flag2, false),
                    DropField(
                        context, "Department", Courses, _department, flag2),
                    TFormField(context, "Email ID", _email, flag2, false),
                    TFormField(context, "Phone No", _phone, flag2, false),
                  ],
                ),
              )
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
        "Sure Do You want to Delete Teacher with ID : ${_id.text.toString().toUpperCase()} ?",
        del);
  }

  del() async {
    Navigator.pop(context);
    Loading(context);
    String __id = _id.text.toString().toUpperCase();
    List<String> classNames1 = [];
    List<String> classNames2 = [];
    await FirebaseFirestore.instance
        .collection('Class')
        .where("Mentor ID", isEqualTo: __id)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          classNames1.add(doc["Class Name"]);
        });
      });
    }).whenComplete(() async {
      for (int i = 0; i < classNames1.length; i++) {
        await FirebaseFirestore.instance
            .collection("Class")
            .doc(classNames1[i])
            .update({
          "Mentor ID": null,
          "Mentor": null,
          "Mentor First Name": null,
          "Mentor Last Name": null,
        });
      }
    });
    await FirebaseFirestore.instance
        .collection('Class')
        .where("Teachers", arrayContains: __id)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          classNames2.add(doc["Class Name"]);
        });
      });
    }).whenComplete(() async {
      for (int i = 0; i < classNames2.length; i++) {
        await FirebaseFirestore.instance
            .collection("Class")
            .doc(classNames2[i])
            .update({
          'Teachers': FieldValue.arrayRemove([__id]),
        });
      }
    });

    await FirebaseFirestore.instance.collection("Teacher").doc(__id).delete();
    Navigator.pop(context);
    SimpleSnackBar(context, "Teacher Deleted.");
  }

  Update() {
    setState(() {
      flag2 = !flag2;
      flag3 = !flag3;
    });
  }

  Next() async {
    if (flag1) {
      String temp = _id.text.toString().toUpperCase();
      Loading(context);
      var a = await FirebaseFirestore.instance
          .collection("Teacher")
          .doc(temp)
          .get();
      if (a.exists) {
        await FirebaseFirestore.instance
            .collection('Teacher')
            .doc(temp)
            .get()
            .then((snap) {
          _id.text = snap["ID"];
          _fname.text = snap["First Name"];
          _mname.text = snap["Middle Name"];
          _lname.text = snap["Last Name"];
          // _date=DateFormat("MMMM d, y",).parse(snap["Birth Date"]);
          _bloodgroup.setDropDown(
            DropDownValueModel(
                name: snap["Blood Group"], value: snap["Blood Group"]),
          );
          _email.text = snap["Email Id"];
          _phone.text = snap["Phone No"];
          _joiningyear.text = snap["Joining Year"];
          _department.setDropDown(
            DropDownValueModel(
                name: snap["Department"], value: snap["Department"]),
          );
        }).whenComplete(() {
          setState(() {
            flag1 = !flag1;
            flag3 = !flag3;
          });
          Navigator.pop(context);
        });
      } else {
        ErrorSnackBar(context, 'Oops! Teacher not found');
      }
    } else {
      Loading(context);
      await FirebaseFirestore.instance
          .collection('Teacher')
          .doc(_id.text)
          .update({
        "First Name": _fname.text,
        "Middle Name": _mname.text,
        "Last Name": _lname.text,
        "Email Id": _email.text,
        "Phone No": _phone.text,
        "Joining Year": _joiningyear.text,
        "Department": _department.dropDownValue!.value,
        "Blood Group": _bloodgroup.dropDownValue!.value,
      }).whenComplete(() async {
        Navigator.pop(context);
        SimpleSnackBar(context, 'Teacher Details Updated');
      });
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
              lastDate: DateTime(_end),
            );
            setState(() {
              lableDate = DateTimeFormat.format(_date!,
                  format: AmericanDateFormats.dayOfWeek);
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
