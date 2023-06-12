import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Functions.dart';
import 'package:myapp2/app/util/Request/NewRequest.dart';

class StudentRequestPage extends StatefulWidget {
  const StudentRequestPage({Key? key}) : super(key: key);

  @override
  State<StudentRequestPage> createState() => _StudentRequestPageState();
}

class _StudentRequestPageState extends State<StudentRequestPage>
    with SingleTickerProviderStateMixin{
  late TabController Tabcontroller;
  PageController controller = PageController();

  @override
  void initState() {
    Tabcontroller = TabController(length: 3, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Requests"),
        bottom: TabBar(
          controller: Tabcontroller,
          isScrollable: true,
          tabs: [
            Text("Pending",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text("Approved",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text("Rejected",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
      body: TabBarView(
        controller: Tabcontroller,
        children: [
          RequestTab("Pending Request", "Student"),
          RequestTab("Approved Request", "Student"),
          RequestTab("Rejected Request", "Student"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewRequest()));
        },
      ),
    );
  }
}
