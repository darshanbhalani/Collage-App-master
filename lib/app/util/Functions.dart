import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Request/HandleRequest.dart';
import 'package:random_password_generator/random_password_generator.dart';
// import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../Login/LoginChoisePage.dart';
import 'VariablesFile.dart';

Future getDetails(String collection, String id) async {
  await FirebaseFirestore.instance
      .collection(collection)
      .doc(id)
      .get()
      .then((value) {
    current_user_photo = value["Photo"];
    current_user_first_name = value["First Name"];
    current_user_middle_name = value["Middle Name"];
    current_user_last_name = value["Last Name"];
    current_user_birthdate = value["Birth Date"];
    current_user_bloodgroup = value["Blood Group"];
    current_user_joining_date = value["Joining Year"];
    current_user_phoneno = value["Phone No"];
    current_user_email = value["Email Id"];

    if (current_user_type == "Student") {
      current_user_branch = value["Branch"];
      current_user_class = value["Class"];
      current_user_semester = value["Semester"];
      current_user_validity = value["Validity"];
    } else if (current_user_type == "Teacher") {
      current_user_department = value["Department"];
    }
  });
  current_user_name =
      "${current_user_first_name} ${current_user_middle_name} ${current_user_last_name}";

}

Future setDetails() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  sp.setString("current_user_enrollmentno", current_user_enrollmentno);
  sp.setString("current_user_type", current_user_type);
sp.setString("current_user_photo", current_user_photo);
sp.setString("current_user_first_name", current_user_first_name);
sp.setString("current_user_middle_name", current_user_middle_name);
sp.setString("current_user_last_name", current_user_last_name);
sp.setString("current_user_name", current_user_name);
sp.setString("current_user_birthdate", current_user_birthdate);
sp.setString("current_user_bloodgroup", current_user_bloodgroup);
sp.setString("current_user_joining_date", current_user_joining_date);
sp.setString("current_user_email", current_user_email);
sp.setString("current_user_phoneno", current_user_phoneno);
if(current_user_type=="Student"){
  sp.setString("current_user_branch", current_user_branch);
  sp.setString("current_user_class", current_user_class);
  sp.setString("current_user_semester", current_user_semester);
  sp.setString("current_user_validity", current_user_validity);
}
if(current_user_type=="Teacher"){
  sp.setString("current_user_department", current_user_department);
}
}

Future getLocalDetails() async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  current_user_type=sp.getString("current_user_type")??current_user_type;
  current_user_enrollmentno= sp.getString("current_user_enrollmentno")??current_user_enrollmentno;

current_user_photo=sp.getString("current_user_photo")??current_user_photo;
current_user_first_name=sp.getString("current_user_first_name")??current_user_first_name;
current_user_middle_name=sp.getString("current_user_middle_name")??current_user_middle_name;
current_user_last_name=sp.getString("current_user_last_name")??current_user_last_name;
current_user_name=sp.getString("current_user_name")??current_user_name;
current_user_birthdate=sp.getString("current_user_birthdate")??current_user_birthdate;
current_user_class=sp.getString("current_user_bloodgroup")??current_user_bloodgroup;
current_user_class=sp.getString("current_user_joining_date")??current_user_joining_date;
current_user_email =sp.getString("current_user_email")??current_user_email;
current_user_phoneno=sp.getString("current_user_phoneno")??current_user_phoneno;
if(current_user_type=="Student"){
  current_user_branch=sp.getString("current_user_branch")??current_user_branch;
current_user_class=sp.getString("current_user_class")??current_user_class;
current_user_class=sp.getString("current_user_semester")??current_user_semester;
current_user_department=sp.getString("current_user_validity")??current_user_validity;
}
if(current_user_type=="Teacher") {
  current_user_department =
      sp.getString("current_user_department") ?? current_user_department;
}
}

Future removeLocalDetails() async{
  SharedPreferences sp = await SharedPreferences.getInstance();
  await sp.remove("current_user_enrollmentno");
  await sp.remove("current_user_type");
await sp.remove("current_user_photo");
await sp.remove("current_user_first_name");
await sp.remove("current_user_middle_name");
await sp.remove("current_user_last_name");
await sp.remove("current_user_name");
await sp.remove("current_user_birthdate");
await sp.remove("current_user_bloodgroup");
await sp.remove("current_user_joining_date");
await sp.remove("current_user_email");
await sp.remove("current_user_phoneno");
await sp.remove("current_user_class");
await sp.remove("current_user_branch");
await sp.remove("current_user_semester");
await sp.remove("current_user_validity");
await sp.remove("current_user_department");
}

TFormField(context, String _lable, TextEditingController _controller,
    bool _condition, bool _flag) {
  return Column(
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

ShowField(String _lable, String _value,bool _flag) {
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
  return Padding(
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
          email: current_user_email, password: _currentpassword);
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
  if (_newemail1 == _newemail2 && current_user_email != _newemail1) {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: current_user_email, password: _currentpassword);
      await FirebaseAuth.instance.currentUser!
          .updateEmail(_newemail1)
          .then((_) async {
        current_user_email = _newemail1;
        // SharedPreferences sp = await SharedPreferences.getInstance();
        await FirebaseFirestore.instance
            .collection(current_user_type)
            .doc(current_user_enrollmentno)
            .update({
          "Email Id": _newemail1,
        }).onError((error, _) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error : $error')),
          );
        });
        // sp.setString("current_user_email", current_user_email);
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
  } else if (current_user_email == _newemail1 ||
      current_user_email == _newemail2) {
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
  if (_newphone1 == _newphone2 && current_user_phoneno != _newphone1) {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: current_user_email, password: _currentpassword);
      await FirebaseFirestore.instance
          .collection(current_user_type)
          .doc(current_user_enrollmentno)
          .update({
        "Phone No": _newphone1,
      }).onError((error, _) {
        Navigator.pop(context);
        return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error : $error')),
        );
      });
      current_user_phoneno = _newphone1;
      // SharedPreferences sp = await SharedPreferences.getInstance();
      // sp.setString("current_user_phoneno", current_user_phoneno);
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
  } else if (current_user_phoneno == _newphone1 ||
      current_user_phoneno == _newphone2) {
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
      context: context,
      builder: (context) {
        return Container(
            child: Center(
                // child: RiveAnimation.asset("assets/images/loading.riv"),
                child: CircularProgressIndicator(color: Colors.purpleAccent)
            ));

        return Center(child: CircularProgressIndicator(color: Colors.purpleAccent));
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
          password: getPassword(),
        )
        .whenComplete(() => passwordReset(context, _email));
  } on FirebaseException catch (e) {
    SimpleSnackBar(context, e.message ?? 'Something Went Wrong');
  }
}

String getPassword() {
  final RandomPasswordGenerator randomPassword = RandomPasswordGenerator();
  String newPassword = randomPassword.randomPassword(
    passwordLength: 6,
    specialChar: true,
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

Future SubmitRequest(String _title,String _purpose) async {
  var request_time = DateTime.now();
  await FirebaseFirestore.instance
      .collection("Pending Request").doc("${current_user_enrollmentno}-${current_user_name}-${request_time}")
      .set({
    "Doc":"${current_user_enrollmentno}-${current_user_name}-${request_time}",
    "Title": _title,
    "Purpose": _purpose,
    "ID": current_user_enrollmentno,
    "Name": current_user_name,
    "Branch":current_user_type=="Student" ? current_user_branch:current_user_department,
    "Class":current_user_type=="Student" ? current_user_class:"Na",
    "Semester":current_user_type=="Student" ? current_user_semester:"Na",
    "Request Time": request_time,
    "Type":current_user_type,
    "Flag":true,
  });
}


RequestTab(String _lable,String _type){
  int index=0;
  return StreamBuilder(
    stream: FirebaseFirestore.instance
        .collection(_lable)
        .where("Type" ,isEqualTo: _type)
    //     .orderBy("Request Time", descending: false)
        .snapshots(),
    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (!snapshot.hasData) {
        return Center(
          // child: CircularProgressIndicator(),
          child: Text("No Data"),
        );
      }
      else{
        index=0;
      }
      return ListView(
        children: snapshot.data!.docs.map((snap) {
          index=index+1;
          return ListTile(
            onTap:(){
              bool flag=false;
              if(current_user_type=="Admin" && _lable=="Pending Request"){
                flag=true;
              }
              if(_lable=="Pending Request"){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                        HandleRequest(handle:flag,flag1:"Student",flag2:_lable,doc: snap["Doc"],id: snap["ID"],name: snap["Name"],branch: snap["Branch"],cls: snap["Class"],semester: snap["Semester"],title: snap["Title"],purpose: snap["Purpose"],requesttime: snap["Request Time"],type: snap["Type"],flag: snap["Flag"],feedback: "Na",approvedby: "Na",rejectedby: "Na",approvedtime:"Na",rejectedtime: "Na",),
                    ));
              }
              else if(_lable=="Approved Request"){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                        HandleRequest(handle:flag,flag1:"Student",flag2:_lable,doc: snap["Doc"],id: snap["ID"],name: snap["Name"],branch: snap["Branch"],cls: snap["Class"],semester: snap["Semester"],title: snap["Title"],purpose: snap["Purpose"],requesttime: snap["Request Time"],type: snap["Type"],flag: snap["Flag"],feedback: "Na",approvedby: snap["Approved By"],rejectedby: "Na",approvedtime:snap["Approved Time"].toString(),rejectedtime: "Na",),
                    ));
              }
              else if(_lable=="Rejected Request"){
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) =>
                        HandleRequest(handle:flag,flag1:"Student",flag2:_lable,doc: snap["Doc"],id: snap["ID"],name: snap["Name"],branch: snap["Branch"],cls: snap["Class"],semester: snap["Semester"],title: snap["Title"],purpose: snap["Purpose"],requesttime: snap["Request Time"],type: snap["Type"],flag: snap["Flag"],feedback: "Na",approvedby: "Na",rejectedby: snap["Rejected By"],approvedtime:"Na",rejectedtime: snap["Rejected Time"].toString(),),
                    ));
              }
            },
            leading: Text(index.toString()),
            title: current_user_type=="Admin" ? Text("${snap["ID"]}"):Text(snap["Title"].toString()),
            subtitle: current_user_type=="Admin" ? Text(snap["Title"].toString()):Text(snap["Purpose"],maxLines: 1,),
            // trailing: Icon(Icons.circle,color: Colors.green,size: 10,),
          );
        }).toList(),
      );
    },
  );
}
