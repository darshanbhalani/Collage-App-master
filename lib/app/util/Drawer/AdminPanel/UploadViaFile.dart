import 'package:flutter/material.dart';

class UploadViaFile extends StatefulWidget {
  const UploadViaFile({Key? key}) : super(key: key);

  @override
  State<UploadViaFile> createState() => _UploadViaFileState();
}

class _UploadViaFileState extends State<UploadViaFile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Via File"),
      ),
      body: Center(
        child: Container(
          color: Colors.black,
          child: TextButton(
            onPressed: (){},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Text("Chose file",style:TextStyle(color: Colors.white),),
            ),
          ),
        ),
      ),
    );
  }
}
