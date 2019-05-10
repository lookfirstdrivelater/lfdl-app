import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lfdl_app/events.dart';
import '../drawer.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:lfdl_app/gps.dart';
import 'package:latlong/latlong.dart';
import 'package:lfdl_app/server.dart';
import 'package:lfdl_app/widgets/map_app_bar.dart';
import 'package:lfdl_app/utils.dart';
import 'dart:math';

//Self-reporting page
class ReportPage extends StatefulWidget {
  @override
  State createState() => ReportPageState();

  static const route = "/report";
}

class ReportPageState extends State<ReportPage> {
  final mapController = MapController();
  ReportEvent reportEvent = ReportEvent();
  final roadEvents = Set<RoadEvent>();

  @override
  void initState() {
    super.initState();
    centerMap(mapController);
  }

  void onTap(LatLng point) {
    setState(() {
      reportEvent.points.add(point);
    });
  }

  int selectedRoadEventId;

  void onLongTap(LatLng tappedPoint) {
    double minDistance = double.infinity;
    final selectedRoadEvent = roadEvents.reduce((closestEvent, event) {
      final eventMinDistance = event.points.fold<double>(
          double.infinity, (minDistance, point) =>
          min(minDistance, distanceBetween(point, tappedPoint)));
      return eventMinDistance < minDistance ? event : closestEvent;
    });
    roadEvents.remove(selectedRoadEvent);
    reportEvent = selectedRoadEvent.toReportEvent();
  }

  void onRemoveRoadEvent() {
    Server.deleteRoadEvent(selectedRoadEventId);

  }

  void onClearPointsPressed() {
    setState(() {
      reportEvent.points = List();
    });
  }

  void onUndoPressed() {
    if (reportEvent.points.isNotEmpty) {
      setState(() {
        reportEvent.points.removeLast();
      });
    }
  }

  void onSubmitEventPressed() {
    if (reportEvent.points.length > 1) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Upload Event"),
            content: Text("Are you sure you want to upload the road event?"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: Text("Yes"),
                onPressed: () {
                  reportEvent.startTime = DateTime.now().toUtc();
                  Server.uploadRoadEvent(reportEvent);
                  setState(() {
                    reportEvent = ReportEvent();
                  });
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text("Error"),
            content: Text("Must add at least 2 points to map to upload"),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MapAppBar(
        mapController: mapController,
        title: "Report",
      ),
      drawer: buildDrawer(context, ReportPage.route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: DropdownButton(
                  value: reportEvent.type,
                  onChanged: (type) {
                    setState(() {
                      reportEvent.type = type;
                    });
                  },
                  items: EventType.values
                      .map((eventType) => DropdownMenuItem(
                            value: eventType,
                            child: Text(camelCaseToSpaceCase(
                                eventTypeToString(eventType))),
                          ))
                      .toList(),
                  isExpanded: true,
                  hint: Text("Select an event type")),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: DropdownButton(
                  value: reportEvent.severity,
                  onChanged: (severity) {
                    setState(() {
                      reportEvent.severity = severity;
                    });
                  },
                  items: Severity.values
                      .map((severity) => DropdownMenuItem(
                            value: severity,
                            child: Text(camelCaseToSpaceCase(
                                severityToString(severity))),
                          ))
                      .toList(),
                  isExpanded: true,
                  hint: Text("Select a severity")),
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
                        roadEvents.map((event) => event.polyline).toList()
                          ..add(reportEvent.polyline),
                  ),
                  CircleLayerOptions(
                    circles: reportEvent.points
                        .map((point) => CircleMarker(
                            point: point,
                            radius: 5.0,
                            color: Color(0xFF0F5F50)))
                        .toList(),
                  )
                ],
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              FlatButton(
                color: Colors.blue,
                onPressed: onUndoPressed,
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
                onPressed: onClearPointsPressed,
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                    Text(
                      'Clear Points',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
              FlatButton(
                color: Colors.blue,
                onPressed: onSubmitEventPressed,
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
            ]),
//            Text("lastCondition: $lastCondition, lastSeverity: $lastSeverity")
          ],
        ),
      ),
    );
  }
}
