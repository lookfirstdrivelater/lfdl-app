import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:lfdl_app/gps.dart';
import 'dart:convert';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  static const String route = '/';

  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  var httpResponse = "";

  final mapController = MapController();

  @override
  void initState() {
    super.initState();
    _centerMap();
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

  void _centerMap() async {
    final position = await GPS().location();
    mapController.move(LatLng(position.latitude, position.longitude), 15.0);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
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
              onPressed: _centerMap,
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
