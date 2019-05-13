import 'package:flutter_map/flutter_map.dart';
import 'package:lfdl_app/gps.dart';
import 'package:flutter/widgets.dart';
import 'package:lfdl_app/events.dart';
import 'package:flutter/material.dart';
import '../drawer.dart';
import 'package:latlong/latlong.dart';
import 'package:lfdl_app/server.dart';
import 'package:lfdl_app/utils.dart';
import 'package:lfdl_app/widgets/map_app_bar.dart';
import 'package:lfdl_app/road_event_map.dart';


//Map display page
class MapPage extends StatefulWidget {
  @override
  State createState() => MapPageState();

  static const route = "/";
}

class MapPageState extends State<MapPage> {

  final roadEventMap = RoadEventMap();

  @override
  void initState() {
    super.initState();
//    roadEventMap.centerMap();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MapAppBar(roadEventMap: roadEventMap, title: "Map"),
      drawer: buildDrawer(context, MapPage.route),
      body: Scrollbar(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              child: FlutterMap(
                mapController: roadEventMap.controller,
                options: MapOptions(onPositionChanged: (position, hasGesture) async {
                  await roadEventMap.updateEvents(position);
                  setState(() {});
                }),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                  PolylineLayerOptions(
                    polylines: roadEventMap.polylines,
                  ),
                ],
              )
            ),
          ],
        ),
      )),
    );
  }
}
