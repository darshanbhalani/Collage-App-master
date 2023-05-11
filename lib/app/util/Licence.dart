import 'package:flutter/material.dart';

class Licence extends StatelessWidget {
  const Licence({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("License and Agreement"),
      ),
      body: ListView(
        children: [
            ListTile(
                leading: Text("Version :",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold),),
                title: Text("0.01"),
            ),
          ListTile(
            leading: Text("Release Date :",style: TextStyle(fontSize:18,fontWeight: FontWeight.bold),),
            title: Text("01/01/2023"),
          ),
        ],
      ),
    );
  }
}
