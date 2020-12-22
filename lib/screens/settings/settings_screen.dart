import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _loading = true;
  bool _init = false;

  List tiles = [];

  @override
  void didChangeDependencies() {
    if (!_init) {
      tiles = [
        {
          "title": "Language",
          "icon": Icon(Icons.translate_outlined),
          "onPress": () {},
        },
        {
          "title": "Rate Us",
          "icon": Icon(Icons.star),
          "onPress": () {},
        },
        {
          "title": "Report Issue",
          "icon": Icon(Icons.message),
          "onPress": () {},
        },
        {
          "title": "About",
          "icon": Icon(Icons.info_outline),
          "onPress": () {},
        },
      ];
      setState(() {
        _loading = false;
        _init = true;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.settings),
          title: Text("Settings"),
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            ListTile(
              isThreeLine: true,
              leading: CircleAvatar(radius: 40),
              title: Text("Your Account"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Gaurav Dhingra"),
                  Text("+91 99999 99999"),
                ],
              ),
              trailing: IconButton(icon: Icon(Icons.edit), onPressed: () {}),
            ),
            for (int i = 0; i < tiles.length; i++)
              SettingsTile(
                title: tiles[i]["title"],
                icon: tiles[i]["icon"],
                onPress: tiles[i]["onPress"],
              ),
          ],
        ));
  }
}

class SettingsTile extends StatelessWidget {
  const SettingsTile({
    Key key,
    this.title,
    this.onPress,
    this.icon,
  }) : super(key: key);
  final String title;
  final Function onPress;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: icon,
      title: Text(title),
      onTap: () {
        onPress();
      },
    );
  }
}
