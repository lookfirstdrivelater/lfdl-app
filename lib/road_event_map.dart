import 'package:flutter_map/flutter_map.dart';
import 'package:lfdl_app/gps.dart';
import 'package:flutter/widgets.dart';
import 'package:lfdl_app/events.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:lfdl_app/server.dart';
import 'package:lfdl_app/utils.dart';
import 'dart:async';

class RoadEventMap {
  final controller = MapController();
  final roadEvents = List<RoadEvent>();
  LatLngBounds extendedBounds;

  List<Polyline> get polylines =>
      roadEvents.map((event) => event.polyline).toList();

  Future<void> centerMap() async {
    final position = await GPS.location();
    controller.move(position, 15.0);
    await updateEvents(controller.bounds);
  }

  Future<void> checkForUpdate(LatLngBounds bounds) {
    if (extendedBounds == null) {
      setExtendedBounds(bounds);
    } else if (extendedBounds.containsBounds(bounds) == false) {
      updateEvents(bounds);
    }
  }

  Future<void> updateEvents(LatLngBounds bounds) async {
    if(bounds.north - bounds.south < 10.0 && bounds.west - bounds.east < 10.0) {
      setExtendedBounds(bounds);
    } else {
      roadEvents.clear();
    }
  }

  Future<void> setExtendedBounds(LatLngBounds bounds) async {
    extendedBounds = extendBounds(bounds);
    final events = await Server.queryRoadEvents(
        extendedBounds.north, extendedBounds.east, extendedBounds.south, extendedBounds.west);
    print("Queried events: ${events.join("\n\t")}");
    roadEvents.addAll(events);
  }
}
