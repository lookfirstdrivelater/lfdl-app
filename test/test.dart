// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lfdl_app/road_event.dart';
import 'package:lfdl_app/main.dart';
import 'package:latlong/latlong.dart';

void main() {
  group('Road Event', () {
    final latLngStr1 = '(90.0, 180.0)';
    final latLngStr2 = '(-90, -180)';
    final latLngStr3 = '(0.123456789, 9.876543210)';
    final latLng1 = LatLng(90, 180);
    final latLng2 = LatLng(-90, -180);
    final latLng3 = LatLng(0.123456789, 9.876543210);

    test('LatLng Matching', () {
      expect(latLngMatcher.hasMatch(latLngStr1), true);
      expect(stringToLatLng(latLngStr1), latLng1);

      expect(latLngMatcher.hasMatch(latLngStr2), true);
      expect(stringToLatLng(latLngStr2), latLng2);

      expect(latLngMatcher.hasMatch(latLngStr3), true);
      expect(stringToLatLng(latLngStr3), latLng3);
    });

    test('String List to LatLng List', () {
      final List<String> list = <String>[latLngStr1, latLngStr2, latLngStr3];
      final List<LatLng> transformed = stringListToPolyline(list);
      expect(transformed, [latLng1, latLng2, latLng3]);
    });

    test('EventType to and from strings', () {
      final eventTypes = EventType.values;
      for(int i = 0; i < eventTypes.length; i++) {
        expect(stringToEventType[eventTypeStrings[i]], eventTypes[i]);
        expect(eventTypeToString[eventTypes[i]], eventTypeStrings[i]);
      }
    });

    test('Severity to and form strings', () {
      final severities = Severity.values;
      for(int i = 0; i < severities.length; i++) {
        expect(stringToSeverity[severityStrings[i]], severities[i]);
        expect(severityToString[severities[i]], severityStrings[i]);
      }
    });

    final roadEventJson =
    '''
          {
              "startTime": "${DateTime(2019).toIso8601String()}",
              "endTime": "${DateTime(2020).toString()}",
              "polyline": ["$latLngStr1", "$latLngStr2", "$latLngStr3"],
              "type": "snow",
              "severity": "low"
          }
          ''';

    final roadEvent = RoadEvent(
        startTime: DateTime(2019),
        endTime: DateTime(2020),
        polyline: [latLng1, latLng2, latLng3],
        type: EventType.snow,
        severity: Severity.low
    );

    test('JSON Deserialization', () {
      expect(RoadEvent.fromJson(roadEventJson), roadEvent);
    });

    test('JSON Serialization', () {
      expect(RoadEvent.fromJson(roadEvent.toJson()), roadEvent);
    });
  });
}
