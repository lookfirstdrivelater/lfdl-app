import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:lfdl_app/gps.dart';
import 'dart:convert';
import 'dart:io';
import '../drawer.dart';

//Class for testing incomplete features
class TestPage extends StatefulWidget {
  TestPage({Key key, this.title}) : super(key: key);

  final String title;

  static const String route = '/test';

  @override
  TestPageState createState() => TestPageState();
}



class TestPageState extends State<TestPage> {
  var httpResponse = "";

  final mapController = MapController();

  @override
  void initState() {
    super.initState();
    centerMap();
  }

  void _httpGetRequest() async {
    final url = "https://stupidcpu.com/api/ping";
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    final reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    setState(() {
      httpResponse = reply;
    });
  }

  void centerMap() async {
    final position = await GPS().location();
    mapController.move(LatLng(position.latitude, position.longitude), 15.0);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Test")),
      drawer: buildDrawer(context, TestPage.route),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            FlatButton(
              child: Text("Send Request"),
              onPressed: _httpGetRequest,
            ),
            FlatButton(
              child: Text("Center Map"),
              onPressed: centerMap,
            ),
            Text("Ping: $httpResponse"),
            Flexible(
                child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    center: LatLng(51.5, -0.09),
                    zoom: 5.0,
                  ),
                  layers: [
                    TileLayerOptions(
                        urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c']),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
