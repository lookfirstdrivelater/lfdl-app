import 'package:latlong/latlong.dart';
import 'dart:convert';
//import 'package:json_annotation/json_annotation.dart';
//import 'package:json_serializable/type_helper.dart';
import 'package:convert/convert.dart';
import 'package:dson/dson.dart';

part 'RoadEvent.g.dart'; // this line is needed for the generator

@serializable
class RoadEvent extends _$RoadEventSerializable {
  RoadEvent(this.startTime, this.endTime, this.polyline, this.type, this.severity);
  final DateTime startTime;
  final DateTime endTime;
  final List<RoadLine> polyline;
  final List<EventType> type;
  final Severity severity;

  Duration duration() => endTime.difference(startTime);

  factory RoadEvent.fromJsonString(String json) => fromJson(json, RoadEvent);
  String toJsonString() => toJson(this);
}

@serializable
class RoadLine extends _$RoadLineSerializable {
  RoadPoint start;
  RoadPoint end;
}

@serializable
class RoadPoint extends _$RoadPointSerializable {
  double latitude;
  double longitude;
}

enum EventType {
  snow,
  ice,
  blackIce,
  slush
}

enum Severity {
  low,
  medium,
  high
}