import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:lfdl_app/events.dart';
import 'package:lfdl_app/gps.dart';
import 'package:lfdl_app/road_event_map.dart';
import 'package:lfdl_app/server.dart';
import 'package:lfdl_app/utils.dart';

import '../drawer.dart';

//Map display page
class MapPage extends StatefulWidget {
  @override
  State createState() => MapPageState();

  static const route = "/";
}

class MapPageState extends State<MapPage> {
  final roadEventMap = RoadEventMap();
  Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      await roadEventMap.updateEvents(roadEventMap.controller.bounds);
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await roadEventMap.centerMap();
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> onTap(LatLng tappedPoint) async {
    await roadEventMap.selectEvent(tappedPoint);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Map"), actions: <Widget>[
        FlatButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: Text("Help"),
                  content: SingleChildScrollView(
                      child: Column(children: [
                    Text("This page is for viewing road events.\n"
                        "To view more information on a road event, simply tap on the map near the event you want to view and the information will be shown above\n"),
                  ])),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    FlatButton(
                        child: Text("Ok"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ],
                );
              },
            );
          },
          child: Row(children: <Widget>[
            Icon(Icons.help, color: Colors.white),
            Text(
              "Help",
              style: TextStyle(color: Colors.white),
            )
          ]),
        ),
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
      drawer: buildDrawer(context, MapPage.route),
      body: Scrollbar(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Column(
              children: roadEventMap.selectedRoadEvent != null
                  ? <Widget>[
                      Text(
                          "Type: ${camelCaseToSpaceCase(eventTypeToString(roadEventMap.selectedRoadEvent.type))}"),
                      Text(
                          "Severity: ${camelCaseToSpaceCase(severityToString(roadEventMap.selectedRoadEvent.severity))}"),
                      Text(
                          "Submitted Time: ${formatter.format(roadEventMap.selectedRoadEvent.startTime.toLocal())}"),
                      Text(
                          "Expire Time: ${formatter.format(roadEventMap.selectedRoadEvent.endTime.toLocal())}")
                    ]
                  : [],
            ),
            Flexible(
                child: FlutterMap(
              mapController: roadEventMap.controller,
              options: MapOptions(
                  onPositionChanged: (position, hasGesture) async {
                    await roadEventMap.checkForUpdate(position.bounds);
                    setState(() {});
                  },
                  onTap: onTap),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                PolylineLayerOptions(
                  polylines: roadEventMap.polylines,
                ),
                CircleLayerOptions(
                  circles: roadEventMap.circleMarkers,
                ),
              ],
            )),
            Image.asset('assets/map_legend.png'),
            // ...,
          ],
        ),
      )),
    );
  }
}
