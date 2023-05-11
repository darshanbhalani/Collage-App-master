import 'dart:io';
import 'package:date_time_format/date_time_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Functions.dart';
import 'package:open_filex/open_filex.dart';
import '../../../../../app/util/VariablesFile.dart';
import 'assignments_method.dart';

class ShowAssignment extends StatefulWidget {
  final String title;
  final String className;
  final String points;
  final String description;
  final String dueDate;
  final List fileLinks;
  final List fileExt;
  final List fileNames;
  final List dirFiles;
  final List dirFileExt;
  final List dirFileNames;
  final Map studentAssignment;
  const ShowAssignment(
      {Key? key,
      required this.title,
      required this.className,
      required this.dueDate,
      required this.points,
      required this.description,
      required this.fileLinks,
      required this.fileNames,
      required this.fileExt,
      required this.dirFiles,
      required this.dirFileNames,
      required this.dirFileExt,
      required this.studentAssignment})
      : super(key: key);

  @override
  State<ShowAssignment> createState() => _ShowAssignmentState();
}

class _ShowAssignmentState extends State<ShowAssignment> {
  List uploadedFileNames = [];
  List uploadedFiles = [];
  List uploadedFileExt = [];
  List uploadedFileLinks = [];
  late List dirFiles;
  late List dirFileNames;
  late List dirFileExt;
  late List studentFileLinks;
  late List studentFileNames;
  late List studentFileExt;
  late bool isUploaded;
  late DatabaseReference firebaseDbRef;
  late String timeStamp;
  String? pushKey;
  DateTime? now;
  firebase_auth.User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.firebaseDbRef = FirebaseDatabase.instance.ref().child('assignments');
    pushKey = firebaseDbRef.push().key;

    dirFiles = widget.dirFiles;
    dirFileNames = widget.dirFileNames;
    dirFileExt = widget.dirFileExt;
    if (widget.studentAssignment['fileLinks'] != []) {
      studentFileLinks = widget.studentAssignment['fileLinks'] ?? [];
      studentFileNames = widget.studentAssignment['fileNames'] ?? [];
      studentFileExt = widget.studentAssignment['fileExt'] ?? [];
    }

    if (widget.dirFiles.isNotEmpty || studentFileNames.isNotEmpty) {
      isUploaded = true;
    } else {
      isUploaded = false;
    }

    print(isUploaded);

    now = DateTime.now();
    timeStamp = now!.year.toString() +
        now!.month.toString() +
        now!.day.toString() +
        now!.hour.toString() +
        now!.minute.toString() +
        now!.second.toString() +
        now!.millisecond.toString();
    this.user = firebase_auth.FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomSheet: bottomUploadButton(),
      body: Column(
        children: [
          Flexible(
            child: buildAssignmentDetails(context),
          ),
          Expanded(
            child: studentUploadedAssignments(),
          ),
        ],
      ),
    );
  }

  //Created Widgets

  Visibility bottomUploadButton() {
    return Visibility(
      visible: current_user_type == 'Student',
      //child: bottomSheetUpload(),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
              context: context, builder: (context) => bottomSheetUpload());
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Work',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Icon(Icons.arrow_upward),
              (isUploaded)
                  ? Text((widget.points == 'Ungraded')
                      ? 'Ungraded'
                      : 'Ungraded/${widget.points}')
                  : Text(widget.dueDate),
            ],
          ),
        ),
      ),
    );
  }

  Container bottomSheetUpload() {
    return Container(
      height: 200,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Work',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Icon(Icons.arrow_downward),
                  (isUploaded)
                      ? Text((widget.points == 'Ungraded')
                          ? 'Ungraded'
                          : 'Ungraded/${widget.points}')
                      : Text(widget.dueDate),
                ],
              ),
            ),
          ),
          Visibility(
            visible: !isUploaded,
            child: ElevatedButton(
              onPressed: () async {
                await pickFile();
              },
              child: Text('+ Add work'),
            ),
          ),
          Visibility(
            visible: !isUploaded,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
              ),
              onPressed: () async {
                Loading(context);
                await uploadFiles(
                        files: uploadedFiles,
                        fileNames: uploadedFileNames,
                        fileExt: uploadedFileExt,
                        firebasePath:
                            'Assignments/${widget.className}/${widget.title}/${current_user_enrollmentno}')
                    .whenComplete(() async {
                  await generateLinks(
                          fileLinks: uploadedFileLinks,
                          fileNames: uploadedFileNames,
                          firebasePath:
                              'Assignments/${widget.className}/${widget.title}/${current_user_enrollmentno}')
                      .then((value) async {
                    await setPrimaryData();
                  }).then((value) async {
                    await saveUploadedFiles(
                        fileNames: uploadedFileNames,
                        files: uploadedFiles,
                        path:
                            'uploads/${current_user_enrollmentno}/${widget.title}');
                  });
                  isUploaded = true;
                  setState(() {});
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
                setState(() {});
              },
              child: Text('✔ Submin & Mark as Done'),
            ),
            replacement: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
              ),
              onPressed: () {},
              child: Text('Assignment Submitted'),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildAssignmentDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          Text('${widget.points} points'),
          Divider(),
          Text(widget.description.isEmpty
              ? 'No Description'
              : widget.description),
          Expanded(
            child: ListView.builder(
              itemCount: widget.fileLinks.length,
              itemBuilder: (BuildContext context, int index) => ListTile(
                leading: Icon(Icons.picture_as_pdf),
                title: Text(
                  widget.fileNames[index],
                ),
                //trailing: (_files[index].exists())?Icon(Icons.download_done):Icon(Icons.download),
                onTap: () async {
                  Loading(context);
                  if (await isDownloaded(index, 'downloads')) {
                    Navigator.pop(context);
                    await openFile(widget.fileNames[index], 'downloads', [], 0);
                  } else {
                    await downloadFile(
                            widget.fileNames[index], index, 'downloads')
                        .then((value) async {
                      Navigator.pop(context);
                    });
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  ListView studentUploadedAssignments() {
    return ListView.builder(
      itemCount:
          (!isUploaded) ? (uploadedFileNames.length) : (dirFileNames.length),
      itemBuilder: (BuildContext context, int index) => ListTile(
        onTap: () async {
          (!isUploaded)
              ? await openFile(
                  uploadedFileNames[index], '', uploadedFiles, index)
              : (dirFileNames.isNotEmpty)
                  ? await openFile(
                      dirFileNames[index],
                      'uploads/${current_user_enrollmentno}/${widget.title}',
                      [],
                      0)
                  : await downloadFile(studentFileNames[index], index,
                      'uploads/${current_user_enrollmentno}/${widget.title}');
        },
        leading: Icon(Icons.picture_as_pdf),
        title: Text(
          (!isUploaded)
              ? uploadedFileNames[index]
              : (dirFileNames.isNotEmpty)
                  ? dirFileNames[index]
                  : studentFileNames[index],
        ),
        trailing: (!isUploaded)
            ? InkWell(
                child: Icon(Icons.remove),
                onTap: () {
                  uploadedFiles.remove(uploadedFiles[index]);

                  uploadedFileNames.remove(uploadedFileNames[index]);
                  uploadedFileExt.remove(uploadedFileExt[index]);
                  setState(() {});
                },
              )
            : SizedBox(),
      ),
    );
  }

//Created Methods

  Future<void> downloadFile(String fileName, int index, String path) async {
    final dir = await getDirectory(path);
    print(dir);
    final ref = FirebaseStorage.instance
        .ref()
        .child('Assignments/${widget.className}/${widget.title}/$fileName');
    final file = File('$dir/${ref.name}');

    final downloadTask = ref.writeToFile(file);
    downloadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.paused:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task Paused')),
          );
          break;
        case TaskState.success:
          openFile(widget.fileNames[index], path, [], 0);
          break;
        case TaskState.canceled:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('canceled ${ref.name}')),
          );
          break;
        case TaskState.error:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An Error Occured Downloading ${ref.name}')),
          );
          break;
        default:
      }
    });
  }

  Future<bool> isDownloaded(int index, path) async {
    final dir = await getDirectory(path);
    if (await File('$dir/${widget.fileNames[index]}').exists()) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final PlatformFile fileDetails = result.files.first;

      uploadedFiles.add(File(result.files.single.path!));
      uploadedFileNames.add(fileDetails.name);
      uploadedFileExt.add(fileDetails.extension);

      setState(() {});
    }
    Navigator.pop(context);
  }

  Future setPrimaryData() async {
    print(uploadedFileLinks);

    await firebaseDbRef
        .child(
            'Students/${widget.className}/${widget.title}/${current_user_enrollmentno}')
        .set({
      'senderId': this.user!.uid,
      'type': 'Assignment',
      'enrollment': current_user_enrollmentno,
      'senderName': current_user_first_name + ' ' + current_user_last_name,
      'senderPhotoUrl': current_user_photo,
      'title': widget.title,
      'description': widget.description,
      'time': now!.format('D, M j, H:i'),
      'timeStamp': timeStamp,
      'fileLinks': uploadedFileLinks,
      'points': 'Ungraded',
      'fileNames': uploadedFileNames,
      'fileExt': uploadedFileExt,
      'dueDate': widget.dueDate
    });
  }
}
