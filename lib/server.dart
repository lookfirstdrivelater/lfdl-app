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

//  static const serverUrl = "http://172.31.19.210:8080";

  static Future<List<RoadEvent>> queryRoadEvents(
      double top, double right, double bottom, double left) async {
    final url =
        "$serverUrl/events/query?"
        "toplatitude=$top&"
        "rightlongitude=$right&"
        "bottomlatitude=$bottom&"
        "leftlongitude=$left";
    final reply = await sendPostRequest(url);
    final json = jsonDecode(reply);

    assert(json['message'] == null);

    assert(json['events'] != null);

    return (json['events'] as List).map((e) => RoadEvent.fromJson(e) as RoadEvent).toList();
  }

  static Future<String> deleteRoadEvent(int id) async {
    final url = "$serverUrl/events/delete?id=$id";
    return sendPostRequest(url);
  }

  static Future<String> sendPostRequest(String url) async {
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
//    httpClient.close();
    return await response.transform(utf8.decoder).join();
  }

  static Future<RoadEvent> uploadRoadEvent(ReportEvent reportEvent) async {
    final url = "$serverUrl/events/create?"
        "starttime=${reportEvent.startTime.toIso8601String()}&"
        "endtime=${reportEvent.endTime.toIso8601String()}&"
        "points=${pointsToString(reportEvent.points)}&"
        "type=${eventTypeToString(reportEvent.type)}&"
        "severity=${severityToString(reportEvent.severity)}&"
        "centerx=${reportEvent.centerX()}&"
        "centery=${reportEvent.centerY()}";
    final reply = await sendPostRequest(url);
    final json = jsonDecode(reply);

    if(json['message'] != null) {
      print("Upload Failed: ${json['message']}");
      print("Url: $url");
    }

    if(json['create'] == null) {
      print("Upload Failed: 'create' is null in json");
      print("Url: $url");
    }

    final roadEvent = RoadEvent.fromJson(json['create']);

    if(roadEvent != reportEvent) {
      print("Uploaded RoadEvent does not equal ReportEvent");
      print("RoadEvent: $roadEvent");
      print("ReportEvent: $reportEvent");
      print("Url: $url");
    } else {
      print("Sucessfully uploaded ReportEvent");
      print("RoadEvent: $roadEvent");
    }

    return roadEvent;
  }
}
