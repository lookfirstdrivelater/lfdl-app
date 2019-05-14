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
  ReportMode mode = ReportMode.submitting;

  @override
  void initState() {
    super.initState();
    roadEventMap.centerMap().then((e) {
      setState(() {});
    });
  }

  void onTap(LatLng tappedPoint) {
    if (mode == ReportMode.submitting ||
        roadEventMap.selectedRoadEvent != null) {
      setState(() {
        roadEventMap.reportEvent.points.add(tappedPoint);
      });
    } else if (mode == ReportMode.editing) {
      setState(() {
        roadEventMap.selectEvent(tappedPoint);
      });
    }
  }

  void onRemoveRoadEvent() {
    if (roadEventMap.selectedRoadEvent != null) {
      showConfirmationDialog(
        context: context,
        title: "Remove Road Event",
        content: "Are you sure you want to remove the road event?",
        onYesPressed: () async {
          await Server.deleteRoadEvent(roadEventMap.selectedRoadEvent.id);
          roadEventMap.selectedRoadEvent = null;
          await roadEventMap.updateEvents(roadEventMap.controller.bounds);
          setState(() {
            roadEventMap.reportEvent = ReportEvent();
          });
        },
      );
    }
  }

  void onClearPointsPressed() {
    setState(() {
      roadEventMap.reportEvent.points = List();
    });
  }

  void onUndoPressed() {
    if (roadEventMap.reportEvent.points.isNotEmpty) {
      setState(() {
        roadEventMap.reportEvent.points.removeLast();
      });
    }
  }

  void onCancelPressed() {
    if (roadEventMap.selectedRoadEvent != null) {
      roadEventMap.roadEvents.add(roadEventMap.selectedRoadEvent);
    }
    setState(() {
      roadEventMap.selectedRoadEvent = null;
      roadEventMap.reportEvent = ReportEvent();
    });
  }

  void onSubmitEventPressed() {
    if (roadEventMap.reportEvent.points.length > 1) {
      showConfirmationDialog(
        context: context,
        title: "Create Event",
        content: "Are you sure you want to create the road event?",
        onYesPressed: () async {
          roadEventMap.reportEvent.startTime = DateTime.now().toUtc();
          await Server.uploadRoadEvent(roadEventMap.reportEvent);
          roadEventMap.selectedRoadEvent = null;
          await roadEventMap.updateEvents(roadEventMap.controller.bounds);
          setState(() {
            roadEventMap.reportEvent = ReportEvent();
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
    if (roadEventMap.reportEvent.points.length > 1 &&
        roadEventMap.selectedRoadEvent != null) {
      showConfirmationDialog(
        context: context,
        title: "Update Road Event",
        content: "Are you sure you want to update the road event?",
        onYesPressed: () async {
          roadEventMap.reportEvent.startTime = DateTime.now().toUtc();
          await Server.deleteRoadEvent(roadEventMap.selectedRoadEvent.id);
          await Server.uploadRoadEvent(roadEventMap.reportEvent);
          await roadEventMap.updateEvents(roadEventMap.controller.bounds);
          setState(() {
            roadEventMap.reportEvent = ReportEvent();
            roadEventMap.selectedRoadEvent = null;
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
                  value: roadEventMap.reportEvent.type,
                  onChanged: (type) {
                    setState(() {
                      roadEventMap.reportEvent.type = type;
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
                  value: roadEventMap.reportEvent.severity,
                  onChanged: (severity) {
                    setState(() {
                      roadEventMap.reportEvent.severity = severity;
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
                      if (roadEventMap.selectedRoadEvent != null) {
                        roadEventMap.selectedRoadEvent = null;
                        roadEventMap.reportEvent = ReportEvent();
                        roadEventMap.updateEvents(roadEventMap.controller.bounds);
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
                      roadEventMap.reportEvent = ReportEvent();
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
                      ..add(roadEventMap.reportEvent.polyline),
                  ),
                  CircleLayerOptions(
                    circles: roadEventMap.circleMarkers,
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
