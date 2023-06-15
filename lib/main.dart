import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp2/app/login/SplashScreen.dart';
import 'package:myapp2/app/util/Colors.dart';
import 'package:myapp2/app/util/ThemeData.dart';
// import 'app/util/Drawer/AdminPanel/AdminPanelPage.dart';
import 'services/firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AppHome());
}

ThemeManager _themeManager =ThemeManager();

class AppHome extends StatefulWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {

  @override
  void initState(){
    _themeManager.addListener((themeListener));
    setState(() {

    });
    super.initState();
  }

  themeListener(){
    if(mounted){
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "VSITR",
      theme: lightTheme,
      // darkTheme: darkTheme,
      // themeMode: _themeManager.themeMode,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      //home: const AdminPanelPage(),
    );
  }
}
