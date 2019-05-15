import 'dart:async';
import 'dart:math';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:lfdl_app/events.dart';
import 'package:lfdl_app/gps.dart';
import 'package:lfdl_app/server.dart';
import 'package:lfdl_app/utils.dart';
import 'package:flutter/material.dart';
import 'utils.dart';

class RoadEventMap {
  final controller = MapController();
  var roadEvents = List<RoadEvent>();
  RoadEvent selectedRoadEvent;
  LatLngBounds extendedBounds;
  ReportEvent reportEvent = ReportEvent();

  List<Polyline> get polylines =>
      roadEvents.map((event) => event.polyline).toList()..add(reportEvent.polyline);

  List<CircleMarker> get circleMarkers => reportEvent.points
      .map((point) => CircleMarker(
      point: point,
      radius: 5.0,
      color: Color(0xFF0F5F50)))
      .toList();

  Future<void> centerMap() async {
    final position = await GPS.location();
    controller.move(position, 15.0);
    await updateEvents(controller.bounds);
  }

  Future<void> selectEvent(LatLng tappedPoint) async {
    if (roadEvents.isNotEmpty) {
      double minDistance = smallestDistance(roadEvents.first, tappedPoint);
      selectedRoadEvent = roadEvents.reduce((closestEvent, event) {
        final eventMinDistance = smallestDistance(event, tappedPoint);
        if(eventMinDistance < minDistance) {
          minDistance = eventMinDistance;
          return event;
        } else {
          return closestEvent;
        }
      });
      reportEvent = selectedRoadEvent.toReportEvent();
      await updateEvents(controller.bounds);
    }
  }

Future<void> checkForUpdate(LatLngBounds bounds) {
  if (extendedBounds == null) {
    updateEvents(bounds);
  } else if (extendedBounds.containsBounds(bounds) == false) {
    updateEvents(bounds);
  }
}

Future<void> updateEventsa(LatLngBounds bounds) async {
  if (bounds.north - bounds.south < 10.0 &&
      bounds.west - bounds.east < 10.0) {
    updateEvents(bounds);
  } else {
//    roadEvents.clear();
  }
}

Future<void> updateEvents(LatLngBounds bounds) async {
  extendedBounds = extendBounds(bounds);
  final events = await Server.queryRoadEvents(
      extendedBounds.north, extendedBounds.east, extendedBounds.south,
      extendedBounds.west);
  print("Queried events: ${events.join("\n\t")}");
  if (selectedRoadEvent != null) {
    roadEvents.remove(selectedRoadEvent);
  }
  roadEvents = events;
}}
