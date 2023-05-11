import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Drawer/StudentCorner/StudentCorner.dart';
import 'package:myapp2/app/util/Functions.dart';

class TeacherCorner extends StatelessWidget {
  const TeacherCorner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teacher Corner"),
      ),
      body: ListView(
        children: [
          ListField(context, null, "Request to Admin", RequesttoAdmin()),
          ListField(context, null, "Submit Report", RequesttoAdmin()),
        ],
      ),
    );
  }
}
