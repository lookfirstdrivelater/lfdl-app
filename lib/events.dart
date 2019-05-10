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

  RoadEvent(
      {this.id,
      this.startTime,
      this.endTime,
      this.points,
      this.type,
      this.severity});

  factory RoadEvent.fromJson(Map<dynamic, dynamic> json) {
    assert(json['ID'] is int);
    assert(json['StartTime'] is String);
    assert(json['EndTime'] is String);
    assert(json['Points'] is String);
    assert(json['EventType'] is String);
    assert(json['Severity'] is String);
    final id = json['ID'];
    final startTime = parseDateString(json['StartTime']);
    final endTime = parseDateString(json['EndTime']);
    final points = stringToPoints(json['Points']);
    final type = stringToEventType(json['EventType']);
    final severity = stringToSeverity(json['Severity']);
    return RoadEvent(
        id: id,
        startTime: startTime,
        endTime: endTime,
        points: points,
        type: type,
        severity: severity);
  }

  Duration duration() => endTime.difference(startTime);

  Polyline get polyline =>
      Polyline(points: points, color: eventColors[type], strokeWidth: 3.0);

  ReportEvent toReportEvent() => ReportEvent()
    ..points = points
    ..startTime = startTime
    ..type = type
    ..severity = severity;

  @override
  bool operator ==(dynamic other) =>
      other is RoadEvent && id == other.id ||
      other is ReportEvent &&
          startTime == other.startTime &&
          endTime == other.endTime &&
          type == other.type &&
          severity == other.severity &&
          listEquals(points, other.points);

  @override
  String toString() =>
      'StartTime: $startTime, EndTime: $endTime, Points: ${pointsToString(points)}, Type: $type, Severity: $severity';
}

class ReportEvent {
  DateTime startTime;

  DateTime get endTime => startTime.add(severityDuration(severity));
  List<LatLng> points;
  EventType type;
  Severity severity;

  ReportEvent() {
    points = List();
    type = EventType.snow;
    severity = Severity.medium;
  }

  double centerX() =>
      points
          .map((latLng) => latLng.longitude)
          .reduce((acc, long) => acc + long) /
      points.length;

  double centerY() =>
      points.map((latLng) => latLng.latitude).reduce((acc, lat) => acc + lat) /
      points.length;

  Polyline get polyline =>
      Polyline(points: points, color: eventColors[type], strokeWidth: 5.0);

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

final _eventTypeStrings = EventType.values.map(_enumToString).toList();

final _eventTypeStringMap =
    Map.fromIterables(EventType.values, _eventTypeStrings);

final _stringEventTypeMap =
    Map.fromIterables(_eventTypeStrings, EventType.values);

String eventTypeToString(EventType eventType) => _eventTypeStringMap[eventType];

EventType stringToEventType(String string) => _stringEventTypeMap[string];

enum Severity { low, medium, high }

final _severityStrings = Severity.values.map(_enumToString).toList();

final _stringSeverityMap = Map.fromIterables(_severityStrings, Severity.values);

final _severityStringMap = Map.fromIterables(Severity.values, _severityStrings);

String severityToString(Severity severity) => _severityStringMap[severity];

Severity stringToSeverity(String string) => _stringSeverityMap[string];

final _severityDurationMap = Map.fromIterables(Severity.values,
    Severity.values.map((severity) => Duration(days: severity.index + 1)));

Duration severityDuration(Severity severity) => _severityDurationMap[severity];
