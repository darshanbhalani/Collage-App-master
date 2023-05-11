import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_format/date_time_format.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp2/app/util/Functions.dart';
import '../../../../app/util/NotificationIcon.dart';
import '../../../../app/util/PopupButton.dart';

class AddNewEvent extends StatefulWidget {
  const AddNewEvent({Key? key}) : super(key: key);

  @override
  State<AddNewEvent> createState() => _AddNewEventState();
}

class _AddNewEventState extends State<AddNewEvent> {
  final _formkey = GlobalKey<FormState>();
  var _titlecontroller = TextEditingController();
  var _coordinatorcontroller = TextEditingController();
  var _aboutcontroller = TextEditingController();
  var _linkcontroller = TextEditingController();
  String lableDate = "";
  DateTime? _duedate;
  DateTime? _date;
  bool _link = false;
  PickedFile? _imagefile;
  String _photoUrl = "";
  final ImagePicker _picker = ImagePicker();

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    _titlecontroller.dispose();
    _coordinatorcontroller.dispose();
    _aboutcontroller.dispose();
    _linkcontroller.dispose();
    super.dispose();
  }

  Clear() {
    print(DateTime.now());
    _titlecontroller.clear();
    _coordinatorcontroller.clear();
    _aboutcontroller.clear();
    _linkcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add New Event"),
          actions: [
            NotificationIcon(),
            PopupButton(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Form(
            key: _formkey,
            child: ListView(
              children: [
                TFormField(
                    context, "Event Title", _titlecontroller, true, false),
                DateField(context, "Due Date", 2025),
                TFormField(context, "Coordinator", _coordinatorcontroller, true,
                    false),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter About of Event";
                    }
                  },
                  maxLines: 10,
                  controller: _aboutcontroller,
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
                    labelText: "About Event",
                    labelStyle: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                ListTile(
                  leading: Icon(Icons.link),
                  title: Text("Regestration Link"),
                  trailing: Switch.adaptive(
                    value: _link,
                    onChanged: (value) => setState(() {
                      this._link = value;
                    }),
                  ),
                ),
                Visibility(
                  visible: _link,
                  child: TFormField(context, "Registration Link",
                      _linkcontroller, true, false),
                ),
                Text("Chose Cover Photo "),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width * 0.6,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: _imagefile != null
                                  ? FileImage(File(_imagefile!.path))
                                      as ImageProvider
                                  : AssetImage("assets/images/Chose Image.jpg"),
                            ),
                            border: Border.all(color: Colors.grey)),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          BTN(context, Icons.upload, "Upload", Upload),
                          SizedBox(
                            height: 10,
                          ),
                          BTN(context, Icons.cancel, "Remove", Remove)
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 100)
              ],
            ),
          ),
        ),
        bottomSheet: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ButtonField(
              context, "Clear", Clear, "Submit", SubmitDetails, _formkey),
        ));
  }

  Upload() async {
    await takephoto(ImageSource.gallery);
  }

  Future takephoto(ImageSource source) async {
    final pickedfile = await _picker.getImage(
      source: source,
    );
    if (pickedfile != null) {
      setState(() {
        _imagefile = pickedfile;
        if (_imagefile == null) {
          print("Nullllllllllllllllll");
        } else if (_imagefile != null) {
          print("Nottttttttttttttttttttttt");
        }
      });
    }
  }

  Remove() {
    setState(() {
      _imagefile = null;
    });
  }

  DateField(context, String _label, int _end) {
    return Column(
      children: [
        InkWell(
          onTap: () async {
            _date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(_end),
            );
            setState(() {
              lableDate = DateTimeFormat.format(_date!,
                  format: AmericanDateFormats.dayOfWeek);
              _duedate = _date;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_date != null ? Text(lableDate) : Text(_label)],
              ),
            ),
          ),
        ),
        SizedBox(
          height: 15,
        )
      ],
    );
  }

  Future SubmitDetails() async {
    Loading(context);
    if (_imagefile!.path != null) {
      final _file = File(_imagefile!.path);

      final storageRef = await FirebaseStorage.instance.ref().child(
          'images/Events/CoverPhotos/${_titlecontroller.text.toString()}');
      storageRef.putFile(_file).whenComplete(() async {
        _photoUrl = await FirebaseStorage.instance
            .ref()
            .child(
                'images/Events/CoverPhotos/${_titlecontroller.text.toString()}')
            .getDownloadURL();
      }).then((value) async => await set());
    }
  }

  set() async {
    await FirebaseFirestore.instance
        .collection('Events')
        .doc(_titlecontroller.text)
        .set({
      "Cover Photo": _photoUrl,
      "Title": _titlecontroller.text,
      "Coordinator": _coordinatorcontroller.text,
      "About": _aboutcontroller.text,
      "Due Date": _duedate,
      "Creation Time": Timestamp.now(),
      "Link": _link ? _linkcontroller.text : null,
    }).whenComplete(() {
      Navigator.pop(context);
      SimpleSnackBar(context, "New Event Created.");
    });
  }
}

class UpdateEventDetails extends StatefulWidget {
  const UpdateEventDetails({Key? key}) : super(key: key);

  @override
  State<UpdateEventDetails> createState() => _UpdateEventDetailsState();
}

class _UpdateEventDetailsState extends State<UpdateEventDetails> {
  final _formkey = GlobalKey<FormState>();
  var _titlecontroller = TextEditingController();
  var _coordinatorcontroller = TextEditingController();
  var _aboutcontroller = TextEditingController();
  var _linkcontroller = TextEditingController();
  final _name = SingleValueDropDownController();
  String lableDate = "";
  DateTime? _duedate;
  DateTime? _date;
  bool _link = false;
  PickedFile? _imagefile;
  String _photoUrl = "";
  final ImagePicker _picker = ImagePicker();
  bool flag0 = false;
  bool flag1 = true;
  bool flag2 = false;
  List<String> eventNames = [];
  List<DropDownValueModel> eventList = [];

  @override
  void initState() {
    buildEventList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Event"),
        actions: [
          NotificationIcon(),
          PopupButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Form(
          key: _formkey,
          child: ListView(
            children: [
              Visibility(
                visible: flag1,
                child: DropField(
                    context, "Select Event Name", eventList, _name, true),
              ),
              Visibility(
                visible: !flag1,
                child: Column(
                  children: [
                    TFormField(
                        context, "Event Title", _titlecontroller, flag2, false),
                    // DateField(context, "Due Date", 2000, 2025),
                    TFormField(context, "Coordinator", _coordinatorcontroller,
                        flag2, false),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter About of Event";
                        }
                      },
                      maxLines: 10,
                      controller: _aboutcontroller,
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
                        labelText: "About Event",
                        labelStyle: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    ListTile(
                      enabled: flag2,
                      leading: Icon(Icons.link),
                      title: Text("Regestration Link"),
                      trailing: Switch.adaptive(
                        value: _link,
                        onChanged: flag2
                            ? (value) => setState(() {
                                  this._link = value;
                                })
                            : null,
                      ),
                    ),
                    Visibility(
                      visible: _link,
                      child: TFormField(context, "Registration Link",
                          _linkcontroller, flag2, false),
                    ),
                    Text("Chose Cover Photo "),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 150,
                            width: MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: _imagefile != null
                                      ? FileImage(File(_imagefile!.path))
                                          as ImageProvider
                                      : NetworkImage(_photoUrl),
                                ),
                                border: Border.all(color: Colors.grey)),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              BTN(context, Icons.upload, "Upload", Upload),
                              SizedBox(
                                height: 10,
                              ),
                              BTN(context, Icons.cancel, "Remove", Remove)
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomSheet: !flag1 && !flag2
          ? Delete_Update(context, Delete, Update)
          : BottomSheetButtons(context, _formkey, Next),
    );
  }

  Delete() {
    DeleteAccountPopUp(
        context,
        "Sure Do You want to Delete \'${_name.dropDownValue!.value}\' Event ?",
        del);
  }

  del() async {
    Navigator.pop(context);
    Loading(context);
    await FirebaseFirestore.instance
        .collection('Events')
        .doc(_name.dropDownValue!.value)
        .delete()
        .whenComplete(() {
      Navigator.pop(context);
      SimpleSnackBar(context, "Event Deleted.");
    });
  }

  Update() {
    setState(() {
      flag2 = !flag2;
    });
  }

  Next() async {
    Loading(context);
    if (flag1) {
      await FirebaseFirestore.instance
          .collection('Events')
          .doc(_name.dropDownValue!.value)
          .get()
          .then((value) {
        setState(() {
          _titlecontroller.text = value["Title"];
          _coordinatorcontroller.text = value["Coordinator"];
          _aboutcontroller.text = value["About"];
          if (value["Link"] != null) {
            flag0 = true;
            _link = true;
            _linkcontroller.text = value["Link"];
          }
          _photoUrl = value["Cover Photo"];
          flag1 = false;
        });
      });
      Navigator.pop(context);
    } else if (!flag1 && flag2) {
      await FirebaseFirestore.instance
          .collection('Events')
          .doc(_titlecontroller.text)
          .update({
        "Title": _titlecontroller.text,
        "Coordinator": _coordinatorcontroller.text,
        "About": _aboutcontroller.text,
        "Link": _link ? _linkcontroller.text : null,
      }).whenComplete(() {
        Navigator.pop(context);
        SimpleSnackBar(context, "Event Updated.");
      });
    } else {}
  }

  Upload() async {
    await takephoto(ImageSource.gallery);
  }

  Future takephoto(ImageSource source) async {
    final pickedfile = await _picker.getImage(
      source: source,
    );
    setState(() {
      _imagefile = pickedfile!;
    });
  }

  Remove() {
    setState(() {
      _imagefile = null;
    });
  }

  Future buildEventList() async {
    await FirebaseFirestore.instance
        .collection('Events')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          eventNames.add(doc["Title"]);
        });
      });
    });
    for (int i = 0; i < eventNames.length; i++) {
      setState(() {
        eventList.add(DropDownValueModel(
            name: "${eventNames[i]}", value: "${eventNames[i]}"));
      });
    }
  }
}

BTN(context, IconData _icon, String _lable, Function _function) {
  return InkWell(
    onTap: () async {
      await _function();
    },
    child: Container(
      height: 70,
      width: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Icon(_icon), Text(_lable)],
      ),
    ),
  );
}
