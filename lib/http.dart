import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:lfdl_app/gps.dart';
import 'dart:convert';
import 'dart:io';
import 'road_event.dart';
import 'utils.dart';

//Wrapper class for sending and receiving data from server database
class Http {
  static HttpClient httpClient = new HttpClient();

  static const serverUrl = "https://stupidcpu.com/api";

  static Future<List<RoadEvent>> sendGetRequest(
      LatLng location, double radius) async {
    final url = "$serverUrl/events?location=${latLngToString(location)}&radius=$radius";
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    final reply = await response.transform(utf8.decoder).join();
    httpClient.close();

    return [RoadEvent.fromJson("")];
  }

  static String getPostRequestUrl(RoadEvent event) =>
      "$serverUrl/createevent?"
      "startTime=${event.startTime.toIso8601String()}&"
      "endTime=${event.endTime.toIso8601String()}&"
      "polyline=${pointsToString(event.points)}&"
      "severity=${severityToString(event.severity)}&"
      "top=${event.top()}&"
      "bottom=${event.bottom()}&"
      "right=${event.right()}&"
      "left=${event.left()}";

  static void sendPostRequest(RoadEvent event) async {
    final url = Http.getPostRequestUrl(event);
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    final reply = await response.transform(utf8.decoder).join();
    httpClient.close();
  }
}
