import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
// import 'package:myapp2/Assets/VariablesFile.dart';
import 'package:myapp2/app/util/Functions.dart';

import '../../../util/VariablesFile.dart';


class EditClass extends StatefulWidget {
  final dropdownValue;
  const EditClass({Key? key,required this.dropdownValue}) : super(key: key);

  @override
  State<EditClass> createState() => _EditClassState();
}

class _EditClassState extends State<EditClass> {

  final  _className = TextEditingController();
  final _department = TextEditingController();
  final _initYear = TextEditingController();
  final _finalYear = TextEditingController();
  final  _mentor = TextEditingController();
  final  _totalStudent = TextEditingController();
  final  _semester = SingleValueDropDownController();
  String __semester="";
  bool flag1=false;
  List _teachers1 = [];
  List _teachers2 = [];
  List _subjects1 = [];
  List _subjects2=[];
  List<String> tIds = [];

  List<String> tNames = [];
  List<DropDownValueModel> tList = [];
  List<String> SubjectNames = [];
  List<DropDownValueModel> SubjectList = [];
  int _l=0;

  final _controller=SingleValueDropDownController();



  @override
  void initState() {
    getDetails();
    buildTeacherList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
        child: ListView(
          children: [
            TFormField(context, "Mentor", _mentor, false, false),
            TFormField(context, "Class Name", _className, false, false),
            TFormField(context, "Total Students", _totalStudent, false, false),
            TFormField(context, "Department", _department, false, false),
            Row(
              children: [
                Flexible(child:TFormField(context, "Joining Year", _initYear, false, false),),
                SizedBox(width: 4,),
                Flexible(child:TFormField(context, "Final Year", _finalYear, false, false),),
              ],
            ),
            DropField(context, "Semester", Semesters, _semester, flag1),
            Row(
              children: [
                Box(context,"Teachers", Temp,_teachers1, tList,Save),
                SizedBox(width: 4,),
                Box(context, "Subjects",buildClassList,_subjects1, SubjectList,Save),
              ],
            ),
            SizedBox(height: 50,)
          ],
        ),
      ),
      floatingActionButton: !flag1 ?FloatingActionButton(
        onPressed: (){
          setState(() {
            flag1=true;
          });
        },
        child: Icon(Icons.edit),
      ):null,
      bottomSheet: flag1 ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
              onPressed: (){
                setState(() {
                  flag1=false;
                });
              },
              child: SizedBox(
                  height: 25,
                  child: Center(child: Text("Cancle"),))),
          ElevatedButton(
              onPressed: () async {
                Loading(context);
                await FirebaseFirestore.instance
                    .collection('Class')
                    .doc(widget.dropdownValue).update({
                  "Semester": _semester.dropDownValue!.value,
                  "Subjects": _subjects2,
                  "Teachers": _teachers2,
                }).then((value) async {
                  await FirebaseFirestore.instance.collection('Teacher').doc(tIds[_controller.dropDownValue!.value]).update({
                    "Class":FieldValue.arrayUnion([_className.text])
                  });

                  setState(() {
                    flag1=false;
                  });
                  Navigator.pop(context);
                });
              },
              child: SizedBox(
                  height:25,
                  child: Center(child: Text("Save"),))),
        ],
      ):null,
    );
  }

  Temp(){
    // Navigator.pop(context);
  }

  Save() async {
    setState(() {
      _subjects2=_subjects1;
      _teachers2=_teachers1;
    });
    Navigator.pop(context);
  }

  getDetails() async {
    // Loading(context);
    await FirebaseFirestore.instance.collection("Class").doc(widget.dropdownValue).get().then((value) {
      setState(() {
        _mentor.text=value["Mentor"];
        _className.text=value["Class Name"];
        _initYear.text=value["Joined Year"];
        _department.text=value["Department"];
        _finalYear.text=value["Final Year"];
        __semester=value["Semester"];
        _semester.setDropDown( DropDownValueModel(name: value["Semester"], value: value["Semester"]),);
        _totalStudent.text=value["Students"].length.toString();
      });
    });
    await FirebaseFirestore.instance
        .collection('Class').doc(widget.dropdownValue)
        .get().then((value) {
      setState(() {
        _subjects1=value["Subjects"];
        _subjects2=_subjects1;
        _teachers1=value["Teachers"];
        _subjects2=_subjects1;
      });
    });
  }

  Future buildTeacherList() async {
    await FirebaseFirestore.instance
        .collection('Teacher')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          tIds.add(doc["ID"]);
          tNames.add("${doc["ID"]} - ${doc["First Name"]} ${doc["Last Name"]}");
        });
      });
    });

    for (int i = 0; i < tNames.length; i++) {
      setState(() {
        if(!tList.contains(tNames[i])){
          tList.add(DropDownValueModel(
              name: "${tNames[i]}", value: i));
        }
      });
    }
  }

  Box(context,_lable,Function _buildlist,List _list1,List<DropDownValueModel> _list2,Function _function){
    return Flexible(
      child: InkWell(
        onTap: () async {
          showDialog(
              context: context,
              builder: (context){
                return StatefulBuilder(
                  builder: (context,setState)=> Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height*0.60,
                      width: MediaQuery.of(context).size.width*0.9,
                      child: Container(
                        child: Card(
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(_lable,style: TextStyle(fontSize: 20),),
                                    Visibility(
                                      visible: flag1,
                                      child: IconButton(
                                        onPressed: () async{
                                          Loading(context);
                                          await _buildlist();
                                          showDialog(
                                              context: context,
                                              builder: (context){
                                                return Center(
                                                  child: SizedBox(
                                                    height: MediaQuery.of(context).size.height*0.25,
                                                    width: MediaQuery.of(context).size.width*0.9,
                                                    child: Container(
                                                      child: Card(
                                                        elevation: 10,
                                                        child: Padding(
                                                          padding: EdgeInsets.all(10.0),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              Flexible(child: DropField(context, "Select ${_lable}", _list2, _controller, true),),
                                                              SizedBox(
                                                                width: 100,
                                                                child: ElevatedButton(onPressed: (){
                                                                  setState(() {
                                                                    SubjectNames.clear();
                                                                    SubjectList.clear();
                                                                    _list1.add(_controller.dropDownValue!.value);
                                                                    _controller.setDropDown(null);
                                                                  });
                                                                  Navigator.pop(context);
                                                                  Navigator.pop(context);

                                                                }, child: Text("Add")),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                          setState(() {
                                          });
                                        },
                                        icon: Icon(Icons.add,size: 35,),
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(thickness: 2,),
                                Expanded(
                                  child: ListView.builder(
                                      itemCount: _list1.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(child: Text( _list1[index].toString())),
                                            (flag1)?IconButton(onPressed: (){
                                              setState(() {
                                                _list1.removeAt(index);
                                                print(_list1);
                                              });
                                            },
                                                icon: Icon(Icons.remove)):Container(),
                                          ],
                                        );
                                      }
                                  ),
                                ),
                                Visibility(
                                  visible: flag1,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(onPressed: (){
                                        Navigator.pop(context);
                                      },
                                          child: Text("Cancle")
                                      ),
                                      ElevatedButton(onPressed: (){
                                        _function();
                                      }, child: Text("Save")),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
                color: Colors.grey
            ),
          ),
          child: Center(child: Text(_lable)),
        ),
      ),
    );
  }

  Future buildClassList() async {
    String temp="";
    if(_department.text=="Computer"){
      temp="Computer Engineering";
    }
    if(_department.text=="IT"){
      temp="Information Technology";
    }
    await FirebaseFirestore.instance
        .collection('Courses').doc(temp).collection(_semester.dropDownValue!.name)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          SubjectNames.add(doc["Subject Name"]);
        });
      });
    }).whenComplete(() {
      for (int i = 0; i < SubjectNames.length; i++) {
        setState(() {
          SubjectList.add(DropDownValueModel(
              name: "${SubjectNames[i]}", value: "${SubjectNames[i]}"));
        });
      }
      // Navigator.pop(context);
    });
  }
}

