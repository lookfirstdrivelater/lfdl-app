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

  int snowCounter = 0;
  int iceCounter = 0;
  int slushCounter = 0;
  String currentCondition = "Snow";
  String lastCondition = "";
  String currentSeverity = "Low";
  String lastSeverity = "";

  final mapController = MapController();
  FlutterMap _map;
  GPS gps = GPS();

  void center() async {
    final position = await gps.location();
    mapController.move(position, 10.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.looks_one),
            tooltip: 'Report snow',
            onPressed: (){
              setState(() {
                snowCounter++;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.looks_two),
            tooltip: 'Report ice',
            onPressed: (){
              setState(() {
                iceCounter++;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.looks_3),
            tooltip: 'Report slush',
            onPressed: (){
              setState(() {
                slushCounter++;
              });
            },
          )
        ],
      ),
      drawer: buildDrawer(context, ReportPage.route),
      body: new Padding(
        padding: new EdgeInsets.all(8.0),
        child: new Column(
          children: [
            Padding(
              padding: new EdgeInsets.only(top: 8.0, bottom: 8.0),
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
              ),
            ),
            Padding(
              padding: new EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: DropdownButton<String>(
                value: currentSeverity,
                onChanged: (String newValue) {
                  setState(() {
                    lastSeverity = currentSeverity;
                    currentSeverity = newValue;
                  });
                },
//                items: List<DropdownMenuItem<String>> [
//                  DropdownMenuItem(
//                      value: ['Snow', 'Ice', 'Slush', 'Black Ice'],
//                      child: Text(['Snow', 'Ice', 'Slush', 'Black Ice'])
//                  )
//                ]
                items: <String>['Low', 'Medium', 'High']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                })
                    .toList(),
                isExpanded: true,
              ),
            ),
//            DropdownButton<Flexible>(
//              value:
//                Flexible(
//                  child: new FlutterMap(
//                    mapController: mapController,
//                    options: MapOptions(
//                      center: LatLng(51.5, -0.09),
//                      zoom: 5.0,
//                    ),
//                    layers: [
//                      TileLayerOptions(
//                          urlTemplate:
//                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                          subdomains: ['a', 'b', 'c']),
//                    ],
//                  ),
//                ),
//              items: [
//                DropdownMenuItem(
//                  value: Flexible(),
//                  child: FlutterMap(
//                    mapController: mapController,
//                    options: MapOptions(
//                      center: LatLng(51.5, -0.09),
//                      zoom: 5.0,
//                    ),
//                    layers: [
//                      TileLayerOptions(
//                          urlTemplate:
//                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                          subdomains: ['a', 'b', 'c']),
//                    ],
//                  ),
//                )
//              ],
//
//            ),

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
            Text("snow: $snowCounter, ice: $iceCounter, slush: $slushCounter, lastCondition: $lastCondition, lastSeverity: $lastSeverity")
          ],
        ),
      ),
    );
  }
}