import 'package:latlong/latlong.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:core';
import 'dart:developer';

class RoadEvent {
  RoadEvent(
      {this.startTime, this.endTime, this.polyline, this.type, this.severity});

  final DateTime startTime;
  final DateTime endTime;
  final List<LatLng> polyline;
  final EventType type;
  final Severity severity;

  Duration duration() => endTime.difference(startTime);

  //TODO: make this more efficient
  factory RoadEvent.fromJson(String json) {
    final jsonMap = jsonDecode(json);

    final DateTime startTime = DateTime.parse(jsonMap['startTime'] as String);
    final DateTime endTime = DateTime.parse(jsonMap['endTime'] as String);
    final List<LatLng> polyline = jsonToPolyline(
        jsonMap['polyline'].cast<String>());
    final EventType type = EventType.values
        .firstWhere((e) => e.toString() == jsonMap['type'] as String);
    final Severity severity = Severity.values
        .firstWhere((e) => e.toString() == jsonMap['severity'] as String);

    return RoadEvent(
        startTime: startTime,
        endTime: endTime,
        polyline: polyline,
        type: type,
        severity: severity);
  }

  @override
  bool operator ==(other) {
    other = other as RoadEvent;
    return startTime == other.startTime &&
        endTime == other.endTime &&
        polyline == other.polyline &&
        type == other.type &&
        severity == other.severity;
  }

  String toJson() {
    return jsonEncode(this);
//    , toEncodable: (value) {
//      if (value is DateTime) {  
//        return value.toIso8601String();
//      }
//      if(value is List<LatLng>) {
//        return value.map((latLng) => '(${latLng.latitude}, ${latLng.longitude}');
//      }
//      if(value is EventType || value is Severity) {
//        return value.toString();
//      }
//    });
  }

  @override
  String toString() => toJson();
}

LatLng stringToLatLng(String string) {
  final match = latLngMatcher.firstMatch(string);
  return LatLng(double.parse(match.group(1)), double.parse(match.group(2)));
}

List<LatLng> jsonToPolyline(List<String> json) {
  return json.map(stringToLatLng).toList();
}

const numberPattern = r'-?\d{1,3}(?:\.\d{1,9})?';

final latLngMatcher = RegExp('^\\(($numberPattern), ?($numberPattern)\\)\$');

//const eventColors = <EventType, Color> {
//  EventType.snow: Color()
//}

enum EventType { snow, ice, blackIce, slush }

enum Severity { low, medium, high }
