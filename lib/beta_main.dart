import 'package:flutter/material.dart';
import 'package:flutter_demos/views/LocalNotificationScreen.dart';

import 'configs/flavor_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlavorConfig(
      flavor: Flavor.BETA,
      flavorValues: FlavorValues(
        apiKey: "8jus7Ysj_83u&n30Yhd9_BETA",
        name: "Beta Flavor Build",
        colors: "828923",
        notificationmsg: "This Notification is send via BETA FLAVOR BUILD"
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
