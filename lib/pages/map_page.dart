import 'package:flutter_map/flutter_map.dart';
import 'package:lfdl_app/gps.dart';
import 'package:flutter/widgets.dart';
import 'package:lfdl_app/road_event.dart';
import 'package:flutter/material.dart';
import '../drawer.dart';
import 'package:latlong/latlong.dart';

//Map display page
class MapPage extends StatefulWidget {
  @override
  State createState() => MapPageState();

  static const route = "/";
}

class MapPageState extends State<MapPage> {
  final mapController = MapController();
  FlutterMap _map;
  GPS gps = GPS();

  void center() async {
    final position = await gps.location();
    mapController.move(position, 10.0);
  }

//  void addLine(RoadLine line) {
//    ;
//  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Home")),
      drawer: buildDrawer(context, MapPage.route),
      body: new Padding(
        padding: new EdgeInsets.all(8.0),
        child: new Column(
          children: [
            new Padding(
              padding: new EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: new Text("This is a map that is showing (51.5, -0.9)."),
            ),
            new Flexible(
              child: new FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: LatLng(51.5, -0.09),
                  zoom: 5.0,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
