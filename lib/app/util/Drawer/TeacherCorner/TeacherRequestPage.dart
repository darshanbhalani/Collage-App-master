import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Functions.dart';
import 'package:myapp2/app/util/Request/NewRequest.dart';

class TeacherRequestPage extends StatefulWidget {
  const TeacherRequestPage({Key? key}) : super(key: key);

  @override
  State<TeacherRequestPage> createState() => _TeacherRequestPageState();
}

class _TeacherRequestPageState extends State<TeacherRequestPage>
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
          RequestTab("Pending Request", "Teacher"),
          RequestTab("Approved Request", "Teacher"),
          RequestTab("Rejected Request", "Teacher"),
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
