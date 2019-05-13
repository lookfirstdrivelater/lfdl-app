import 'package:flutter_map/flutter_map.dart';
import 'package:lfdl_app/gps.dart';
import 'package:flutter/widgets.dart';
import 'package:lfdl_app/events.dart';
import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:lfdl_app/server.dart';
import 'package:lfdl_app/utils.dart';
import 'package:lfdl_app/widgets/map_app_bar.dart';

class RoadEventMap {
  final controller = MapController();
  final roadEvents = List<RoadEvent>();
  LatLngBounds bounds;

  List<Polyline> get polylines =>
      roadEvents.map((event) => event.polyline).toList();

  void centerMap() async {
    final position = await GPS.location();
    controller.move(position, 15.0);
  }

  Future<void> setBounds(LatLngBounds newBounds) async {
    bounds = extendBounds(newBounds);
    final events = await Server.queryRoadEvents(
        bounds.north, bounds.east, bounds.south, bounds.west);
    print("Queried events: ${events.join("\n\t")}");
    roadEvents.addAll(events);
  }

  Future<void> updateEvents(MapPosition position) async {
    if (bounds == null) {
      setBounds(position.bounds);
    } else if (bounds.containsBounds(position.bounds) == false) {
      if(bounds.north - bounds.south < 10.0 && bounds.west - bounds.east < 10.0) {
        setBounds(position.bounds);
      } else {
        roadEvents.clear();
      }
    }
  }
}
