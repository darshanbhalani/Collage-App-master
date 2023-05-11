import 'package:flutter/material.dart';

import 'NotifiactionPage.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationPage(),
              ));
        },
        icon: Icon(Icons.notifications)
    );
  }
}
