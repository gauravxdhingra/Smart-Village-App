import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:smart_village/screens/dashboard/dashboard.dart';
import 'package:smart_village/screens/homepage/homepage.dart';
import 'package:smart_village/screens/settings/settings_screen.dart';

class PageViewHome extends StatefulWidget {
  PageViewHome({Key key}) : super(key: key);

  @override
  _PageViewHomeState createState() => _PageViewHomeState();
}

class _PageViewHomeState extends State<PageViewHome> {
  int index = 0;
  int selectedIndex = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Homepage(),
            DashboardScreen(),
            SettingsScreen(),
          ],
        ),
        bottomNavigationBar: FFNavigationBar(
          theme: FFNavigationBarTheme(
            barBackgroundColor: Colors.white,
            // selectedItemBorderColor: Colors.grey,
            selectedItemBackgroundColor: Colors.green,
            selectedItemIconColor: Colors.white,
            selectedItemLabelColor: Colors.black,
          ),
          selectedIndex: selectedIndex,
          onSelectTab: (index) {
            setState(() {
              selectedIndex = index;
              _pageController.jumpToPage(selectedIndex);
            });
          },
          items: [
            FFNavigationBarItem(
              iconData: Icons.home_filled,
              label: 'Home',
            ),
            FFNavigationBarItem(
              iconData: Icons.dashboard,
              label: 'Dashboard',
            ),
            FFNavigationBarItem(
              iconData: Icons.settings,
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
