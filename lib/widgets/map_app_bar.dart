import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lfdl_app/utils.dart';

class MapAppBar extends AppBar {
  final MapController mapController;

  MapAppBar({this.mapController, String title})
      : super(title: Text(title), actions: <Widget>[
          FlatButton(
              onPressed: () => centerMap(mapController),
              child: Row(children: <Widget>[
                Icon(Icons.gps_fixed, color: Colors.white),
                Text(
                  "Center Map",
                  style: TextStyle(color: Colors.white),
                )
              ])),
        ]);
}
