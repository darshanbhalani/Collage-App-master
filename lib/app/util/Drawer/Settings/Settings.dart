import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myapp2/app/util/About.dart';
import 'package:myapp2/app/util/Licence.dart';
import 'package:myapp2/app/util/VariablesFile.dart';
import '../../../../app/util/PopupButton.dart';
import 'package:myapp2/app/util/Functions.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        actions: [
          PopupButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountInfo(),
                    ));
              },
              child: ListTile(
                leading: Icon(
                  Icons.abc,
                ),
                title: Text("Account & Info"),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
            InkWell(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => Notification(),
                //     ));
              },
              child: ListTile(
                leading: Icon(
                  Icons.notifications,
                ),
                title: Text("Notification"),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
            InkWell(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => Storage(),
                //     ));
              },
              child: ListTile(
                  leading: Icon(
                    Icons.storage,
                  ),
                  title: Text("Storage"),
                  trailing: Icon(Icons.chevron_right)),
            ),
            InkWell(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => Theme(),
                //     ));
              },
              child: ListTile(
                leading: Icon(
                  Icons.light_mode,
                ),
                title: Text("Theme"),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
            InkWell(
              onTap: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => About(),
                //     ));
              },
              child: ListTile(
                leading: Icon(
                  Icons.info,
                ),
                title: Text("About"),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Licence(),
                    ));
              },
              child: ListTile(
                leading: Icon(
                  Icons.file_copy_sharp,
                ),
                title: Text("License and Agreement"),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountInfo extends StatefulWidget {
  const AccountInfo({Key? key}) : super(key: key);

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account & Info"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileVisiblity(),
                    ));
              },
              child: ListTile(
                title: Text("Profile Visiblity"),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePassword(),
                    ));
              },
              child: ListTile(
                title: Text("Change Password"),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgotPassword(),
                    ));
              },
              child: ListTile(
                title: Text("Forgot Password"),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangeEmail(),
                    ));
              },
              child: ListTile(
                  title: Text("Change Email"),
                  trailing: Icon(Icons.chevron_right)),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePhoneNumber(),
                    ));
              },
              child: ListTile(
                title: Text("Change Phone Number"),
                trailing: Icon(Icons.chevron_right),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Notification extends StatefulWidget {
  const Notification({Key? key}) : super(key: key);

  @override
  State<Notification> createState() => _NotificationState();
}

class _NotificationState extends State<Notification> {
  late bool shownotification = true;
  late bool eventnotification = true;
  late bool requestnotification = true;
  late bool classroomnotification = true;
  late bool broadcastnotification = true;
  late bool liveclassnotification = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: ListView(
          children: [
            // SwitchField("Show Notifications",shownotification,true),
            ListTile(
              leading: Icon(Icons.notifications_active),
              title: Text("Show Notifications"),
              trailing: Switch.adaptive(
                value: shownotification,
                onChanged: (value) => setState(() {
                  this.shownotification = value;
                }),
              ),
            ),
            Divider(),
            ListTile(
              enabled: shownotification,
              title: Text("Customize Notification"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  SwitchField("Events", eventnotification, shownotification),
                  SwitchField("Request", requestnotification, shownotification),
                  SwitchField(
                      "Class Room", classroomnotification, shownotification),
                  SwitchField(
                      "Broadcast", broadcastnotification, shownotification),
                  SwitchField(
                      "Live Class", liveclassnotification, shownotification),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  SwitchField(_lable, _controller, _flag) {
    return ListTile(
      enabled: _flag,
      title: Text(_lable),
      trailing: Switch.adaptive(
        value: _controller,
        onChanged: _flag
            ? (value) => setState(() {
                  _controller = value;
                })
            : null,
      ),
    );
  }
}

class Storage extends StatefulWidget {
  const Storage({Key? key}) : super(key: key);

  @override
  State<Storage> createState() => _StorageState();
}

class _StorageState extends State<Storage> {
  late bool defaultpath = true;
  final _formkey = GlobalKey<FormState>();
  var _downloadpath = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Storage"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ListView(
          children: [
            ListTile(
              title: Text("Default Path for Download"),
              trailing: Switch.adaptive(
                value: defaultpath,
                onChanged: (value) => setState(() {
                  this.defaultpath = value;
                }),
              ),
            ),
            Form(
                key: _formkey,
                child: TFormField(context, "Custome Path", _downloadpath,
                    defaultpath == false, false))
          ],
        ),
      ),
    );
  }
}

class Theme extends StatefulWidget {
  const Theme({Key? key}) : super(key: key);

  @override
  State<Theme> createState() => _ThemeState();
}

class _ThemeState extends State<Theme> {
  late bool _defaultTheme = true;
  late bool _darkTheme = false;
  late bool requestnotification = true;
  late bool classroomnotification = true;
  late bool broadcastnotification = true;
  late bool liveclassnotification = true;
  String dropdownValue = 'Default';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Theme"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: ListView(
            children: [
              ListTile(
                title: Text("Default Theme"),
                trailing: Switch.adaptive(
                  value: _defaultTheme,
                  onChanged: (value) => setState(() {
                    _defaultTheme = value;
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text("Note : Default Theme use system theme."),
              ),
              Divider(),
              ListTile(
                enabled: _defaultTheme,
                title: Text("Dark Theme"),
                trailing: Switch.adaptive(
                  value: _darkTheme,
                  onChanged: _defaultTheme!
                      ? (value) => setState(() {
                            _darkTheme = value;
                          })
                      : null,
                ),
              ),
            ],
          ),
        ));
  }
}

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  var _currentpassword = TextEditingController();
  var _newpassword1 = TextEditingController();
  var _newpassword2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Change Password"),
        ),
        body: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            child: ListView(
              children: [
                TFormField(
                    context, "Currant Password", _currentpassword, true, true),
                TFormField(context, "New Password", _newpassword1, true, true),
                TFormField(
                    context, "Retype New Password", _newpassword2, true, true),
              ],
            ),
          ),
        ),
        bottomSheet: BottomSheetButtons(context, _formkey, Next));
  }

  Next() {
    Change_Password(
        context, _currentpassword.text, _newpassword1.text, _newpassword2.text);
  }
}

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Forgot Password"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: ListView(
            children: [
              InkWell(
                onTap: () {
                  // showDialog(context: context, builder: (context)=>AlertDialog(
                  //   TFormField(context,"Enter Your Registered Email",_controller,false,);
                  // ));
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => AccountInfo(),));
                },
                child: ListTile(
                  leading: Icon(
                    Icons.mail_outline_outlined,
                    color: Colors.blue,
                  ),
                  title: Text("Get Varification Code at Email"),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
              InkWell(
                onTap: () {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => AccountInfo(),));
                },
                child: ListTile(
                  leading: Icon(
                    Icons.phone_android_outlined,
                    color: Colors.blue,
                  ),
                  title: Text("Get Varification Code at Phone Number"),
                  trailing: Icon(Icons.chevron_right),
                ),
              ),
              ListTile(
                title: Text(
                    "Note : If You are not able to select any option then contact admin."),
              )
            ],
          ),
        ));
  }
}

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  State<ChangeEmail> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final _formkey = GlobalKey<FormState>();
  var _currentpassword = TextEditingController();
  var _newemail1 = TextEditingController();
  var _newemail2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Change Email"),
        ),
        body: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            child: ListView(
              children: [
                TFormField(
                    context, "Currant Password", _currentpassword, true, true),
                TFormField(context, "New Email", _newemail1, true, false),
                TFormField(
                    context, "Retype New Email", _newemail2, true, false),
                Text("Note : Varification Code will be send to new Email.")
              ],
            ),
          ),
        ),
        bottomSheet: BottomSheetButtons(context, _formkey, Next));
  }

  Next() {
    Change_Email(
        context, _currentpassword.text, _newemail1.text, _newemail2.text);
  }
}

class ChangePhoneNumber extends StatefulWidget {
  const ChangePhoneNumber({Key? key}) : super(key: key);

  @override
  State<ChangePhoneNumber> createState() => _ChangePhoneNumberState();
}

class _ChangePhoneNumberState extends State<ChangePhoneNumber> {
  final _formkey = GlobalKey<FormState>();
  var _currentpassword = TextEditingController();
  var _newenumber1 = TextEditingController();
  var _newenumber2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Change Phone Number"),
        ),
        body: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              child: ListView(
                children: [
                  TFormField(context, "Currant Password", _currentpassword,
                      true, true),
                  TFormField(
                      context, "New Phone Number", _newenumber1, true, false),
                  TFormField(context, "Retype New Phone Number", _newenumber2,
                      true, false),
                  Text(
                      "Note : Varification Code will be send to new Phone Number.")
                ],
              ),
            )),
        bottomSheet: BottomSheetButtons(context, _formkey, Next));
  }

  Next() {
    Change_Phoneno(
        context, _currentpassword.text, _newenumber1.text, _newenumber2.text);
  }
}

class ProfileVisiblity extends StatefulWidget {
  const ProfileVisiblity({Key? key}) : super(key: key);

  @override
  State<ProfileVisiblity> createState() => _ProfileVisiblityState();
}

class _ProfileVisiblityState extends State<ProfileVisiblity> {
  bool _flag1 = false;
  bool _flag2 = false;

  @override
  void initState() {
    super.initState();
    Check(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Visiblity"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: ListView(
          children: [
            ListTile(
              enabled: _flag1,
              title: Text("Profile Visiblity"),
              trailing: Switch.adaptive(
                value: _flag2,
                onChanged: _flag1
                    ? (value) {
                        setState(() {
                          _flag2 = value;
                          Loading(context);
                          set();
                        });
                      }
                    : null,
              ),
            ),
            Text("If Profile visiblity is off so Anyone can't see your profile")
          ],
        ),
      ),
    );
  }

  Check(context) async {
    // Loading(context);
    await FirebaseFirestore.instance
        .collection(current_user_type)
        .doc(current_user_enrollmentno)
        .get()
        .then((value) {
      setState(() {
        _flag2 = value["Show Profile"];
        _flag1 = true;
      });
    });
    // Navigator.pop(context);
  }

  set() async {
    await FirebaseFirestore.instance
        .collection(current_user_type)
        .doc(current_user_enrollmentno)
        .update({
      "Show Profile": _flag2,
    });
    Navigator.pop(context);
  }
}
