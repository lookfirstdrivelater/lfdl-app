import 'package:latlong/latlong.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:core';
import 'package:queries/collections.dart';

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
    final List<LatLng> polyline =
    stringListToPolyline(jsonMap['polyline'].cast<String>());
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
  bool operator ==(Object other) {
    if(other is RoadEvent) {
      if (!(startTime == other.startTime &&
          endTime == other.endTime &&
          type == other.type &&
          severity == other.severity)) return false;
      if (polyline.length != other.polyline.length) return false;
        for (int i = 0; i < polyline.length; i++) {
          if(polyline[i] != other.polyline[i]) return false;
        }
        return true;
    } else return false;
  }

  String toJson() {
    return '''
    {
        "startTime": "$startTime",
        "endTime": "$endTime",
        "polyline": ["${polylineToStringList(polyline).join('", "')}"],
        "type": "$type",
        "severity": "$severity"
    }
    ''';
  }

  @override
  String toString() =>
      "startTime: $startTime, endTime: $endTime, polyline: [${polyline.join(
          ", ")}], type: $type, severity: $severity";
}

LatLng stringToLatLng(String string) {
  final match = latLngMatcher.firstMatch(string);
  if(match == null) throw FormatException("Match not found in: $string");
  return LatLng(double.parse(match.group(1)), double.parse(match.group(2)));
}

List<LatLng> stringListToPolyline(List<String> json) {
  return json.map(stringToLatLng).toList();
}

String latLngToString(LatLng latLng) =>
    "(${latLng.latitude}, ${latLng.longitude})";

List<String> polylineToStringList(List<LatLng> polyline) =>
    polyline.map((latLng) => latLngToString(latLng)).toList();

const numberPattern = r'-?\d{1,3}(?:\.\d{1,9})?';

final latLngMatcher = RegExp('^\\(($numberPattern), ?($numberPattern)\\)\$');

//const eventColors = <EventType, Color> {
//  EventType.snow: Color()
//}

enum EventType { snow, ice, blackIce, slush }

enum Severity { low, medium, high }
