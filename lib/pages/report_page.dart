import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lfdl_app/events.dart';
import '../drawer.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:lfdl_app/gps.dart';
import 'package:latlong/latlong.dart';



//Self-reporting page
class ReportPage extends StatefulWidget {

  @override
  State createState() => ReportPageState();

  static const route = "/report";
}

class ReportPageState extends State<ReportPage> {

  String currentCondition;
  String lastCondition;
  String currentSeverity;
  String lastSeverity;

  final mapController = MapController();
  final mapPolylines = List<Polyline>();
  final circles = List<CircleMarker>();

  @override
  void initState() {
    super.initState();
    centerMapOnLocation();
  }

  List<CircleMarker> emptyCircleMarkerList = List(0);

  List<CircleMarker> getCircleMarkers() {
    return reportEvent?.points
        ?.map((point) =>
        CircleMarker(point: point, radius: 10.0))
        ?.toList() ?? emptyCircleMarkerList;
  }

  void centerMapOnLocation() async {
    final position = await GPS.location();
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

  ReportEvent reportEvent;

  void onTap(LatLng latLgn) {
    if (reportEvent != null) {
      setState(() {
        reportEvent.points.add(latLgn);
      });
    }
  }

  void onStartRoadPressed() {
    if (reportEvent == null) {
      reportEvent = ReportEvent(
        points: List(),
        type: EventType.snow,
      );
      mapPolylines.add(reportEvent.polyline);
    }
  }

  void onEndRoadPressed() {
    if (reportEvent != null) {
      setState(() {
        reportEvent = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report"),
        actions: <Widget>[
          FlatButton(
            onPressed: centerMapOnLocation,
            child: Row (
              children: <Widget>[
                Icon(Icons.gps_fixed, color: Colors.white),
                Text(
                  "Center Map",
                  style: TextStyle(color: Colors.white),
                )
              ]
            )
          ),
        ],
      ),
      drawer: buildDrawer(context, ReportPage.route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: DropdownButton<String>(
                value: currentCondition,
                onChanged: (String newValue) {
                  setState(() {
                    lastCondition = currentCondition;
                    currentCondition = newValue;
                  });
                },
                items: <String>['Snow', 'Ice', 'Slush', 'Black Ice']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                })
                    .toList(),
                isExpanded: true,
                hint: Text("Select an event type")
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: DropdownButton<String>(
                value: currentSeverity,
                onChanged: (String newValue) {
                  setState(() {
                    lastSeverity = currentSeverity;
                    currentSeverity = newValue;
                  });
                },
                items: <String>['Low', 'Medium', 'High']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                })
                    .toList(),
                isExpanded: true,
                hint: Text("Select a severity")
              ),
            ),
            Text('Select a reporting area below', textAlign: TextAlign.left),
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
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget> [
                  FlatButton(
                    color: Colors.blue,
                    onPressed: (){
                      setState(() {
                        currentCondition = null;
                        lastCondition = null;
                        currentSeverity = null;
                        lastSeverity = null;
                      });
                    },
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.undo,
                          color: Colors.white,
                        ),
                        Text(
                          'Undo',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  FlatButton(
                    color: Colors.blue,
                    onPressed: (){
                      setState(() {
                        //TODO: Add submitting functionality
                      });
                    },
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        Text(
                          'Submit event',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ]
            ),
            Text("lastCondition: $lastCondition, lastSeverity: $lastSeverity")
          ],
        ),
      ),
    );
  }
}