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
  final mapPolylines = List<Polyline>();
  final circles = List<CircleMarker>();

  @override
  void initState() {
    super.initState();
    centerMapOnLocation();
  }

  List<CircleMarker> emptyCircleMarkerList = List(0);

  List<CircleMarker> getCircleMarkers() {
    return roadEvent?.points
        ?.map((point) =>
        CircleMarker(point: point, radius: 10.0))
        ?.toList() ?? emptyCircleMarkerList;
  }

  void centerMapOnLocation() async {
    final position = await gps.location();
    mapController.move(position, 15.0);
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

  RoadEvent roadEvent;

  void onTap(LatLng latLgn) {
    if (roadEvent != null) {
      setState(() {
        roadEvent.points.add(latLgn);
      });
    }
  }

  void onStartRoadPressed() {
    if (roadEvent == null) {
      roadEvent = RoadEvent(
        points: List(),
        type: EventType.snow,
      );
      mapPolylines.add(roadEvent.toPolyline());
    }
  }

  void onEndRoadPressed() {
    if (roadEvent != null) {
      setState(() {
        roadEvent = null;
      });
    }
  }

  void onUndoPressed() {
    if (roadEvent != null) {
      setState(() {
//        circles.removeLast();
        roadEvent.points.removeLast();
      });
    } else if(mapPolylines.length != 0){
      mapPolylines.removeLast();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Map")),
      drawer: buildDrawer(context, MapPage.route),
      body: Scrollbar(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: Column(children: [
                  FlatButton(
                      onPressed: onStartRoadPressed,
                      child: Text("Start Road Event")),
                  FlatButton(
                      onPressed: onEndRoadPressed,
                      child: Text("End Road Event")),
                  FlatButton(
                    onPressed: onUndoPressed,
                    child: Text("Undo"),
                  ),
                  FlatButton(
                    onPressed: centerMapOnLocation,
                    child: Text("Center Around Person"),
                  ),
                ])),
            Flexible(
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(onTap: onTap),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                  PolylineLayerOptions(
                    polylines:
                        mapPolylines,
                  ),
                  CircleLayerOptions(
                      circles: getCircleMarkers())
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}