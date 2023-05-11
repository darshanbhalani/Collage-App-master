import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/util/EventPage.dart';
import 'package:myapp2/app/util/NotifiactionPage.dart';
import 'package:myapp2/app/util/NotificationIcon.dart';
import 'package:myapp2/app/util/Drawer/SideMenu.dart';
import 'package:myapp2/app/util/VariablesFile.dart';
import '../../../app/util/PopupButton.dart';
import '../../../app/util/About.dart';
import 'package:myapp2/app/util/Functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationService _notifationService = NotificationService();
  int _index = 0;

  @override
  void initState() {
    _notifationService.initialiseNotification();
    print(classNames);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => About(),
              //     ));
            },
            child: Text(
              "Vidush Somani Institute of Technology & Research",
              style: TextStyle(fontSize: 23),
            )),
        actions: [
          NotificationIcon(),
          PopupButton(),
        ],
      ),
      drawer: SideMenu(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Events")
            .orderBy("Creation Time", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((snap) {
              return InkWell(
                onTap: () async {
                  Loading(context);
                  clicked_event_title = snap["Title"];
                  clicked_event_coverphoto = snap["Cover Photo"];
                  clicked_event_about = snap["About"];
                  clicked_event_link = snap["Link"];
                  clicked_event_coordinator = snap["Coordinator"];
                  timestamp = snap["Due Date"] as Timestamp;
                  clicked_event_duedate = timestamp?.toDate();
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EventPage()));
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(200, 212, 146, 200),
                        Color.fromARGB(100, 50, 200, 163)
                      ]),
                      color: Colors.lightBlueAccent[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              child: Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  snap["Title"],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )),
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                    image: NetworkImage(snap["Cover Photo"]),
                                    fit: BoxFit.cover)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
