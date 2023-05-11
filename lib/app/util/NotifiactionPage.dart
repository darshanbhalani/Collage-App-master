import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  NotificationService _notifationService =NotificationService();

  void initState() {
    _notifationService.initialiseNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
      ),
      body:Center(
        child: InkWell(
          onTap: (){
            _notifationService.sendNotification("Hello", "This is Notification............");
          },
          child: Container(
            height: 50,
            width: 100,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}

class NotificationService{
  final _notifications = FlutterLocalNotificationsPlugin();

  final _androidSettings = AndroidInitializationSettings("img");

  void initialiseNotification() async{
    final _initializationSettings= InitializationSettings(
      android: _androidSettings,
    );
     await _notifications.initialize(_initializationSettings);
  }


  void sendNotification(String _title,String _body) async{

    AndroidNotificationDetails _androidNotificationDetails = AndroidNotificationDetails(
      "channelId",
      "channelName",
        importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails _notificationDetails = NotificationDetails(
      android: _androidNotificationDetails,
    );

    await _notifications.show(
        0,
        _title,
        _body,
        _notificationDetails,
    );
  }
}