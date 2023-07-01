import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp2/app/util/Functions.dart';
import '../../../app/util/NotificationIcon.dart';
import '../../../app/util/PopupButton.dart';
import '../../../app/util/VariablesFile.dart';
import 'package:myapp2/app/util/Drawer/SideMenu.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  PickedFile? _imagefile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          NotificationIcon(),
          PopupButton(),
        ],
      ),
      drawer: SideMenu(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Center(
                              child: Container(
                                height: 400,
                                width: 300,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(cuPhoto),
                                        fit: BoxFit.cover)),
                              ),
                            );
                          });
                    },
                    child: CircleAvatar(
                        radius: 80,
                        backgroundImage: _imagefile != null
                            ? FileImage(File(_imagefile!.path)) as ImageProvider
                            : NetworkImage(cuPhoto)),
                  ),
                  Positioned(
                    bottom: 5,
                    right: 10,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (builder) => Container(
                            height: 120,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Text(
                                  "Choose Profile Photo",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await takephoto(ImageSource.camera);
                                      },
                                      icon: Icon(Icons.camera),
                                    ),
                                    IconButton(
                                      onPressed: () async {
                                        await takephoto(ImageSource.gallery);
                                      },
                                      icon: Icon(Icons.upload),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(45),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ShowField("$cuType ID.", cuId, false),
            ShowField("Name", cuName, false),
            ShowField("Birth Date", cuBirthDate, false),
            ShowField("Blood Group", cuBloodGroup, false),
            ShowField("Joining Year", cuJoiningYear, false),
            Visibility(
              visible: cuType == "Student",
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShowField("Branch", cuBranch, false),
                    ShowField("Class", cuClass, false),
                    ShowField("Semester", cuSemester, false),
                    ShowField("Validity", cuValidity, false),
                  ]),
            ),
            Visibility(
              visible: cuType == "Teacher",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowField("Department", cuDeparttment, false),
                ],
              ),
            ),
            ShowField("Phone No.", cuPhoneNo, false),
            ShowField("Email", cuEmail, false),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  Future takephoto(ImageSource source) async {
    final pickedfile = await _picker.getImage(
      source: source,
    );
    if (pickedfile != null) {
      ChangePhoto(context, pickedfile);
    }
  }

  ChangePhoto(context, _pickedfile) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(File(_pickedfile.path)))),
                    )),
              ],
            ),
            content: Text(
              "Do You want to set profile photo ?",
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text("No")),
              TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Loading(context);
                    await _uploadImageToFirebaseStorage(_pickedfile);
                  },
                  child: Text("Yes")),
            ],
          );
        });
  }

  Future<void> _uploadImageToFirebaseStorage(pickedfile) async {
    final _file = File(pickedfile!.path!);
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('images/$cuType/profiles/${cuFirstName}_${cuLastName}');
    if (pickedfile != null) {
      storageRef.putFile(_file).whenComplete(() async {
        final imgUrl = await FirebaseStorage.instance
            .ref()
            .child('images/${cuType}/profiles/${cuFirstName}_${cuLastName}')
            .getDownloadURL();
        await FirebaseFirestore.instance
            .collection(cuType)
            .doc(cuId)
            .update({"Photo": imgUrl}).whenComplete(() async {
          cuPhoto = imgUrl;
          // SharedPreferences sp = await SharedPreferences.getInstance();
          // sp.setString("cuPhoto", cuPhoto);
          setState(() {
            _imagefile = pickedfile;
          });
          // Navigator.pop(context);
          SimpleSnackBar(context, "Profile Image Updated.");
        });
      });
    }
    // Navigator.pop(context);
  }
}
