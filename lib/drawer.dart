import 'package:flutter/material.dart';
import 'package:lfdl_app/pages/map_page.dart';
import 'package:lfdl_app/pages/report_page.dart';
import 'package:lfdl_app/pages/about_page.dart';

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
          title: const Text('About'),
          selected: currentRoute == AboutPage.route,
          onTap: () {
            Navigator.pushReplacementNamed(context, AboutPage.route);
          },
        ),
      ],
    ),
  );
}
