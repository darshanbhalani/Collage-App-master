import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp2/app/login/SplashScreen.dart';
// import 'app/util/Drawer/AdminPanel/AdminPanelPage.dart';
import 'services/firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const AppHome());
}

class AppHome extends StatefulWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "VSITR",
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      //home: const AdminPanelPage(),
    );
  }
}
