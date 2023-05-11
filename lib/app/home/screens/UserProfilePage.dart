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
                                        image: NetworkImage(current_user_photo),
                                        fit: BoxFit.cover)),
                              ),
                            );
                          });
                    },
                    child: CircleAvatar(
                        radius: 80,
                        backgroundImage: _imagefile != null
                            ? FileImage(File(_imagefile!.path)) as ImageProvider
                            : NetworkImage(current_user_photo)),
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
            ShowField("$current_user_type ID.", current_user_enrollmentno),
            ShowField("Name", current_user_name),
            ShowField("Birth Date", current_user_birthdate),
            ShowField("Blood Group", current_user_bloodgroup),
            ShowField("Joining Year", current_user_joining_date),
            Visibility(
              visible: current_user_type == "Student",
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShowField("Branch", current_user_branch),
                    ShowField("Class", current_user_class),
                    ShowField("Semester", current_user_semester),
                    ShowField("Validity", current_user_validity),
                  ]),
            ),
            Visibility(
              visible: current_user_type == "Teacher",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowField("Department", current_user_department),
                ],
              ),
            ),
            ShowField("Phone No.", current_user_phoneno),
            ShowField("Email", current_user_email),
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
    final storageRef = FirebaseStorage.instance.ref().child(
        'images/$current_user_type/profiles/${current_user_first_name}_${current_user_last_name}');
    if (pickedfile != null) {
      storageRef.putFile(_file).whenComplete(() async {
        final imgUrl = await FirebaseStorage.instance
            .ref()
            .child(
                'images/${current_user_type}/profiles/${current_user_first_name}_${current_user_last_name}')
            .getDownloadURL();
        await FirebaseFirestore.instance
            .collection(current_user_type)
            .doc(current_user_enrollmentno)
            .update({"Photo": imgUrl}).whenComplete(() async {
          current_user_photo = imgUrl;
          // SharedPreferences sp = await SharedPreferences.getInstance();
          // sp.setString("current_user_photo", current_user_photo);
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
