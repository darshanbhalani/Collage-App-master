import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/util/VariablesFile.dart';

import 'Assignments/assignments_method.dart';
import 'Assignments/create_assignment.dart';
import 'Assignments/show_assignment.dart';

class ClassAssignment extends StatefulWidget {
  final String className;
  final String getKey;
  const ClassAssignment(
      {super.key, required this.className, required this.getKey});

  @override
  ClassAssignmentState createState() => ClassAssignmentState();
}

class ClassAssignmentState extends State<ClassAssignment> {
  firebase_auth.User? _user;
  late DatabaseReference firebaseDbRef;

  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now().toUtc();
    this.firebaseDbRef = FirebaseDatabase.instance.ref().child('assignments');
    this._user = firebase_auth.FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Visibility(
          visible: current_user_type == 'Teacher',
          child: createAssignmentButton(context)),
      body: Center(
        child: Column(
          children: <Widget>[
            _buildAssignmentList(),
            // const Divider(height: 2.0),
            // _buildComposeMsgRow()
          ],
        ),
      ),
    );
  }

  FloatingActionButton createAssignmentButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Center(
                  child: Text(
                    'Create',
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.assignment,
                  ),
                  title: Text('Assignment'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateNewAssignment(
                            className: widget.className,
                          ),
                        ));
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.question_mark,
                  ),
                  title: Text('Question'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.book,
                  ),
                  title: Text('Material'),
                ),
                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.change_circle,
                  ),
                  title: Text('Reuse Post'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.topic,
                  ),
                  title: Text('Topic'),
                ),
              ],
            ),
          ),
        );
      },
      child: Icon(Icons.add),
    );
  }

  // Builds the list of chat messages.
  Widget _buildAssignmentList() {
    Key key = Key(widget.getKey);
    Query query = firebaseDbRef.child(widget.className);
    setState(() {
      key = Key(DateTime.now().millisecondsSinceEpoch.toString());
      query = firebaseDbRef.child(widget.className);
    });
    return Flexible(
      child: Scrollbar(
        child: FirebaseAnimatedList(
          key: key,
          defaultChild: const Center(child: CircularProgressIndicator()),
          query: query,
          sort: (a, b) => b.key!.compareTo(a.key!),
          padding: const EdgeInsets.all(8.0),
          reverse: false,
          itemBuilder: (
            BuildContext ctx,
            DataSnapshot snapshot,
            Animation<double> animation,
            int idx,
          ) =>
              _assignmentFromSnapshot(snapshot, animation),
        ),
      ),
    );
  }

  // Returns the UI of one message from a data snapshot.
  Widget _assignmentFromSnapshot(
    DataSnapshot snapshot,
    Animation<double> animation,
  ) {
    final val = snapshot.value;
    if (val == null) {
      return Container();
    }
    final json = val as Map;
    print(json);
    final senderName = json['senderName'] as String? ?? '?? <unknown>';
    final assignmentTitle = json['title'] as String? ?? '??';
    final assignmentDescription =
        json['description'] as String? ?? 'No Description';
    final assignmentType = json['type'] as String? ?? '!!';
    final senderPhotoUrl = json['senderPhotoUrl'] as String;
    final time = json['time'] as String;
    final points = json['points'] as String;
    final dueDate = json['dueDate'] as String;
    final timeStamp = json['timeStamp'] as String?;
    final fileLinks = json['fileLinks'] as List;
    final fileNames = json['fileNames'] as List;
    final fileExt = json['fileExt'] as List;
    final messageUI = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.grey,
            ),
          ),
          child: ListTile(
            leading: CircleAvatar(
              radius: 20,
              child: Icon(Icons.event_note_outlined),
              backgroundColor: Theme.of(context).primaryIconTheme.color,
            ),
            title: Text(assignmentTitle),
            subtitle: Text('Posted $time'),
            onTap: () async {
              List dirFiles = [];
              Map studentAssignment;
              bool isDir = false;
              bool isBase = false;

              dirFiles = await saveDirFiles(
                files: dirFiles,
                path: 'uploads/${current_user_enrollmentno}/$assignmentTitle',
              ).whenComplete(() {
                isDir = true;
                setState(() {});
              });

              studentAssignment = await getStudentAssignment(
                widget.className,
                assignmentTitle,
                current_user_enrollmentno,
              ).whenComplete(() {
                isBase = true;
                setState(() {});
              });

              if (isBase && isDir) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowAssignment(
                      dueDate: dueDate,
                      fileLinks: fileLinks,
                      className: widget.className,
                      fileExt: fileExt,
                      fileNames: fileNames,
                      points: points,
                      title: assignmentTitle,
                      description: assignmentDescription,
                      dirFileExt: dirFiles[2],
                      dirFileNames: dirFiles[1],
                      dirFiles: dirFiles[0],
                      studentAssignment: studentAssignment,
                    ),
                  ),
                );
              }
            },
          )),
    );
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: messageUI,
    );
  }
}
