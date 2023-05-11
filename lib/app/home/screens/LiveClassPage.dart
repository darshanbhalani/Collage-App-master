import 'package:flutter/material.dart';
import '../../../app/util/NotificationIcon.dart';
import '../../../app/util/PopupButton.dart';
import 'package:myapp2/app/util/Drawer/SideMenu.dart';

class LiveClassPage extends StatelessWidget {
  const LiveClassPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
          appBar: AppBar(
            title: Text("Live Class"),
            actions: [
              NotificationIcon(),
              PopupButton(),
            ],
          ),
          drawer: SideMenu(),
          body: TabBarView(
            children: [
              Center(
                child: Text(
                  "Comming Soon....",
                  style: TextStyle(fontSize: 30),
                ),
              )
            ],
          )),
    );
  }
}
