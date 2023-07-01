import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Request/HandleRequest.dart';
import 'package:random_password_generator/random_password_generator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Login/LoginChoisePage.dart';
import 'VariablesFile.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

Future getDetails(String collection, String id) async {
  await FirebaseFirestore.instance
      .collection(collection)
      .doc(id)
      .get()
      .then((value) {
    cuPhoto = value["Photo"];
    cuFirstName = value["First Name"];
    cuMiddleName = value["Middle Name"];
    cuLastName = value["Last Name"];
    cuBirthDate = value["Birth Date"];
    cuBloodGroup = value["Blood Group"];
    cuJoiningYear = value["Joining Year"];
    cuPhoneNo = value["Phone No"];
    cuEmail = value["Email Id"];

    if (cuType == "Student") {
      cuBranch = value["Branch"];
      cuClass = value["Class"];
      cuSemester = value["Semester"];
      cuValidity = value["Validity"];
    } else if (cuType == "Teacher") {
      cuDeparttment = value["Department"];
    }
  });
  cuName = "${cuFirstName} ${cuMiddleName} ${cuLastName}";
}

Future setDetails() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setString("cuId", cuId);
  sp.setString("cuType", cuType);
  sp.setString("cuPhoto", cuPhoto);
  sp.setString("cuFirstName", cuFirstName);
  sp.setString("cuMiddleName", cuMiddleName);
  sp.setString("cuLastName", cuLastName);
  sp.setString("cuName", cuName);
  sp.setString("cuBirthDate", cuBirthDate);
  sp.setString("cuBloodGroup", cuBloodGroup);
  sp.setString("cuJoiningYear", cuJoiningYear);
  sp.setString("cuEmail", cuEmail);
  sp.setString("cuPhoneNo", cuPhoneNo);
  if (cuType == "Student") {
    sp.setString("cuBranch", cuBranch);
    sp.setString("cuClass", cuClass);
    sp.setString("cuSemester", cuSemester);
    sp.setString("cuValidity", cuValidity);
  }
  if (cuType == "Teacher") {
    sp.setString("cuDeparttment", cuDeparttment);
  }
}

Future getLocalDetails() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  cuType = sp.getString("cuType") ?? cuType;
  cuId = sp.getString("cuId") ?? cuId;

  cuPhoto = sp.getString("cuPhoto") ?? cuPhoto;
  cuFirstName = sp.getString("cuFirstName") ?? cuFirstName;
  cuMiddleName = sp.getString("cuMiddleName") ?? cuMiddleName;
  cuLastName = sp.getString("cuLastName") ?? cuLastName;
  cuName = sp.getString("cuName") ?? cuName;
  cuBirthDate = sp.getString("cuBirthDate") ?? cuBirthDate;
  cuClass = sp.getString("cuBloodGroup") ?? cuBloodGroup;
  cuClass = sp.getString("cuJoiningYear") ?? cuJoiningYear;
  cuEmail = sp.getString("cuEmail") ?? cuEmail;
  cuPhoneNo = sp.getString("cuPhoneNo") ?? cuPhoneNo;
  if (cuType == "Student") {
    cuBranch = sp.getString("cuBranch") ?? cuBranch;
    cuClass = sp.getString("cuClass") ?? cuClass;
    cuClass = sp.getString("cuSemester") ?? cuSemester;
    cuDeparttment = sp.getString("cuValidity") ?? cuValidity;
  }
  if (cuType == "Teacher") {
    cuDeparttment = sp.getString("cuDeparttment") ?? cuDeparttment;
  }
}

Future removeLocalDetails() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  await sp.remove("cuId");
  await sp.remove("cuType");
  await sp.remove("cuPhoto");
  await sp.remove("cuFirstName");
  await sp.remove("cuMiddleName");
  await sp.remove("cuLastName");
  await sp.remove("cuName");
  await sp.remove("cuBirthDate");
  await sp.remove("cuBloodGroup");
  await sp.remove("cuJoiningYear");
  await sp.remove("cuEmail");
  await sp.remove("cuPhoneNo");
  await sp.remove("cuClass");
  await sp.remove("cuBranch");
  await sp.remove("cuSemester");
  await sp.remove("cuValidity");
  await sp.remove("cuDeparttment");
}

TFormField(context, String _lable, TextEditingController _controller,
    bool _condition, bool _flag) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      TextFormField(
        obscureText: _flag,
        enabled: _condition,
        validator: (value) {
          if (value!.isEmpty) {
            return "Enter $_lable";
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
          labelText: _lable,
          labelStyle: TextStyle(
            fontSize: 15,
          ),
        ),
      ),
      SizedBox(height: 15),
    ],
  );
}

DropField(context, String _lable, List<DropDownValueModel> _items,
    SingleValueDropDownController _controller, bool _condition) {
  return Column(
    children: [
      DropDownTextField(
        isEnabled: _condition,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select an option';
          }
          return null;
        },
        controller: _controller,
        dropDownItemCount: 5,
        dropDownList: _items,
        dropdownRadius: 0,
        textFieldDecoration: InputDecoration(
          labelText: _lable,
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Theme.of(context).primaryColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
      SizedBox(height: 15),
    ],
  );
}

ButtonField(
    context,
    String _left_button_label,
    Function _left_function,
    String _right_button_label,
    Function _right_function,
    GlobalKey<FormState> _key) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      InkWell(
        onTap: () async {
          _left_function();
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
            _left_button_label,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          )),
        ),
      ),
      InkWell(
        onTap: () async {
          if (_key.currentState!.validate()) {
            await _right_function();
          }
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
            _right_button_label,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    ],
  );
}

ShowField(String _lable, String _value, bool _flag) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(_lable,
          style: TextStyle(
            fontSize: 15,
          )),
      SizedBox(
        height: 5,
      ),
      TextFormField(
        enabled: _flag,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.teal,
          )),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
            color: Colors.orange,
            width: 3,
          )),
          labelText: _value,
          labelStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      SizedBox(
        height: 20,
      ),
    ],
  );
}

BottomSheetButtons(context, _formkey, Function _nextfunction) {
  return Container(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () async {
              Navigator.pop(context);
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
                "Cancle",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              )),
            ),
          ),
          InkWell(
            onTap: () async {
              final FormState? form = _formkey.currentState;
              if (form!.validate()) {
                _nextfunction();
              }
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
                "Next",
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
  );
}

ListField(context, _leading, _title, _nextpage) {
  return InkWell(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => _nextpage,
          ));
    },
    child: ListTile(
      leading: _leading,
      title: Text(_title),
      trailing: Icon(
        Icons.chevron_right,
      ),
    ),
  );
}

CardField(context, String _lable, IconData _icon, _nextpage) {
  return InkWell(
    onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => _nextpage));
    },
    child: Card(
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            _icon,
            size: 35,
          ),
          Text(_lable),
        ],
      ),
    ),
  );
}

Change_Password(context, String _currentpassword, String _newpassword1,
    String _newpassword2) async {
  showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      });
  if (_newpassword1 == _newpassword2 && _currentpassword != _newpassword1) {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: cuEmail, password: _currentpassword);
      await FirebaseAuth.instance.currentUser!
          .updatePassword(_newpassword1)
          .then((_) {
        Navigator.pop(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password successfully changed")),
        );
      }).catchError((error) {
        Navigator.pop(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Password can't be changed" + error.toString())),
        );
      });
      Navigator.pop(context);
    } on FirebaseException catch (error) {
      Navigator.pop(context);
      if (error.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Oops! Wrong Password")),
        );
      }
    }
  } else if (_newpassword1 != _newpassword2) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Oops! Password do not match")),
    );
  } else if (_currentpassword == _newpassword1 ||
      _currentpassword == _newpassword2) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text("Oops! Current Password and New Password both are Same")),
    );
  }
}

Change_Email(context, String _currentpassword, String _newemail1,
    String _newemail2) async {
  showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      });
  if (_newemail1 == _newemail2 && cuEmail != _newemail1) {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: cuEmail, password: _currentpassword);
      await FirebaseAuth.instance.currentUser!
          .updateEmail(_newemail1)
          .then((_) async {
        cuEmail = _newemail1;
        // SharedPreferences sp = await SharedPreferences.getInstance();
        await FirebaseFirestore.instance.collection(cuType).doc(cuId).update({
          "Email Id": _newemail1,
        }).onError((error, _) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error : $error')),
          );
        });
        // sp.setString("cuEmail", cuEmail);
        Navigator.pop(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email successfully changed")),
        );
      }).catchError((error) {
        Navigator.pop(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email can't be changed" + error.toString())),
        );
      });
      Navigator.pop(context);
    } on FirebaseException catch (error) {
      Navigator.pop(context);
      if (error.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Oops! Wrong Password")),
        );
      }
    }
  } else if (_newemail1 != _newemail2) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Oops! Email do not match")),
    );
  } else if (cuEmail == _newemail1 || cuEmail == _newemail2) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("Oops! Current Email and New Email both are Same")),
    );
  }
}

Change_Phoneno(context, String _currentpassword, String _newphone1,
    String _newphone2) async {
  showDialog(
      context: context,
      builder: (context) {
        return Center(child: CircularProgressIndicator());
      });
  if (_newphone1 == _newphone2 && cuPhoneNo != _newphone1) {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: cuEmail, password: _currentpassword);
      await FirebaseFirestore.instance.collection(cuType).doc(cuId).update({
        "Phone No": _newphone1,
      }).onError((error, _) {
        Navigator.pop(context);
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error : $error')),
        );
      });
      cuPhoneNo = _newphone1;
      // SharedPreferences sp = await SharedPreferences.getInstance();
      // sp.setString("cuPhoneNo", cuPhoneNo);
      Navigator.pop(context);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Phone Number successfully changed")),
      );
    } on FirebaseException catch (error) {
      Navigator.pop(context);
      if (error.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Oops! Wrong Password")),
        );
      }
    }
  } else if (_newphone1 != _newphone2) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Oops! Phone Number do not match")),
    );
  } else if (cuPhoneNo == _newphone1 || cuPhoneNo == _newphone2) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
              "Oops! Current Phone Number and New Phone Number both are Same")),
    );
  }
}

logout(context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout,
                size: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  "Sign Out",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              )
            ],
          ),
          content: Text(
            "Do You want to Sign Out ?",
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("No")),
            TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().then((value) async {
                    await removeLocalDetails().whenComplete(() {
                      Navigator.popUntil(context, (route) => false);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginChoisePage()));
                    });
                  });
                },
                child: Text("Yes")),
          ],
        );
      });
}

Loading(context) {
  return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Container(child: Center(child: CircularProgressIndicator()));
      });
}

RequestToAdmin() {
  return Scaffold(
    appBar: AppBar(
      title: Text("Request to Admin"),
    ),
    body: Center(
        child: Text(
      "Comming Soon...",
      style: TextStyle(fontSize: 30),
    )),
  );
}

ErrorSnackBar(context, String _lable) {
  Navigator.pop(context);
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error : $_lable')),
  );
}

SimpleSnackBar(context, String _lable) {
  Navigator.pop(context);
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(_lable)),
  );
}

Future signUp(context, _email) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
          email: _email.trim(),
          password: getRandomString(),
        )
        .whenComplete(() => passwordReset(context, _email));
  } on FirebaseException catch (e) {
    SimpleSnackBar(context, e.message ?? 'Something Went Wrong');
  }
}

String getRandomString() {
  final RandomPasswordGenerator randomPassword = RandomPasswordGenerator();
  String newPassword = randomPassword.randomPassword(
    passwordLength: 10,
    specialChar: false,
    letters: true,
    numbers: true,
    uppercase: false,
  );
  return newPassword;
}

Future passwordReset(context, _email) async {
  await FirebaseAuth.instance
      .sendPasswordResetEmail(
    email: _email.trim(),
  )
      .onError((error, _) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error : $error')),
    );
  });
}

Delete_Update(context, Function _delete, Function _update) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        InkWell(
          onTap: () async {
            _delete();
          },
          child: Container(
            height: 50,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).primaryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.delete),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Delete",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            _update();
          },
          child: Container(
            height: 50,
            width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).primaryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.edit),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Update",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

DeleteAccountPopUp(context, String _lable, Function _function) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete,
                  size: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    "Delete",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                )
              ],
            ),
            content: Text(_lable),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("No")),
              TextButton(
                  onPressed: () {
                    _function();
                  },
                  child: Text("Yes")),
            ]);
      });
}

Future SubmitRequest(context,String _title, String _purpose) async {
  Loading(context);
  var request_time = DateTime.now();
  await FirebaseFirestore.instance
      .collection("Pending Request")
      .doc("${cuId}-${cuName}-${request_time}")
      .set({
    "Doc": "${cuId}-${cuName}-${request_time}",
    "Title": _title,
    "Purpose": _purpose,
    "ID": cuId,
    "Name": cuName,
    "Branch": cuType == "Student" ? cuBranch : cuDeparttment,
    "Class": cuType == "Student" ? cuClass : "Na",
    "Semester": cuType == "Student" ? cuSemester : "Na",
    "Request Time": request_time,
    "Type": cuType,
    "Flag": true,
  }).whenComplete((){
    Navigator.pop(context);
    Navigator.pop(context);
  });
}

RequestTab(String _lable, String _type) {
  int index = 0;
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection(_lable)
        .where("Type", isEqualTo: _type)
        //     .orderBy("Request Time", descending: false)
        .snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (!snapshot.hasData) {
        return Center(
          // child: CircularProgressIndicator(),
          child: Text("No Data"),
        );
      } else {
        index = 0;
      }
      return ListView(
        children: snapshot.data!.docs.map((snap) {
          index = index + 1;
          return ListTile(
            onTap: () {
              bool flag = false;
              if (cuType == "Admin" && _lable == "Pending Request") {
                flag = true;
              }
              if (_lable == "Pending Request") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HandleRequest(
                        handle: flag,
                        flag1: "Student",
                        flag2: _lable,
                        doc: snap["Doc"],
                        id: snap["ID"],
                        name: snap["Name"],
                        branch: snap["Branch"],
                        cls: snap["Class"],
                        semester: snap["Semester"],
                        title: snap["Title"],
                        purpose: snap["Purpose"],
                        requesttime: snap["Request Time"],
                        type: snap["Type"],
                        flag: snap["Flag"],
                        feedback: "Na",
                        approvedby: "Na",
                        rejectedby: "Na",
                        approvedtime: "Na",
                        rejectedtime: "Na",
                      ),
                    ));
              } else if (_lable == "Approved Request") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HandleRequest(
                        handle: flag,
                        flag1: "Student",
                        flag2: _lable,
                        doc: snap["Doc"],
                        id: snap["ID"],
                        name: snap["Name"],
                        branch: snap["Branch"],
                        cls: snap["Class"],
                        semester: snap["Semester"],
                        title: snap["Title"],
                        purpose: snap["Purpose"],
                        requesttime: snap["Request Time"],
                        type: snap["Type"],
                        flag: snap["Flag"],
                        feedback: "Na",
                        approvedby: snap["Approved By"],
                        rejectedby: "Na",
                        approvedtime: snap["Approved Time"].toString(),
                        rejectedtime: "Na",
                      ),
                    ));
              } else if (_lable == "Rejected Request") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HandleRequest(
                        handle: flag,
                        flag1: "Student",
                        flag2: _lable,
                        doc: snap["Doc"],
                        id: snap["ID"],
                        name: snap["Name"],
                        branch: snap["Branch"],
                        cls: snap["Class"],
                        semester: snap["Semester"],
                        title: snap["Title"],
                        purpose: snap["Purpose"],
                        requesttime: snap["Request Time"],
                        type: snap["Type"],
                        flag: snap["Flag"],
                        feedback: "Na",
                        approvedby: "Na",
                        rejectedby: snap["Rejected By"],
                        approvedtime: "Na",
                        rejectedtime: snap["Rejected Time"].toString(),
                      ),
                    ));
              }
            },
            leading: Text(index.toString()),
            title: cuType == "Admin"
                ? Text("${snap["ID"]}")
                : Text(snap["Title"].toString()),
            subtitle: cuType == "Admin"
                ? Text(snap["Title"].toString())
                : Text(
                    snap["Purpose"],
                    maxLines: 1,
                  ),
            // trailing: Icon(Icons.circle,color: Colors.green,size: 10,),
          );
        }).toList(),
      );
    },
  );
}

OnClick(
    context,
    String _type,
    String _id,
    String _name,
    String _photo,
    String _email,
    String _phone,
    String _birthdate,
    String _bloodgroup,
    String _joiningyear,
    String _department,
    String _semester,
    String _class,
    String _validity) {
  return showDialog(
      context: context,
      builder: (context) {
        var width = MediaQuery.of(context).size.width;
        return Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.65,
            width: width > 480 ? 450 : MediaQuery.of(context).size.width * 0.9,
            child: Container(
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(_photo),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            child: Flexible(
                              child: Column(
                                children: [
                                  Text(
                                    _name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        thickness: 3,
                      ),
                      setData("ID", _id),
                      setData("Email", _email),
                      setData("Phone No", _phone),
                      setData("Birth Date", _birthdate),
                      setData("Blood Group", _bloodgroup),
                      setData("Joining Year", _joiningyear),
                      Visibility(
                        visible: _type == "Teacher",
                        child: setData("Department", _department),
                      ),
                      Visibility(
                        visible: _type == "Student",
                        child: Column(
                          children: [
                            setData("Class", _class),
                            setData("Branch", _department),
                            setData("Semester", _semester),
                            setData("Validity", _validity),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
}

setData(_lable, _value) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
    child: Column(
      children: [
        Row(
          children: [
            Text(
              "${_lable} : ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            Container(
              child: Flexible(
                child: Column(
                  children: [
                    Text(
                      _value,
                      style: TextStyle(fontSize: 17),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Divider(
          thickness: 2,
        ),
      ],
    ),
  );
}

ListBoxInitial(String _type){
  return Expanded(
    child: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(_type)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data!.docs.map((snap) {
            return InkWell(
                onTap: () async {
                  if (!snap["Show Profile"]) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              "User don't allow to show details")),
                    );
                  } else {
                    if(_type=="Teacher"){
                      OnClick(
                          context,
                          _type,
                          snap["ID"],
                          "${snap['First Name']} ${snap['Middle Name']} ${snap['Last Name']}",
                          snap["Photo"],
                          snap["Email Id"],
                          snap["Phone No"],
                          snap["Birth Date"],
                          snap["Blood Group"],
                          snap["Joining Year"],
                          snap["Department"],
                          "Na",
                          "Na",
                          "Na");
                    }
                    else if(_type=="Student"){
                      OnClick(
                          context,
                          _type,
                          snap["ID"],
                          "${snap['First Name']} ${snap['Middle Name']} ${snap['Last Name']}",
                          snap["Photo"],
                          snap["Email Id"],
                          snap["Phone No"],
                          snap["Birth Date"],
                          snap["Blood Group"],
                          snap["Joining Year"],
                          snap["Branch"],
                          snap["Semester"],
                          snap["Class"],
                          snap["Validity"]
                      );
                    }

                  }
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(snap["Photo"]),
                  ),
                  title: Text(
                      "${snap['First Name']} ${snap['Last Name']}"),
                  subtitle: Text("${snap['ID']}"),
                ));
          }).toList(),
        );
      },
    ),
  );
}

ListBox(String _type,String _collection,String _value){
  return Expanded(
    child: StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(_type)
          .where(_collection, isEqualTo: _value)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView(
          children: snapshot.data!.docs.map((snap) {
            return InkWell(
                onTap: () async {
                  if (!snap["Show Profile"]) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text(
                              "User don't allow to show details")),
                    );
                  } else {
                    if(_type=="Teacher"){
                      OnClick(
                          context,
                          _type,
                          snap["ID"],
                          "${snap['First Name']} ${snap['Middle Name']} ${snap['Last Name']}",
                          snap["Photo"],
                          snap["Email Id"],
                          snap["Phone No"],
                          snap["Birth Date"],
                          snap["Blood Group"],
                          snap["Joining Year"],
                          snap["Department"],
                          "Na",
                          "Na",
                          "Na");
                    }
                    else if(_type=="Student"){
                      OnClick(
                          context,
                          _type,
                          snap["ID"],
                          "${snap['First Name']} ${snap['Middle Name']} ${snap['Last Name']}",
                          snap["Photo"],
                          snap["Email Id"],
                          snap["Phone No"],
                          snap["Birth Date"],
                          snap["Blood Group"],
                          snap["Joining Year"],
                          snap["Branch"],
                          snap["Semester"],
                          snap["Class"],
                          snap["Validity"]
                      );
                    }

                  }
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(snap["Photo"]),
                  ),
                  title: Text(
                      "${snap['First Name']} ${snap['Last Name']}"),
                  subtitle: Text("${snap['ID']}"),
                ));
          }).toList(),
        );
      },
    ),
  );
}
