import 'package:flutter/material.dart';
import 'map_page.dart';
import 'test_page.dart';
import 'report_page.dart';
Drawer buildDrawer(BuildContext context, String currentRoute) {
  return new Drawer(
    child: new ListView(
      children: <Widget>[
        const DrawerHeader(
          child: const Center(
            child: const Text("Look First Drive Later"),
          ),
        ),
        new ListTile(
          title: const Text("Map"),
          selected: currentRoute == MapPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, MapPage.route);
          },
        ),
        new ListTile(
          title: const Text('Report'),
          selected: currentRoute == ReportPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, ReportPage.route);
          },
        ),
        new ListTile(
          title: const Text('Test'),
          selected: currentRoute == TestPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, TestPage.route);
          },
        ),
      ],
    ),
  );
}
