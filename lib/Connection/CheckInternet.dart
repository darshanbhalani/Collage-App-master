import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class CheckInternetConnection extends GetxController {
  @override
  void onInit() {
    Connectivity().onConnectivityChanged.listen(checkConnectionStatus);
    super.onInit();
  }

  checkConnectionStatus(ConnectivityResult connectivityResult) async {
    if (connectivityResult == ConnectivityResult.none) {
      Get.to(NOInternetError());
    } else {
      Get.back();
    }
  }
}

class DependancyInjection {
  static void init() {
    Get.put<CheckInternetConnection>(CheckInternetConnection(),
        permanent: true);
  }
}

class NOInternetError extends StatefulWidget {
  const NOInternetError({Key? key}) : super(key: key);

  @override
  State<NOInternetError> createState() => _NOInternetErrorState();
}

class _NOInternetErrorState extends State<NOInternetError> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Exit ?"),
                content: Text(
                    "You cannot go to previous screen until internet will connect."),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancle")),
                  TextButton(
                      onPressed: () {
                        exit(0);
                      },
                      child: Text("Yes")),
                ],
              );
            });
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text("No Internet connection"),
        ),
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please check your",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "internet connection.",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 300,
              child: Image.asset(
                "assets/images/NoInternet.jpg",
                fit: BoxFit.fill,
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("Retry"),
                )),
          ],
        ),
      ),
    );
  }
}
