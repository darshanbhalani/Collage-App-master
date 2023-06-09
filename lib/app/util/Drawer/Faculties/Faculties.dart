import 'package:flutter/material.dart';
import 'package:myapp2/app/util/Functions.dart';

class Faculties extends StatefulWidget {
  const Faculties({Key? key}) : super(key: key);

  @override
  State<Faculties> createState() => _FacultiesState();
}

class _FacultiesState extends State<Faculties> {
  bool isSearch = false;
  bool isBranch = false;
  String _branch = "";
  String _collection = "ID";
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Faculties"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearch = !isSearch;
                if (controller.text.isNotEmpty) {
                  controller.clear();
                }
              });
            },
            icon: isSearch ? Icon(Icons.search_off) : Icon(Icons.search),
          ),
          PopupMenuButton(
              icon: Icon(Icons.filter_alt_outlined),
              position: PopupMenuPosition.under,
              itemBuilder: ((context) {
                return [
                  PopupMenuItem(
                    child: const Text('Filter By Department'),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: isBranch && _branch == "Automobile"
                          ? Icon(Icons.check_box)
                          : Icon(Icons.check_box_outline_blank),
                      title: Text("Automobile"),
                    ),
                    onTap: () {
                      setState(() {
                        if (_branch == "Automobile") {
                          isBranch = false;
                          _branch = "";
                        } else {
                          isBranch = true;
                          _branch = "Automobile";
                          print(_branch);
                        }
                      });
                    },
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: isBranch && _branch == "Civil"
                          ? Icon(Icons.check_box)
                          : Icon(Icons.check_box_outline_blank),
                      title: Text("Civil"),
                    ),
                    onTap: () {
                      setState(() {
                        if (_branch == "Civil") {
                          isBranch = false;
                          _branch = "";
                        } else {
                          isBranch = true;
                          _branch = "Civil";
                          print(_branch);
                        }
                      });
                    },
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: isBranch && _branch == "Computer"
                          ? Icon(Icons.check_box)
                          : Icon(Icons.check_box_outline_blank),
                      title: Text("Computer"),
                    ),
                    onTap: () {
                      setState(() {
                        if (_branch == "Computer") {
                          isBranch = false;
                          _branch = "";
                        } else {
                          isBranch = true;
                          _branch = "Computer";
                          print(_branch);
                        }
                      });
                    },
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: isBranch && _branch == "Electrical"
                          ? Icon(Icons.check_box)
                          : Icon(Icons.check_box_outline_blank),
                      title: Text("Electrical"),
                    ),
                    onTap: () {
                      setState(() {
                        if (_branch == "Electrical") {
                          isBranch = false;
                          _branch = "";
                        } else {
                          isBranch = true;
                          _branch = "Electrical";
                          print(_branch);
                        }
                      });
                    },
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: isBranch && _branch == "IT"
                          ? Icon(Icons.check_box)
                          : Icon(Icons.check_box_outline_blank),
                      title: Text("IT"),
                    ),
                    onTap: () {
                      setState(() {
                        if (_branch == "IT") {
                          isBranch = false;
                          _branch = "";
                        } else {
                          isBranch = true;
                          _branch = "IT";
                          print(_branch);
                        }
                      });
                    },
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      leading: isBranch && _branch == "Mechenical"
                          ? Icon(Icons.check_box)
                          : Icon(Icons.check_box_outline_blank),
                      title: Text("Mechenical"),
                    ),
                    onTap: () {
                      setState(() {
                        if (_branch == "Mechenical") {
                          isBranch = false;
                          _branch = "";
                        } else {
                          isBranch = true;
                          _branch = "Mechenical";
                          print(_branch);
                        }
                      });
                    },
                  ),
                ];
              })),
        ],
      ),
      body: Column(
        children: [
          Visibility(
            visible: isSearch,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: TextFormField(
                  keyboardType: _collection == "Phone No"
                      ? TextInputType.phone
                      : TextInputType.name,
                  controller: controller,
                  onChanged: (value) {
                    if(_collection=="Email Id"){
                      controller.text = value.toLowerCase();
                    }else{
                      controller.text = value.toUpperCase();
                    }
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.teal,
                    )),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    )),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    labelText: "Search by ${_collection}",
                    labelStyle: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                trailing: PopupMenuButton(
                    position: PopupMenuPosition.under,
                    itemBuilder: ((context) {
                      return [
                        PopupMenuItem(
                          child: const Text('By ID'),
                          onTap: () {
                            setState(() {
                              _collection = "ID";
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: const Text('By First Name'),
                          onTap: () {
                            setState(() {
                              _collection = "First Name";
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: const Text('By Middle Name'),
                          onTap: () {
                            setState(() {
                              _collection = "Middle Name";
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: const Text('By Last Name'),
                          onTap: () {
                            setState(() {
                              _collection = "Last Name";
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: const Text('By Phone No'),
                          onTap: () {
                            setState(() {
                              _collection = "Phone No";
                            });
                          },
                        ),
                        PopupMenuItem(
                          child: const Text('By Email'),
                          onTap: () {
                            setState(() {
                              _collection = "Email Id";
                            });
                          },
                        ),
                      ];
                    })),
              ),
            ),
          ),
          Visibility(
            visible: controller.text.isEmpty && !isBranch,
              child:ListBoxInitial("Teacher"),
          ),
          Visibility(
            visible: controller.text.isNotEmpty && !isBranch,
            child:ListBox("Teacher",_collection, controller.text),
          ),
          Visibility(
            visible: controller.text.isEmpty && isBranch,
            child:ListBox("Teacher","Department", _branch),
          ),
        ],
      ),
    );
  }

}
