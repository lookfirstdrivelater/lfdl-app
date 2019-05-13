import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lfdl_app/utils.dart';
import 'package:lfdl_app/road_event_map.dart';

class MapAppBar extends AppBar {
  final RoadEventMap roadEventMap;

  MapAppBar({this.roadEventMap, String title})
      : super(title: Text(title), actions: <Widget>[
          FlatButton(
              onPressed: () => roadEventMap.centerMap(),
              child: Row(children: <Widget>[
                Icon(Icons.gps_fixed, color: Colors.white),
                Text(
                  "Center Map",
                  style: TextStyle(color: Colors.white),
                )
              ])),
        ]);
}
