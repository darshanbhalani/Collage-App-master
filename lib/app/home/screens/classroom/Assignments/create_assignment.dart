import 'dart:io';

import 'package:date_time_format/date_time_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Functions.dart';

import '../../../../../app/util/VariablesFile.dart';
import '../../../../../app/util/PopupButton.dart';

import 'assignments_method.dart';

class CreateNewAssignment extends StatefulWidget {
  final String className;
  const CreateNewAssignment({super.key, required this.className});

  @override
  State<CreateNewAssignment> createState() => _CreateNewAssignmentState();
}

class _CreateNewAssignmentState extends State<CreateNewAssignment> {
  final TextEditingController title = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController pointsController = TextEditingController();
  String points = '100';
  bool isPoints = true;
  bool isUngraded = false;
  bool isCompleted = false;
  DateTime? dueDate;
  String lableDate = 'No due date';
  final _formkey = GlobalKey<FormState>();
  File? _pickedFile;
  late DatabaseReference firebaseDbRef;
  late String? pushKey;
  DateTime? now;
  firebase_auth.User? user;
  String? timeStamp;
  List fileNames = [];
  List files = [];
  List fileExt = [];
  List fileLinks = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.firebaseDbRef = FirebaseDatabase.instance.ref().child('assignments');
    pushKey = firebaseDbRef.push().key;
    now = DateTime.now();
    timeStamp = now!.year.toString() +
        now!.month.toString() +
        now!.day.toString() +
        now!.hour.toString() +
        now!.minute.toString() +
        now!.second.toString() +
        now!.millisecond.toString();
    this.user = firebase_auth.FirebaseAuth.instance.currentUser;

    pointsController.text = points;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    title.dispose();
    description.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbarAssignments(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _assignmentForm(context),
            Expanded(
              child: ListView.builder(
                itemCount: files.length,
                itemBuilder: (BuildContext context, int index) => ListTile(
                  leading: Icon(Icons.picture_as_pdf),
                  title: Text(
                    fileNames[index],
                  ),
                  trailing: InkWell(
                    child: Icon(Icons.remove),
                    onTap: () {
                      files.remove(files[index]);
                      fileNames.remove(fileNames[index]);
                      fileExt.remove(fileExt[index]);
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Create assignment required form

  //Main Form
  Form _assignmentForm(BuildContext context) {
    return Form(
      key: _formkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleField(),
          SizedBox(
            height: 10,
          ),
          _descriptionField(),
          SizedBox(
            height: 10,
          ),
          _selectAssignmentPoints(context),
          SizedBox(
            height: 10,
          ),
          _selectAssignmentDueDate(context)
        ],
      ),
    );
  }

  //Assignment DueDate
  Row _selectAssignmentDueDate(BuildContext context) {
    return Row(
      children: [
        Text('Due'),
        TextButton(
          onPressed: () async {
            dueDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2025),
            );
            setState(() {
              if (dueDate != null) {
                lableDate = DateTimeFormat.format(
                  dueDate!,
                  format: AmericanDateFormats.dayOfWeek,
                );
              }
            });
          },
          child: Text(
            lableDate,
            style: TextStyle(
              decoration: TextDecoration.underline,
              // color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  //Assignment Points
  Row _selectAssignmentPoints(BuildContext context) {
    return Row(
      children: [
        Text('Points'),
        TextButton(
          onPressed: () async {
            await selectPoints(context);
            setState(() {});
          },
          child: Text(
            points,
            style: TextStyle(
                decoration: TextDecoration.underline),
          ),
        )
      ],
    );
  }

  //Dialog Box : Assignment Points
  Future<dynamic> selectPoints(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Change point value'),
          content: SizedBox(
            height: 150,
            child: Column(
              children: [
                ListTile(
                  leading: (isPoints)
                      ? Icon(Icons.check_circle)
                      : Icon(Icons.circle),
                  title: Row(
                    children: [
                      SizedBox(
                        width: 40,
                        child: TextField(
                          enabled: isPoints,
                          keyboardType: TextInputType.number,
                          controller: pointsController,
                        ),
                      ),
                      Text('Points')
                    ],
                  ),
                  onTap: () {
                    setState(() {
                      isPoints = !isPoints;
                      if (isPoints) {
                        isUngraded = false;
                      }
                    });
                  },
                ),
                ListTile(
                  leading: (isUngraded)
                      ? Icon(Icons.check_circle)
                      : Icon(Icons.circle),
                  title: Text('Ungraded'),
                  onTap: () {
                    setState(() {
                      isUngraded = !isUngraded;
                      if (isUngraded) {
                        isPoints = false;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (points != 'Ungraded') {
                  isPoints = true;
                  isUngraded = false;
                } else {
                  isPoints = false;
                  isUngraded = true;
                }
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  points = (isPoints) ? pointsController.text : 'Ungraded';
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  //Form Description Field
  TextFormField _descriptionField() {
    return TextFormField(
      controller: description,
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
        labelText: 'Description (Optional)',
        // labelStyle:
        //     TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        // hintStyle:
        //     TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }

  //Form Title Field
  TextFormField _titleField() {
    return TextFormField(
        controller: title,
        onChanged: (value) {
          setState(() {});
        },
        validator: (value) {
          if (value!.isEmpty) {
            return "Title can't be empty";
          } else if (value.length < 3) {
            return "Give a proper title of atleast 3 characters of length";
          }
        },
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
          labelText: 'Title',

          // labelStyle:
          //     TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // hintStyle:
          //     TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ));
  }

  //Form ended

  //_________________________

  //Create Assignment Appbar

  //Main Appbar
  AppBar _appbarAssignments() {
    return AppBar(
      actions: [
        _appbarUploadFiles(),
        _appbarSendButton(),
        PopupButton(),
      ],
    );
  }

  //Appbar actions: send button
  IconButton _appbarSendButton() {
    return IconButton(
      onPressed: () async {
        if (_formkey.currentState!.validate() && files.isNotEmpty) {
          Loading(context);
          await uploadFiles(
                  firebasePath: 'Assignments/${widget.className}/${title.text}',
                  files: files,
                  fileNames: fileNames,
                  fileExt: fileExt)
              .whenComplete(() async {
            await generateLinks(
                    firebasePath:
                        'Assignments/${widget.className}/${title.text}',
                    fileNames: fileNames,
                    fileLinks: fileLinks)
                .then((value) async => await setPrimaryData());
          }).then((value) {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
          });
        }
        setState(() {});
      },
      icon: Icon(
        Icons.send,
        color: (title.text.length <= 3 && files.isEmpty)
            ? Colors.grey
            : Colors.black87,
      ),
    );
  }

  //Appbar actions : upload files button
  IconButton _appbarUploadFiles() {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            height: 200,
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Attach',
                    style: TextStyle(fontSize: 25),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.upload_file,
                  ),
                  title: Text('Upload File'),
                  onTap: () {
                    pickFile();
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.link,
                  ),
                  title: Text('Link'),
                  onTap: () {},
                ),
              ],
            ),
          ),
        );
      },
      icon: Icon(Icons.attach_file),
    );
  }

  //Assignment Appbar Ended

  //________________________________

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final PlatformFile fileDetails = result.files.first;
      setState(() {
        files.add(File(result.files.single.path!));
        fileNames.add(fileDetails.name);
        fileExt.add(fileDetails.extension);
      });
    }
    Navigator.pop(context);
  }

  Future setPrimaryData() async {
    print(fileLinks);
    await FirebaseDatabase.instance
        .ref()
        .child(
            'users/${current_user_enrollmentno}/assignments/${widget.className}/${title.text}/$timeStamp')
        .set({'key': pushKey}).then((value) async {
      await firebaseDbRef.child('${widget.className}/$pushKey').set({
        'senderId': this.user!.uid,
        'type': 'Assignment',
        'senderName': current_user_first_name + ' ' + current_user_last_name,
        'senderPhotoUrl': current_user_photo,
        'title': title.text,
        'description': description.text,
        'time': now!.format('D, M j, H:i'),
        'timeStamp': timeStamp,
        'fileLinks': fileLinks as List,
        'points': points,
        'fileNames': fileNames as List,
        'fileExt': fileExt as List,
        'dueDate': lableDate
      });
    });
  }

  // Future uploadFiles(List files, List fileNames, List fileExt) async {
  //   for (int i = 0; i < files.length; i++) {
  //     final storageRef = FirebaseStorage.instance.ref().child(
  //         'Assignments/${widget.className}/${title
  //             .text}/${fileNames[i]}');
  //     await storageRef.putFile(files[i]);
  //   }
  // }
  //   Future generateLinks() async {
  //     for(int i = 0; i<files.length;i++){
  //       final fileLink = await FirebaseStorage.instance
  //           .ref()
  //           .child(
  //           'Assignments/${widget.className}/${title
  //               .text}/${fileNames[i]}')
  //           .getDownloadURL();
  //       setState(() {
  //         fileLinks.add(fileLink);
  //         print(fileLinks[i]);
  //       });
  //     }
  //
  // }
}
