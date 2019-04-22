import 'package:latlong/latlong.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:core';
import 'package:queries/collections.dart';
import 'utils.dart';
import 'dart:math';


class RoadEvent {
  DateTime startTime;
  DateTime endTime;
  List<LatLng> points;
  EventType type;
  Severity severity;

  RoadEvent(
      {this.startTime, this.endTime, this.points, this.type, this.severity});

  RoadEvent.fromJson(String json) {
    final jsonMap = jsonDecode(json);
    startTime = DateTime.parse(jsonMap['StartTime']);
    endTime = DateTime.parse(jsonMap['EndTime']);
    points = stringToPoints(jsonMap['Points']);
    type = stringToEventType(jsonMap['Type']);
    severity = stringToSeverity(jsonMap['Severity']);
  }

  Duration duration() => endTime.difference(startTime);

  double top() => points.fold(points[0].latitude, (acc, point) => max(acc, point.latitude));

  double bottom() => points.fold(points[0].latitude, (acc, point) => min(acc, point.latitude));

  double right() => points.fold(points[0].longitude, (acc, point) => max(acc, point.longitude));

  double left() => points.fold(points[0].longitude, (acc, point) => min(acc, point.longitude));

  Polyline toPolyline() =>
      Polyline(points: points, color: eventColors[type], strokeWidth: 2.0);

  @override
  bool operator ==(dynamic other) =>
      other is RoadEvent &&
      startTime == other.startTime &&
      endTime == other.endTime &&
      type == other.type &&
      severity == other.severity &&
      listEquals(points, other.points);

  String toJson() {
    return '''
    {
        "StartTime": "${startTime.toIso8601String()}",
        "EndTime": "${endTime.toIso8601String()}",
        "Points": "${pointsToString(points)}",
        "Type": "${eventTypeToString(type)}",
        "Severity": "${severityToString(severity)}"
    }
    ''';
  }

  @override
  String toString() =>
      'StartTime: $startTime, EndTime: $endTime, Points: ${pointsToString(points)}, Type: $type, Severity: $severity';
}

const eventColors = <EventType, Color>{
  EventType.snow: Color(0xFFFFFFFF),
  EventType.blackIce: Color(0xFF000000),
  EventType.slush: Color(0xFFFFFF00),
  EventType.ice: Color(0xFF00FFFF)
};

String _enumToString(dynamic enumeration) {
  final string = enumeration.toString();
  return string.substring(string.indexOf('.') + 1);
}

enum EventType { snow, ice, blackIce, slush }

final eventTypeStrings = EventType.values.map(_enumToString).toList();

final _eventTypeStringMap =
    Map.fromIterables(EventType.values, eventTypeStrings);

final _stringEventTypeMap =
    Map.fromIterables(eventTypeStrings, EventType.values);

String eventTypeToString(EventType eventType) => _eventTypeStringMap[eventType];

EventType stringToEventType(String string) => _stringEventTypeMap[string];

enum Severity { low, medium, high }

final severityStrings = Severity.values.map(_enumToString).toList();

final _stringSeverityMap = Map.fromIterables(severityStrings, Severity.values);

final _severityStringMap = Map.fromIterables(Severity.values, severityStrings);

String severityToString(Severity severity) => _severityStringMap[severity];

Severity stringToSeverity(String string) => _stringSeverityMap[string];
