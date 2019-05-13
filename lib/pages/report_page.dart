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
import 'package:lfdl_app/road_event_map.dart';

//Self-reporting page
class ReportPage extends StatefulWidget {
  @override
  State createState() => ReportPageState();

  static const route = "/report";
}

class ReportPageState extends State<ReportPage> {
  RoadEventMap roadEventMap = RoadEventMap();
  ReportEvent reportEvent = ReportEvent();

  @override
  void initState() {
    super.initState();
//    roadEventMap.centerMap();
  }

  void onTap(LatLng tappedPoint) {
    if (mode == ReportMode.submitting) {
      setState(() {
        reportEvent.points.add(tappedPoint);
      });
    } else if (mode == ReportMode.editing) {
      double minDistance = double.infinity;
      final selectedRoadEvent =
          roadEventMap.roadEvents.reduce((closestEvent, event) {
        final eventMinDistance = event.points.fold<double>(
            double.infinity,
            (minDistance, point) =>
                min(minDistance, distanceBetween(point, tappedPoint)));
        return eventMinDistance < minDistance ? event : closestEvent;
      });
      roadEventMap.roadEvents.remove(selectedRoadEvent);
      reportEvent = selectedRoadEvent.toReportEvent();
    }
  }

  ReportMode mode = ReportMode.submitting;

  int selectedRoadEventId;

  void onRemoveRoadEvent() {
    if (selectedRoadEventId != null) {
      setState(() {
        showConfirmationDialog(
          context: context,
          title: "Remove Road Event",
          content: "Are you sure you want to remove the road event?",
          onYesPressed: () {
            Server.deleteRoadEvent(selectedRoadEventId);
            selectedRoadEventId = null;
          },
        );
      });
    }
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
      showConfirmationDialog(
        context: context,
        title: "Create Event",
        content: "Are you sure you want to create the road event?",
        onYesPressed: () {
          reportEvent.startTime = DateTime.now().toUtc();
          Server.uploadRoadEvent(reportEvent);
          setState(() {
            reportEvent = ReportEvent();
          });
        },
      );
    } else {
      showErrorDialog(
        context: context,
        content: "There must be at least two points to upload event",
      );
    }
  }

  void onUpdateEventPressed() {
    if (reportEvent.points.length > 1) {
      showConfirmationDialog(
        context: context,
        title: "Update Road Event",
        content: "Are you sure you want to update the road event?",
        onYesPressed: () {
          reportEvent.startTime = DateTime.now().toUtc();
          Server.uploadRoadEvent(reportEvent);
          Server.deleteRoadEvent(selectedRoadEventId);
          setState(() {
            reportEvent = ReportEvent();
            selectedRoadEventId = null;
          });
        },
      );
    } else {
      showErrorDialog(
        context: context,
        content: "There must be at least two points to upload event",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MapAppBar(
        roadEventMap: roadEventMap,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  color: mode == ReportMode.editing ? Colors.grey : Colors.blue,
                  child:
                      Text("Submitting", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    setState(() {
                      mode = ReportMode.submitting;
                    });
                  },
                ),
                RaisedButton(
                  color: mode == ReportMode.editing ? Colors.blue : Colors.grey,
                  child: Text("Editing", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    setState(() {
                      mode = ReportMode.editing;
                    });
                  },
                ),
              ],
            ),
            Flexible(
              child: FlutterMap(
                mapController: roadEventMap.controller,
                options: MapOptions(
                    onTap: onTap,
                    onPositionChanged: (position, hasGesture) async {
                      await roadEventMap.updateEvents(position);
                      setState(() {});
                    }),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                  PolylineLayerOptions(
                    polylines: roadEventMap.polylines
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
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
            ]),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: mode == ReportMode.submitting
                    ? [
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
                      ]
                    : [
                        FlatButton(
                          color: Colors.blue,
                          onPressed: onRemoveRoadEvent,
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              Text(
                                'Remove Event',
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
                                Icons.update,
                                color: Colors.white,
                              ),
                              Text(
                                'Update Event',
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ]),
          ],
        ),
      ),
    );
  }
}

enum ReportMode { submitting, editing }
