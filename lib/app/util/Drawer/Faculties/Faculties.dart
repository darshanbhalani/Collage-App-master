import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

String clicked_photo="";
String clicked_id="";
String clicked_name="";
String clicked_class="";
String clicked_branch="";
String clicked_email="";
String clicked_phone="";
String clicked_bloodgroup="";
String clicked_department="";
String clicked_birthdate="";
String clicked_joiningyear="";
String clicked_semester="";
String clicked_validity="";
bool? clicked_showprofile;


class Faculties extends StatefulWidget {
  const Faculties({Key? key}) : super(key: key);

  @override
  State<Faculties> createState() => _FacultiesState();
}

class _FacultiesState extends State<Faculties> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Faculties"),
      ),
      body:StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Teacher").snapshots(),
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
                    clicked_name="${snap['First Name']} ${snap['Middle Name']} ${snap['Last Name']}";
                    clicked_photo=snap["Photo"];
                    print(clicked_photo);
                    clicked_id=snap["ID"];
                    clicked_email=snap["Email Id"];
                    clicked_phone=snap["Phone No"];
                    clicked_birthdate=snap["Birth Date"];
                    clicked_bloodgroup=snap["Blood Group"];
                    clicked_joiningyear=snap["Joining Year"];
                    clicked_department=snap["Department"];
                    OnClick(context);
                  }
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(snap["Photo"]),
                  ),
                  title: Text("${snap['First Name']} ${snap['Last Name']}"),
                  subtitle: Text("${snap['Status']}"),
                )
              );
            }).toList(),
          );
        },
      ),
    );
  }

  OnClick(context){
    return showDialog(
        context: context,
        builder: (context){
          return Center(
            child: SizedBox(
              height: MediaQuery.of(context).size.height*0.65,
              width: MediaQuery.of(context).size.width*0.9,
              child: Container(
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(clicked_photo),
                            ),
                            SizedBox(width: 10,),
                            Container(
                              child: Flexible(
                                child: Column(
                                  children: [
                                    Text(clicked_name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Divider(thickness: 3,),
                        setData("ID", clicked_id),
                        setData("Email", clicked_email),
                        setData("Phone No", clicked_phone),
                        setData("Birth Date", clicked_birthdate),
                        setData("Blood Group", clicked_bloodgroup),
                        setData("Joining Year", clicked_joiningyear),
                        setData("Department", clicked_department),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  setData(_lable,_value){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Text("${_lable} : ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
              Container(
                child: Flexible(
                  child: Column(
                    children: [
                      Text(_value,style: TextStyle(fontSize: 17),)
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8,),
          Divider(thickness: 2,),
        ],
      ),
    );
  }
}
