import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/home/screens/HomeScreen.dart';
import 'package:myapp2/app/home/screens/LiveClassPage.dart';
import 'package:myapp2/app/home/screens/MyClassHomePage.dart';
import 'package:myapp2/app/home/screens/StartNewSession.dart';
import 'package:myapp2/app/home/screens/UserProfilePage.dart';
import '../../app/util/Functions.dart';
import '../../app/util/VariablesFile.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getLocalDetails()
        .then((value) async =>
    await getDetails(current_user_type, current_user_enrollmentno))
        .then((value) async {
      await getClassNames().then((value) => print(classNames)).then((value) {
        Set demoSet = classNames.toSet();
        classNames = demoSet.toList() as List<String>;
      });

    });
  }

  int bottomnavbar_index = 0;

  var screens = [
    HomeScreen(),
    MyclassHomePage(
      classNames: classNames,
    ),
    // LiveClassPage(),
    Meeting(),
    UserProfilePage(),
    // AdminPanelPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[bottomnavbar_index],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
            // topLeft: Radius.circular(30.0),
            // topRight: Radius.circular(30.0),
            ),
        child: NavigationBar(
          // backgroundColor: Colors.transparent,
          height: 55,
          selectedIndex: bottomnavbar_index,
          onDestinationSelected: (bottomnavbar_index) =>
              setState(() => this.bottomnavbar_index = bottomnavbar_index),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.school),
              label: 'My class',
            ),
            NavigationDestination(
              icon: Icon(Icons.video_camera_front_rounded),
              label: 'Live class',
            ),
            NavigationDestination(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Future getClassNames() async {
    classNames = [];
    if (classNames.isEmpty) {
      if (current_user_type == 'Admin') {
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
      }
      if (current_user_type == 'Teacher') {
        await FirebaseFirestore.instance
            .collection('Class')
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            if (current_user_enrollmentno == doc['Mentor ID']) {
              setState(() {
                classNames.add(doc["Class Name"]);
                print('object');
              });
            }
          });
        });
      }

      if (current_user_type == 'Student') {
        classNames.add(current_user_class);
      }
    }
  }
}
