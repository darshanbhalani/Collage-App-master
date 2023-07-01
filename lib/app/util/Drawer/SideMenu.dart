import 'package:myapp2/app/util/Drawer/Students/Students.dart';
import 'package:myapp2/app/util/Functions.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Drawer/Courses/Courses.dart';
import 'package:myapp2/app/util/Drawer/Downloads/DownloadPage.dart';
import 'package:myapp2/app/util/Drawer/Faculties/Faculties.dart';
import 'package:myapp2/app/util/Drawer/AdminPanel/AdminPanelPage.dart';
import 'package:myapp2/app/util/Drawer/Settings/Settings.dart';
import 'package:myapp2/app/util/Drawer/StudentCorner/StudentCorner.dart';
import 'package:myapp2/app/util/Drawer/TeacherCorner/TeacherCorner.dart';
import 'package:myapp2/app/home/screens/classroom/Assignments/assignments_method.dart';
import 'package:myapp2/app/home/screens/UserProfilePage.dart';
import 'package:myapp2/app/util/VariablesFile.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfilePage(),
                  ));
            },
            child: Stack(
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPictureSize: const Size.square(80),
                  accountName: Text(
                    cuName,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  accountEmail: Text(
                    cuEmail,
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  currentAccountPicture: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(cuPhoto),
                    // backgroundImage: Image.file(file as File) as ImageProvider,
                  ),
                  decoration: BoxDecoration(
                    color:Color.fromARGB(100, 120, 120, 120),
                  ),
                ),
                Positioned(
                    right: 2,
                    bottom: 8,
                    child: Text(
                      cuType,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
          // Box(context, "Calender", Icons.calendar_month, CalenderPage(), true),
          Box(context, "Course", Icons.list_alt, CoursesPage(), true),
          Box(context, "Faculties", Icons.people_outline, Faculties(), true),
          Box(context, "Students", Icons.people_outline, Students(), true),
          //Box(context, "Downloads", Icons.download_for_offline_outlined, DownloadPage(), true),
          ListTile(
            leading: Icon(Icons.download_for_offline_outlined),
            title: Text("Downloads"),
            onTap: () async {
              final folders = await getDirFiles('downloads');

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DownloadPage(
                      folders: folders,
                    ),
                  ));
            },
          ),
          Box(context, "Admin Panel", Icons.admin_panel_settings_outlined,
              AdminPanelPage(), cuType == "Admin"),
          Box(context, "Student Corner", Icons.account_box_outlined,
              StudentCorner(), cuType == "Student"),
          Box(context, "Teacher Corner", Icons.account_box_outlined,
              TeacherCorner(), cuType == "Teacher"),
          Box(context, "Settings", Icons.settings_outlined, Settings(), true),
          InkWell(
            onTap: () {
              logout(context);
            },
            child: const ListTile(
              leading: Icon(Icons.logout),
              title: Text("LogOut"),
            ),
          ),
        ],
      ),
    );
  }

  Box(context, _lable, IconData _icon, _nextpage, bool _flag) {
    return Visibility(
      visible: _flag,
      child: ListTile(
        leading: Icon(_icon),
        title: Text(_lable),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => _nextpage,
              ));
        },
      ),
    );
  }
}
