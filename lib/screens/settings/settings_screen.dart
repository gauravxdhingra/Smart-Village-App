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
          "title": "Acount Settings",
          "icon": Icon(Icons.account_circle_outlined),
          "onPress": () {},
        },
        {
          "title": "Language",
          "icon": Icon(Icons.translate_outlined),
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
      body: ListView.builder(
        itemBuilder: (context, i) => SettingsTile(
          title: tiles[i]["title"],
          icon: tiles[i]["icon"],
          onPress: tiles[i]["onPress"],
        ),
        itemCount: tiles.length,
      ),
    );
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
