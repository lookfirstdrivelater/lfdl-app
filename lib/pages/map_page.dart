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
  final gps = GPS();
  final polylines = List<Polyline>();

  void addPolyline(List<LatLng> lines) {
    final polyline = Polyline(points: lines);
    polylines.add(polyline);
  }

  void center() async {
    final position = await gps.location();
    mapController.move(position, 10.0);
  }

  LatLng tappedPoint;
  List<LatLng> lines = List();

  void onTap(LatLng latLgn) {
    setState(() {
      tappedPoint = latLgn;
      lines.add(tappedPoint);
    });
  }

  void addRoadEvents(List<RoadEvent> events) {
    setState(() {
      for (RoadEvent event in events) {
        polylines.add(Polyline(points: event.polyline, color: eventColors[event.type]));
      }
    });
  }

  void onLongPressed(LatLng latLng) {
    setState(() {
      addPolyline(lines);
      lines = List();
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Map")),
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
                    onLongPress: onLongPressed,
                    onTap: onTap
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                  PolylineLayerOptions(
                    polylines: polylines,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const eventColors = <EventType, Color> {
  EventType.snow: Color(0xFFFFFFFF),
  EventType.blackIce: Color(0xFF000000),
  EventType.slush: Color(0xFFFFFF00),
  EventType.ice: Color(0xFF00FFFF)
};