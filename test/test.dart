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
import 'package:lfdl_app/utils.dart';
import 'package:lfdl_app/http.dart';

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
      expect(latLngMatcher.firstMatch(latLngStr1).group(0), latLngStr1);

      expect(latLngMatcher.hasMatch(latLngStr2), true);
      expect(latLngMatcher.firstMatch(latLngStr2).group(0), latLngStr2);

      expect(latLngMatcher.hasMatch(latLngStr3), true);
      expect(latLngMatcher.firstMatch(latLngStr3).group(0), latLngStr3);
    });

    test('String points to LatLng points', () {
      final String string = '"$latLngStr1, $latLngStr2, $latLngStr3"';
      final List<LatLng> transformed = stringToPoints(string);
      expect(transformed, [latLng1, latLng2, latLng3]);
    });

    test('EventType to and from strings', () {
      final eventTypes = EventType.values;
      for(int i = 0; i < eventTypes.length; i++) {
        expect(stringToEventType(eventTypeStrings[i]), eventTypes[i]);
        expect(eventTypeToString(eventTypes[i]), eventTypeStrings[i]);
      }
    });

    test('Severity to and form strings', () {
      final severities = Severity.values;
      for(int i = 0; i < severities.length; i++) {
        expect(stringToSeverity(severityStrings[i]), severities[i]);
        expect(severityToString(severities[i]), severityStrings[i]);
      }
    });

    final roadEvent = RoadEvent(
        startTime: DateTime.utc(2019),
        endTime: DateTime.utc(2020),
        points: [latLng1, latLng2, latLng3],
        type: EventType.snow,
        severity: Severity.low
    );

    final roadEventJson =
    '''
          {
              "StartTime": "${roadEvent.startTime}",
              "EndTime": "${roadEvent.endTime}",
              "Points": "${pointsToString(roadEvent.points)}",
              "Type": "${eventTypeToString(roadEvent.type)}",
              "Severity": "${severityToString(roadEvent.severity)}"
          }
    ''';


    test('JSON Deserialization', () {
      expect(RoadEvent.fromJson(roadEventJson), roadEvent);
    });

    test('JSON Serialization', () {
      expect(RoadEvent.fromJson(roadEvent.toJson()), roadEvent);
    });

    final roadEventUrl =
        '${Http.serverUrl}/createevent?'
        'startTime=${roadEvent.startTime}&'
        'endTime=${roadEvent.endTime}&'
        'points=${pointsToString(roadEvent.points)}&'
        'type=${eventTypeToString(roadEvent.type)}&'
        'severity=${severityToString(roadEvent.severity)}&'
        'top=${roadEvent.top()}&'
        'bottom=${roadEvent.bottom()}&'
        'right=${roadEvent.right()}&'
        'left=${roadEvent.left()}';

    test('Post Request Url', () {
//      expect()
    });
  });
}
