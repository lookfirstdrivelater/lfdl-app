import 'package:flutter_map/flutter_map.dart';
import 'package:lfdl_app/gps.dart';
import 'package:flutter/widgets.dart';
import 'package:lfdl_app/road_event.dart';
//Wrapper class for controlling the map display
class MapPage extends StatefulWidget {

  @override
  State createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  MapController _mapController;
  FlutterMap _map;
  GPS _gps;

  Map() {
    _mapController = MapController();
    _map = FlutterMap(mapController: _mapController);
    _gps = GPS();
  }

  void center() async {
    final position = await _gps.location();
    _mapController.move(position, 10.0);
  }

  void addLine(RoadLine line) {
    ;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap();
  }
}