import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:lfdl_app/gps.dart';
import 'dart:convert';
import 'dart:io';
import 'events.dart';
import 'utils.dart';
import 'dart:developer';


//Wrapper class for sending and receiving data from server database
class Server {
  static HttpClient httpClient = new HttpClient();

  static const serverUrl = "https://stupidcpu.com/api";

  static Future<List<RoadEvent>> queryRoadEvents(
      LatLng location, double radius) async {
    final url =
        "$serverUrl/events/query?location=${latLngToString(location)}&radius=$radius";
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    final reply = await response.transform(utf8.decoder).join();
    httpClient.close();



    final json = jsonDecode(reply);

    return [RoadEvent.fromJson(json['create'])];
  }

  static Future<RoadEvent> uploadRoadEvent(ReportEvent event) async {
    final url = "$serverUrl/events/create?"
        "starttime=${event.startTime.toIso8601String()}&"
        "endtime=${event.endTime.toIso8601String()}&"
        "points=${pointsToString(event.points)}&"
        "type=${eventTypeToString(event.type)}&"
        "severity=${severityToString(event.severity)}&"
        "centerx=${event.centerX()}&"
        "centery=${event.centerY()}";
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    final reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    final json = jsonDecode(reply);

    assert(json['message'] == null);

    assert(json['create'] != null);

    return RoadEvent.fromJson(json['create']);
  }
}
