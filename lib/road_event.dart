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
  final int id;
  final DateTime startTime;
  final DateTime endTime;
  final List<LatLng> points;
  final EventType type;
  final Severity severity;

  RoadEvent({this.id,
    this.startTime,
    this.endTime,
    this.points,
    this.type,
    this.severity});

  factory RoadEvent.fromJson(String json) {
    final jsonMap = jsonDecode(json);
    assert(jsonMap['Id'] is int);
    assert(jsonMap['StartTime'] is String);
    assert(jsonMap['EndTime'] is String);
    assert(jsonMap['Points'] is String);
    assert(jsonMap['Type'] is String);
    assert(jsonMap['Severity'] is String);
    return RoadEvent(
        id: jsonMap['Id'],
        startTime: DateTime.parse(jsonMap['StartTime']),
        endTime: DateTime.parse(jsonMap['EndTime']),
        points: stringToPoints(jsonMap['Points']),
        type: stringToEventType(jsonMap['Type']),
        severity: stringToSeverity(jsonMap['Severity']));
  }

  Duration duration() => endTime.difference(startTime);

  Polyline toPolyline() =>
      Polyline(points: points, color: eventColors[type], strokeWidth: 2.0);

  @override
  bool operator ==(dynamic other) =>
      other is RoadEvent &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          type == other.type &&
          severity == other.severity &&
          listEquals(points, other.points) ||
          other is ReportEvent &&
              startTime == other.startTime &&
              endTime == other.endTime &&
              type == other.type &&
              severity == other.severity &&
              listEquals(points, other.points);

  @override
  String toString() =>
      'StartTime: $startTime, EndTime: $endTime, Points: ${pointsToString(
          points)}, Type: $type, Severity: $severity';
}

class ReportEvent {
  DateTime startTime;
  DateTime endTime;
  List<LatLng> points;
  EventType type;
  Severity severity;

  ReportEvent({this.points, this.type, this.severity}) {
    startTime = DateTime.now();
    endTime = startTime.add(severityDuration(severity));
  }

  double centerX() =>
      points
          .map((latLng) => latLng.longitude)
          .reduce((acc, long) => acc + long) /
          points.length;

  double centerY() =>
      points.map((latLng) => latLng.latitude).reduce((acc, lat) => acc + lat) /
          points.length;

  Polyline toPolyline() =>
      Polyline(points: points, color: eventColors[type], strokeWidth: 2.0);
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

final _severityDurationMap = Map.fromIterables(Severity.values,
    Severity.values.map((severity) => Duration(days: severity.index + 1)));

Duration severityDuration(Severity severity) => _severityDurationMap[severity];
