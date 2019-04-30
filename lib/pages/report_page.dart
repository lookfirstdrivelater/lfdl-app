import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
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

  void center() async {
    final position = await GPS.location();
    mapController.move(position, 10.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report"),
        actions: <Widget>[
          FlatButton(
            onPressed: (){
              setState(() {
                currentCondition = null;
                lastCondition = null;
                currentSeverity = null;
                lastSeverity = null;
              });
            },
            padding: EdgeInsets.all(8.0),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Icon(Icons.add),
                Text('New event')
              ],
            ),
          ),
          FlatButton(
            onPressed: (){
              setState(() {
                //TODO: Add submitting functionality
              });
            },
            padding: EdgeInsets.all(8.0),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Icon(Icons.check),
                Text('Submit event')
              ],
            ),
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
                options: MapOptions(
                  center: LatLng(51.5, -0.09),
                  zoom: 5.0,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                ],
              ),
            ),
            Text("lastCondition: $lastCondition, lastSeverity: $lastSeverity")
          ],
        ),
      ),
    );
  }
}