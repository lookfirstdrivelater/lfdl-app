import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class MapAppBar extends AppBar {
  final MapController mapController;

  MapAppBar({this.mapController}): super(actions: <Widget>[]);
}