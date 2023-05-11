import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../app/util/VariablesFile.dart';
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
            // StudentRequestApproved(),
            // TeacherRequestPending(),
          ],
        ),
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}

class ApprovedRequest extends StatefulWidget {
  const ApprovedRequest({Key? key}) : super(key: key);

  @override
  State<ApprovedRequest> createState() => _ApprovedRequestState();
}

class _ApprovedRequestState extends State<ApprovedRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Approved Request"),
      ),
    );
  }
}

class RejectedRequest extends StatefulWidget {
  const RejectedRequest({Key? key}) : super(key: key);

  @override
  State<RejectedRequest> createState() => _RejectedRequestState();
}

class _RejectedRequestState extends State<RejectedRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rejected Request"),
      ),
    );
  }
}

class NewRequest extends StatefulWidget {
  const NewRequest({Key? key}) : super(key: key);

  @override
  State<NewRequest> createState() => _NewRequestState();
}

class _NewRequestState extends State<NewRequest> {
  @override
  Widget build(BuildContext context) {
    var _title = TextEditingController();
    var _purpose = TextEditingController();
    DateTime? request_time;
    return Scaffold(
        appBar: AppBar(
          title: Text("Create New Request"),
        ),
        body: ListView(
          children: [
            Form(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Column(
                  children: [
                    TFormField(
                        context, "Title of Request", _title, true, false),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Purpose of Request";
                        }
                      },
                      maxLines: 10,
                      controller: _purpose,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.teal,
                        )),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: Colors.orange,
                          width: 3,
                        )),
                        labelText: "Purpose of Request",
                        labelStyle: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () async {
                            // Clear();
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.blue,
                            ),
                            child: Center(
                                child: Text(
                              "Clear",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            request_time = DateTime.now();
                            print(request_time);
                            await FirebaseFirestore.instance
                                .collection("Pending Request")
                                .add({
                              "Title": _title.text,
                              "Purpose": _purpose.text,
                              "ID": current_user_enrollmentno,
                              "Name": current_user_name,
                              "Request Time": request_time,
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.blue,
                            ),
                            child: Center(
                                child: Text(
                              "Submit",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class StudentRequestPending extends StatelessWidget {
  const StudentRequestPending({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class StudentRequestApproved extends StatelessWidget {
  const StudentRequestApproved({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class StudentRequestRejected extends StatelessWidget {
  const StudentRequestRejected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TeacherRequestPending extends StatelessWidget {
  const TeacherRequestPending({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TeacherRequestApproved extends StatelessWidget {
  const TeacherRequestApproved({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TeacherRequestRejected extends StatelessWidget {
  const TeacherRequestRejected({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
