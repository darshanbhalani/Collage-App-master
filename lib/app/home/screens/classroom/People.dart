import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Functions.dart';

class People extends StatefulWidget {
  final dropdownValue;
  const People({Key? key, required this.dropdownValue }) : super(key: key);

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Student").where("Class",isEqualTo: widget.dropdownValue).snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: snapshot.data!.docs.map((snap) {
              return InkWell(
                  onTap: ()async{
                    if(!snap["Show Profile"]){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("User don't allow to show details")),
                      );
                    }
                    else {
                      OnClick(context,"Student", snap["ID"], "${snap['First Name']} ${snap['Middle Name']} ${snap['Last Name']}", snap["Photo"], snap["Email Id"], snap["Phone No"], snap["Birth Date"], snap["Blood Group"], snap["Joining Year"], snap["Branch"],snap["Semester"],snap["Class"],snap["Validity"]);
                    }
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(snap["Photo"]),
                    ),
                    title: Text("${snap['First Name']} ${snap['Last Name']}"),
                    subtitle: Text("Student"),
                  )
              );
            }).toList(),
          );
        },
      );
  }
}
