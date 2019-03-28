import 'package:latlong/latlong.dart';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:json_serializable/type_helper.dart';

part 'RoadEvent.g.dart';

@JsonSerializable(nullable: false)
class RoadEvent {
  RoadEvent(this.startTime, this.endTime, this.polyline, this.type, this.severity);
  final DateTime startTime;
  final DateTime endTime;
  final List<RoadLine> polyline;
  final List<EventType> type;
  final Severity severity;

  factory RoadEvent.fromJson(Map<String, dynamic> json) => _$RoadEventFromJson(json);
  Map<String, dynamic> toJson() => _$RoadEventToJson(this);

  Duration duration() => endTime.difference(startTime);
}
@JsonSerializable(nullable: false)
class RoadLine {
  RoadLine(this.start, this.end);
  RoadPoint start;
  RoadPoint end;
}

@JsonSerializable(nullable: false)
class RoadPoint {
  RoadPoint(this.latitude, this.longitude);
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