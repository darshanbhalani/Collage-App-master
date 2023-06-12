import 'package:flutter/material.dart';
import 'package:myapp2/app/home/screens/classroom/People.dart';
import 'package:myapp2/app/util/Drawer/SideMenu.dart';
import '../../../app/util/NotificationIcon.dart';
import '../../../app/util/PopupButton.dart';
import '../../../app/util/VariablesFile.dart';
import '../../../app/home/screens/classroom/class_assignments.dart';
import '../../../app/home/screens/classroom/class_chat.dart';
import '../../../app/home/screens/classroom/class_streams.dart';
import '../../../app/home/screens/classroom/EditClass.dart';

class MyclassHomePage extends StatefulWidget {
  final List classNames;
  const MyclassHomePage({Key? key, required this.classNames}) : super(key: key);

  @override
  State<MyclassHomePage> createState() => _MyclassHomePageState();
}

class _MyclassHomePageState extends State<MyclassHomePage>
    with SingleTickerProviderStateMixin {
  PageController controller = PageController();
  late TabController Tabcontroller;

  late String dropdownValue;

  @override
  void initState() {
    super.initState();

    dropdownValue = (current_user_type == 'Student')
        ? current_user_class
        : (classNames.isNotEmpty)
            ? classNames[0]
            : '';
    print(dropdownValue);

    Tabcontroller = TabController(
        length: (current_user_type == 'Student') ? 4 : 5, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    Tabcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideMenu(),
      appBar: AppBar(
        // backgroundColor: Color(hexcolor("303952")),
        // title:DropDownTextField(
        //   textStyle: TextStyle(color: Colors.white,fontSize: 22),
        //   controller: _selectedclass,
        //   dropDownItemCount: Courses.length,
        //   dropDownList: Courses,
        //   clearOption: false,
        //   textFieldDecoration: InputDecoration(
        //     focusedBorder: OutlineInputBorder(
        //       borderSide: BorderSide(
        //         color: Colors.transparent,
        //       ),
        //     ),
        //     errorBorder:  OutlineInputBorder(
        //       borderSide: BorderSide(
        //         color: Colors.transparent
        //       ),
        //     ),
        //     enabledBorder: OutlineInputBorder(
        //       borderSide: BorderSide(
        //         color: Colors.transparent
        //       ),
        //     ),
        //   ),
        // ),
        title: (current_user_type == 'Student')
            ? Text(current_user_class)
            : Flexible(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  iconSize: 24,

                  elevation: 16,
                  underline: Container(
                    height: 2,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  items:
                      classNames.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style: TextStyle(fontSize: 18),),
                    );
                  }).toList(),
                ),
              ),
        actions: [
          NotificationIcon(),
          PopupButton(),
        ],
        bottom: TabBar(
          // labelColor: Colors.black,
          isScrollable: true,
          controller: Tabcontroller,
          // unselectedLabelColor: Colors.blueGrey,
          labelColor: Colors.white,
          tabs: (current_user_type == 'Student')
              ? [
                  Tab(
                    text: "Stream",
                    icon: Icon(Icons.view_stream_outlined),
                  ),
                  Tab(
                    text: "Chat",
                    icon: Icon(Icons.chat_outlined),
                  ),
                  Tab(
                    text: "People",
                    icon: Icon(Icons.people_alt_outlined),
                  ),
                  Tab(
                    text: "Classwork",
                    icon: Icon(Icons.event_note_outlined),
                  ),
                  // Tab(
                  //   text: "Attendance",
                  //   icon: Icon(Icons.analytics_outlined),
                  // ),
                ]
              : [
                  Tab(
                    text: "Stream",
                    icon: Icon(Icons.view_stream_outlined),
                  ),
                  Tab(
                    text: "Chat",
                    icon: Icon(Icons.chat_outlined),
                  ),
                  Tab(
                    text: "Students",
                    icon: Icon(Icons.people_alt_outlined),
                  ),
                  Tab(
                    text: "Classwork",
                    icon: Icon(Icons.event_note_outlined),
                  ),
                  // Tab(
                  //   text: "Attendance",
                  //   icon: Icon(Icons.analytics_outlined),
                  // ),
                  Tab(
                    text: "Details",
                    icon: Icon(Icons.edit),
                  ),
                ],
        ),
      ),
      body: tabBody(dropdownValue),
    );
  }

  TabBarView tabBody(String className) {
    return TabBarView(
      controller: Tabcontroller,
      children: (current_user_type == 'Student')
          ? [
              (className.isNotEmpty)
                  ? ClassStream(
                      className: className,
                      getKey: DateTime.now().toString(),
                    )
                  : Center(
                      child: Text('Class Not Found'),
                    ),
              // Text(dropdownValue),
              (className.isNotEmpty)
                  ? ClassChat(
                      getKey: DateTime.now().toString(),
                      className: className,
                    )
                  : Center(
                      child: Text('Class Not Found'),
                    ),

        People(dropdownValue: dropdownValue,),

        (className.isNotEmpty)
                  ? ClassAssignment(
                      className: className,
                      getKey: DateTime.now().toString(),
                    )
                  : Center(
                      child: Text('Class Not Found'),
                    ),

              // Center(
              //   child: Text("Attendance"),
              // ),
            ]
          : [
              (className.isNotEmpty)
                  ? ClassStream(
                      className: className,
                      getKey: DateTime.now().toString(),
                    )
                  : Center(
                      child: Text('Class Not Found'),
                    ),
              // Text(dropdownValue),
              (className.isNotEmpty)
                  ? ClassChat(
                      className: className,
                      getKey: DateTime.now().toString(),
                    )
                  : Center(
                      child: Text('Class Not Found'),
                    ),

               People(dropdownValue: dropdownValue,),
              (className.isNotEmpty)
                  ? ClassAssignment(
                      className: className,
                      getKey: DateTime.now().toString(),
                    )
                  : Center(
                      child: Text('Class Not Found'),
                    ),
              // Center(
              //   child: Text("Attendance"),
              // ),
              EditClass(
                dropdownValue: dropdownValue,
              ),
            ],
    );
  }

  Container NotFound() {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.height / 3,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: ExactAssetImage(
          'assets/images/ERROR !-PhotoRoom.png-PhotoRoom.png',
        ),
      )),
    );
  }
}
