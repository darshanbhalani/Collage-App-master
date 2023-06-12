import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Functions.dart';

class RejectedRequest extends StatefulWidget {
  const RejectedRequest({Key? key}) : super(key: key);

  @override
  State<RejectedRequest> createState() => _RejectedRequestState();
}

class _RejectedRequestState extends State<RejectedRequest>
    with SingleTickerProviderStateMixin{

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
        title: Text("Rejected Requests"),
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
          RequestTab("Rejected Request", "Student"),
          RequestTab("Rejected Request", "Teacher"),
        ],
      ),
    );
  }
}