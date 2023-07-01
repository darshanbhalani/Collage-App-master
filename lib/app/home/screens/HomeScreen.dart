import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/util/EventPage.dart';
import 'package:myapp2/app/util/NotificationIcon.dart';
import 'package:myapp2/app/util/Drawer/SideMenu.dart';
import '../../../app/util/PopupButton.dart';
import '../../../app/util/About.dart';
import 'package:myapp2/app/util/Functions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => About(),
                  ));
            },
            child: Text(
              "LDRP Institute of Technology & Research",
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
                  Timestamp temp1 = snap["Due Date"] as Timestamp;
                  DateTime temp2 = temp1.toDate() as DateTime;
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventPage(
                                title: snap["Title"],
                                coverPhoto: snap["Cover Photo"],
                                about: snap["About"],
                                coordinator: snap["Coordinator"],
                                link: snap["Link"],
                                dueDate: temp2.toString(),
                              )));
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color.fromARGB(100, 202, 202, 202),
                        Color.fromARGB(100, 103, 103, 103)
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
                                color: Colors.white54,
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
