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

//Map display page
class MapPage extends StatefulWidget {
  @override
  State createState() => MapPageState();

  static const route = "/";
}

class MapPageState extends State<MapPage> {

  final mapController = MapController();
  final mapPolylines = List<Polyline>();
  final circles = List<CircleMarker>();

  @override
  void initState() {
    super.initState();
    centerMap(mapController);
  }

  void addRoadEvents(List<RoadEvent> events) {
    setState(() {
      for (RoadEvent event in events) {
        mapPolylines.add(Polyline(
          points: event.points,
          color: eventColors[event.type],
          strokeWidth: 2.0,
        ));
      }
    });
  }

  ReportEvent reportEvent;

  void onTap(LatLng latLgn) {
    if (reportEvent != null) {
      setState(() {
        reportEvent.points.add(latLgn);
      });
    }
  }

  void onUndoPressed() {
    if (reportEvent != null) {
      setState(() {
        reportEvent.points.removeLast();
      });
    } else if (mapPolylines.length != 0) {
      setState(() {
        mapPolylines.removeLast();
      });
    }
  }

  void onPositionChanged(MapPosition position, bool hasGesture) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MapAppBar(mapController: mapController, title: "Map"),
      drawer: buildDrawer(context, MapPage.route),
      body: Scrollbar(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Flexible(
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                    onTap: onTap, onPositionChanged: onPositionChanged),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                  PolylineLayerOptions(
                    polylines: mapPolylines,
                  ),
                  CircleLayerOptions(),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
