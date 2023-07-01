import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Functions.dart';

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
                            _title.clear();
                            _purpose.clear();
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
                            SubmitRequest(context,_title.text,_purpose.text);
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