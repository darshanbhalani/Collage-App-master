import 'package:myapp2/app/util/Functions.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Drawer/AdminPanel/Add-UpdateClass.dart';
import 'package:myapp2/app/util/Drawer/AdminPanel/Add-UpdateEvent.dart';
import 'package:myapp2/app/util/Drawer/AdminPanel/Add-UpdateStudent.dart';
import 'package:myapp2/app/util/Drawer/AdminPanel/Add-UpdateTeacher.dart';
import 'package:myapp2/app/util/RequestPage.dart';
import '../../../../app/util/NotificationIcon.dart';
import '../../../../app/util/PopupButton.dart';

class AdminPanelPage extends StatefulWidget {
  const AdminPanelPage({Key? key}) : super(key: key);

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isMobile = false;
    bool isTablet = false;
    bool isDesktop = false;
    if(width<=480){
      setState(() {
        isMobile = true;
      });
    } else if(width>480 && width<=1024){
      setState(() {
        isTablet = true;
      });
    } else {
      setState(() {
        isDesktop = true;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Panel"),
        actions: [
          NotificationIcon(),
          PopupButton(),
        ],
      ),
      body: GridView.count(
          crossAxisCount: (isDesktop)?4:(isTablet)?3:2,
          mainAxisSpacing: (isDesktop)?10:(isTablet)?10:10,
          crossAxisSpacing: (isDesktop)?10:(isTablet)?10:10,
          childAspectRatio: (isDesktop)?1.53:(isTablet)?1.40:1.05,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            CardField(context, "Add New Student", Icons.person_add_alt,
                AddNewStudent()),
            CardField(context, "Update Student Details",
                Icons.person_outline_outlined, UpdateStudentDetails()),
            CardField(context, "Add New Teacher", Icons.person_outline_outlined,
                AddNewTeacher()),
            CardField(context, "Update Teacher Details", Icons.group_outlined,
                UpdateTeacherDetails()),
            CardField(context, "Create New Class", Icons.add_home_work_outlined,
                CreateNewClass()),
            CardField(context, "Update Class Details",
                Icons.event_repeat_outlined, UpdateClassDetails()),
            CardField(context, "Add New Event", Icons.event_available_outlined,
                AddNewEvent()),
            CardField(context, "Update Event Details",
                Icons.event_repeat_outlined, UpdateEventDetails()),
            CardField(context, "Pending Requests", Icons.event_repeat_outlined,
                PendingRequest()),
            CardField(context, "Approved Requests",
                Icons.event_available_outlined, ApprovedRequest()),
            CardField(context, "Rejected Requests", Icons.event_busy_outlined,
                RejectedRequest())
          ]),
    );
  }
}
