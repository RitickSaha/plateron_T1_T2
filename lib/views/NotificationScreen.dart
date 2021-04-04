import 'package:flutter/material.dart';
import 'package:flutter_demos/configs/flavor_config.dart';

class NotificationScreen extends StatefulWidget {
  //
  final String payload;

  NotificationScreen({this.payload});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications Screen'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              widget.payload,
              style: TextStyle(
                  color: FlavorConfig.config.flavor == Flavor.ALPHA
                      ? Colors.pink.withOpacity(0.1)
                      : FlavorConfig.config.flavor == Flavor.BETA
                          ? Colors.yellow.withOpacity(0.1)
                          : Colors.blue.withOpacity(0.1)),
            ),
            Text(
              widget.payload,
              style: TextStyle(
                color: FlavorConfig.config.flavor == Flavor.ALPHA
                    ? Colors.pink
                    : FlavorConfig.config.flavor == Flavor.BETA
                        ? Colors.yellow
                        : Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
