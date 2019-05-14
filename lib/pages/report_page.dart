import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:lfdl_app/events.dart';
import '../drawer.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:lfdl_app/server.dart';
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

  ReportMode mode = ReportMode.submitting;
  RoadEvent selectedRoadEvent;

  @override
  void initState() {
    super.initState();
    roadEventMap.centerMap().then((e) {
      setState(() {});
    });
  }

  void onTap(LatLng tappedPoint) {
    if (mode == ReportMode.submitting || selectedRoadEvent != null) {
      setState(() {
        reportEvent.points.add(tappedPoint);
      });
    } else if (mode == ReportMode.editing &&
        roadEventMap.roadEvents.isNotEmpty) {
      double minDistance = double.infinity;
      selectedRoadEvent = roadEventMap.roadEvents.reduce((closestEvent, event) {
        final eventMinDistance = event.points.fold<double>(
            double.infinity,
            (minDistance, point) =>
                min(minDistance, distanceBetween(point, tappedPoint)));
        return eventMinDistance < minDistance ? event : closestEvent;
      });
      setState(() {
        roadEventMap.roadEvents.remove(selectedRoadEvent);
        reportEvent = selectedRoadEvent.toReportEvent();
      });
    }
  }

  void onRemoveRoadEvent() {
    if (selectedRoadEvent != null) {
      showConfirmationDialog(
        context: context,
        title: "Remove Road Event",
        content: "Are you sure you want to remove the road event?",
        onYesPressed: () async {
          await Server.deleteRoadEvent(selectedRoadEvent.id);
          setState(() {
            selectedRoadEvent = null;
            reportEvent = ReportEvent();
          });
        },
      );
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

  void onCancelPressed() {
    if (selectedRoadEvent != null) {
      roadEventMap.roadEvents.add(selectedRoadEvent);
    }
    setState(() {
      reportEvent = ReportEvent();
    });
  }

  void onSubmitEventPressed() {
    if (reportEvent.points.length > 1) {
      showConfirmationDialog(
        context: context,
        title: "Create Event",
        content: "Are you sure you want to create the road event?",
        onYesPressed: () async {
          reportEvent.startTime = DateTime.now().toUtc();
          await Server.uploadRoadEvent(reportEvent);
          await roadEventMap.updateEvents(roadEventMap.controller.bounds);
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
    if (reportEvent.points.length > 1 && selectedRoadEvent != null) {
      showConfirmationDialog(
        context: context,
        title: "Update Road Event",
        content: "Are you sure you want to update the road event?",
        onYesPressed: () async {
          reportEvent.startTime = DateTime.now().toUtc();
          await Server.deleteRoadEvent(selectedRoadEvent.id);
          await Server.uploadRoadEvent(reportEvent);
          await roadEventMap.updateEvents(roadEventMap.controller.bounds);
          setState(() {
            reportEvent = ReportEvent();
            selectedRoadEvent = null;
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
      appBar: AppBar(title: Text("Report"), actions: <Widget>[
        FlatButton(
            onPressed: () {
              setState(() {
                roadEventMap.centerMap();
              });
            },
            child: Row(children: <Widget>[
              Icon(Icons.gps_fixed, color: Colors.white),
              Text(
                "Center Map",
                style: TextStyle(color: Colors.white),
              )
            ])),
      ]),
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
                      if (selectedRoadEvent != null) {
                        roadEventMap.roadEvents.add(selectedRoadEvent);
                        selectedRoadEvent = null;
                        reportEvent = ReportEvent();
                      }
                    });
                  },
                ),
                RaisedButton(
                  color: mode == ReportMode.editing ? Colors.blue : Colors.grey,
                  child: Text("Editing", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    setState(() {
                      mode = ReportMode.editing;
                      reportEvent = ReportEvent();
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
                      await roadEventMap.checkForUpdate(position.bounds);
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
              FlatButton(
                color: Colors.blue,
                onPressed: onCancelPressed,
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.cancel,
                      color: Colors.white,
                    ),
                    Text(
                      'Cancel',
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
                          onPressed: onUpdateEventPressed,
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
