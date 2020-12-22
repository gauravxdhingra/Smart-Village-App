import 'package:flutter/material.dart';
import 'package:smart_village/theme/theme.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key key}) : super(key: key);
  static const routeName = "notifications_screen";
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
            child: Text("New Updates"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.check, color: Themes.primaryColor),
            title: Text("Application Approved"),
            subtitle: Text("XYZ Textile Mill"),
            trailing: CircleAvatar(radius: 6),
          ),
          ListTile(
            leading: Icon(Icons.error_outline, color: Themes.primaryColor),
            title: Text("Documents Required"),
            subtitle: Text("ABC Construction and Builders"),
            trailing: CircleAvatar(radius: 6),
          ),
          ListTile(
            leading: Icon(Icons.check, color: Themes.primaryColor),
            title: Text("Application Successful"),
            subtitle: Text("ABC Hospital"),
            trailing: CircleAvatar(radius: 6),
          ),
        ],
      ),
    );
  }
}
