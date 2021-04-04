import 'package:flutter/material.dart';
import 'package:flutter_demos/views/LocalNotificationScreen.dart';

import 'configs/flavor_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
   FlavorConfig(
      flavor: Flavor.ALPHA,
      flavorValues: FlavorValues(
        apiKey: "8jus7Ysj_83uJVksj8&n30Yhd9",
        name: "Apha Build Version 10",
        colors: "828940",
        notificationmsg: "This Notification is send via Alpha Build"
      ));
  runApp(HomeApp());
}

class HomeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LocalNotificationScreen(),
    );
  }
}
