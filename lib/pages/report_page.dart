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

//Self-reporting page
class ReportPage extends StatefulWidget {
  @override
  State createState() => ReportPageState();

  static const route = "/report";
}

class ReportPageState extends State<ReportPage> {
  final mapController = MapController();
  ReportEvent reportEvent = ReportEvent();
  final mapPolylines = <Polyline>[];

  @override
  void initState() {
    super.initState();
    centerMap(mapController);
    mapPolylines.add(reportEvent.polyline);
  }

  void onTap(LatLng latLgn) {
    setState(() {
      reportEvent.points.add(latLgn);
    });
  }

  void onUndoPressed() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MapAppBar(mapController: mapController,),
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
                            child: Text(camelCaseToSpaceCase(eventTypeToString(eventType))),
                          ))
                      .toList(),
                  isExpanded: true,
                  hint: Text("Select an event type")
              ),
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
                            child: Text(camelCaseToSpaceCase(severityToString(severity))),
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
                    polylines: mapPolylines,
                  ),
                  CircleLayerOptions(
                    circles: reportEvent?.points
                            ?.map((point) =>
                                CircleMarker(point: point, radius: 10.0))
                            ?.toList() ??
                        List(),
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
                onPressed: () async {
                  if(reportEvent.points.isNotEmpty) {
                    reportEvent.startTime = DateTime.now().toUtc();
                    final event = await Server.uploadRoadEvent(reportEvent);
                    setState(() {
                      reportEvent = ReportEvent();
                    });
                  }
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
            ]),
//            Text("lastCondition: $lastCondition, lastSeverity: $lastSeverity")
          ],
        ),
      ),
    );
  }
}
