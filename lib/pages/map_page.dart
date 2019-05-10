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
  final mapRoadEvents = Set<RoadEvent>();

  @override
  void initState() {
    super.initState();
    centerMap(mapController);
  }

  Future<void> updateMap(LatLngBounds bounds) async {
    final events = await Server.queryRoadEvents(
        bounds.north, bounds.east, bounds.south, bounds.west);
    print("Queried events: ${events.join("\n\t")}");
    setState(() {
      mapRoadEvents.addAll(events);
    });
  }

  void onPositionChanged(MapPosition position, bool hasGesture) async {
    await updateMap(position.bounds);
  }

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
                options: MapOptions(onPositionChanged: onPositionChanged),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                  PolylineLayerOptions(
                    polylines: mapRoadEvents.map((event) => event.polyline),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
