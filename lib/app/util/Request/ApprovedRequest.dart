import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Functions.dart';

class ApprovedRequest extends StatefulWidget {
  const ApprovedRequest({Key? key}) : super(key: key);

  @override
  State<ApprovedRequest> createState() => _ApprovedRequestState();
}

class _ApprovedRequestState extends State<ApprovedRequest>
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
        title: Text("Approved Requests"),
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
          RequestTab("Approved Request", "Student"),
          RequestTab("Approved Request", "Teacher"),
        ],
      ),
    );
  }
}