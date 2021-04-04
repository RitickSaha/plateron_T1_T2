import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_demos/configs/flavor_config.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' show File, Platform;
import 'package:http/http.dart' as http;

import 'package:rxdart/subjects.dart';

class NotificationPlugin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  // REQUIRES FOR IOS
  final BehaviorSubject<ReceivedNotification>
      didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  var initializationSettings;

  NotificationPlugin._() {
    init();
  }

  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    initializePlatformSpecifics();
  }

  initializePlatformSpecifics() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_notf_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        ReceivedNotification receivedNotification = ReceivedNotification(
            id: id, title: title, body: body, payload: payload);
        didReceivedLocalNotificationSubject.add(receivedNotification);
      },
    );

    initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
          alert: false,
          badge: true,
          sound: true,
        );
  }

  setListenerForLowerVersions(Function onNotificationInLowerVersions) {
    didReceivedLocalNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersions(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String payload) async {
        onNotificationClick(payload);
      },
    );
  }

  Future<void> showNotification() async {
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      "CHANNEL_DESCRIPTION",
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
      timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(20),
      FlavorConfig.config.flavorValues.name,
      FlavorConfig.config.flavorValues.notificationmsg,
      platformChannelSpecifics,
      payload: 'NORMAL_SCREEN_1',
    );
  }

  Future<void> repeatNotification() async {
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 3',
      'CHANNEL_NAME 3',
      "CHANNEL_DESCRIPTION 3",
      importance: Importance.Max,
      priority: Priority.High,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      Random().nextInt(20),
      FlavorConfig.config.flavorValues.name+"  REPETIVE",
      FlavorConfig.config.flavorValues.notificationmsg,
      RepeatInterval.EveryMinute,
      platformChannelSpecifics,
      payload: 'NORMAL_SCREEN_REPETIVE {"metadata: ADDED DATA,"id":93suos"}',
    );
  }

  Future<void> scheduleNotification() async {
    var scheduleNotificationDateTime = DateTime.now().add(Duration(seconds: 1));
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID1',
      'CHANNEL_NAME 1',
      "CHANNEL_DESCRIPTION 1",
      enableLights: true,
      color: Color(0xFFFF00C8),
      ledColor: Color(0xFFFF00C8),
      ledOnMs: 1000,
      ledOffMs: 500,
      channelShowBadge: true,
      importance: Importance.Max,
      priority: Priority.High,
      playSound: true,
      channelAction: AndroidNotificationChannelAction.Update,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosChannelSpecifics = IOSNotificationDetails(
      sound: 'my_sound.aiff',
    );
    var platformChannelSpecifics = NotificationDetails(
      androidChannelSpecifics,
      iosChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.schedule(
      Random().nextInt(20),
      FlavorConfig.config.flavorValues.name+"  SCHEDULED",
      FlavorConfig.config.flavorValues.notificationmsg,
      scheduleNotificationDateTime,
      platformChannelSpecifics,
      payload: 'SCHEDULED_NOTIFICATION_CALLBACK \n{"metadata: ADDED DATA,"id":93suos"}',
    );
  }

  Future<void> showNotificationWithAttachment() async {
    var attachmentPicturePath = await _downloadAndSaveFile(
        'https://via.placeholder.com/800x200', 'attachment_img.jpg');
    var iOSPlatformSpecifics = IOSNotificationDetails(
      attachments: [IOSNotificationAttachment(attachmentPicturePath)],
    );
    var bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(attachmentPicturePath),
      contentTitle: '<b>Attached Image</b>',
      htmlFormatContentTitle: true,
      summaryText: 'Test Image',
      htmlFormatSummaryText: true,
    );
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL ID 2',
      'CHANNEL NAME 2',
      'CHANNEL DESCRIPTION 2',
      importance: Importance.High,
      priority: Priority.High,
      styleInformation: bigPictureStyleInformation,
    );
    var notificationDetails =
        NotificationDetails(androidChannelSpecifics, iOSPlatformSpecifics);
    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(20),
      FlavorConfig.config.flavorValues.name+"  ATTACHED",
      FlavorConfig.config.flavorValues.notificationmsg,
      notificationDetails,
      payload: 'ATTACHED_NOTIFICATION_CALLBACK \n{"metadata: ADDED DATA,"id":93suos"}',
    );
  }

  _downloadAndSaveFile(String url, String fileName) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$fileName';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<int> getPendingNotificationCount() async {
    List<PendingNotificationRequest> p =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return p.length;
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}
