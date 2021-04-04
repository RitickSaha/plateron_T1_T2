import 'package:flutter/material.dart';
import 'package:flutter_demos/configs/flavor_config.dart';
import 'package:flutter_demos/views/NotificationScreen.dart';
import 'package:flutter_demos/services/NotificationPlugin.dart';

class LocalNotificationScreen extends StatefulWidget {
  @override
  _LocalNotificationScreenState createState() =>
      _LocalNotificationScreenState();
}

enum NotificationType {
  normal,
  repeted,
  scheduled,
  attachment,
}

class _LocalNotificationScreenState extends State<LocalNotificationScreen> {
  //

  int count = 0;
  NotificationType _character = NotificationType.normal;
  @override
  void initState() {
    super.initState();
    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${FlavorConfig.config.flavor.toString().split(".")[1]} Local Notifications'),
      ),
      body: Center(
        child: Column(
          children: [
            ListTile(
              title: const Text('Normal Notificaiton'),
              leading: Radio(
                value: NotificationType.normal,
                groupValue: _character,
                onChanged: (NotificationType value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Repeting Notificaitons'),
              leading: Radio(
                value: NotificationType.repeted,
                groupValue: _character,
                onChanged: (NotificationType value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Scheduled Notifications'),
              leading: Radio(
                value: NotificationType.scheduled,
                groupValue: _character,
                onChanged: (NotificationType value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Attached Notificaiton'),
              leading: Radio(
                value: NotificationType.attachment,
                groupValue: _character,
                onChanged: (NotificationType value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            TextButton(
              onPressed: () async {
                switch (_character) {
                  case NotificationType.repeted:
                    await notificationPlugin.repeatNotification();
                    break;
                  case NotificationType.scheduled:
                    await notificationPlugin.scheduleNotification();
                    break;
                  case NotificationType.attachment:
                    await notificationPlugin.showNotificationWithAttachment();
                    break;
                  default:
                    await notificationPlugin.showNotification();
                    break;
                }
              },
              child: Text('Send Notification'),
            ),
          ],
        ),
      ),
    );
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }

  onNotificationClick(String payload) {
    Navigator.push(context, MaterialPageRoute(builder: (coontext) {
      return NotificationScreen(
        payload: payload,
      );
    }));
  }
}
