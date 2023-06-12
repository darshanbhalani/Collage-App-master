import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admin/firebase_admin.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Request/HandleRequest.dart';
import 'package:myapp2/app/util/Request/NewRequest.dart';
import '../VariablesFile.dart';
import 'package:myapp2/app/util/Functions.dart';

class PendingRequest extends StatefulWidget {
  const PendingRequest({Key? key}) : super(key: key);

  @override
  State<PendingRequest> createState() => _PendingRequestState();
}

class _PendingRequestState extends State<PendingRequest>
    with SingleTickerProviderStateMixin {
  late TabController Tabcontroller;
  PageController controller = PageController();

  @override
  void initState() {
    Tabcontroller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pending Requests"),
        bottom: TabBar(
          controller: Tabcontroller,
          isScrollable: true,
          tabs: [
            Text(
              "Student",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text("Teacher",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
      body: TabBarView(
        controller: Tabcontroller,
        children: [
          RequestTab("Pending Request", "Student"),
          RequestTab("Pending Request", "Teacher"),
        ],
      ),
    );
  }
}


