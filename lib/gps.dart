

import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

//Wrapper class for getting location data on user
class GPS {
  static Future<LatLng> location() async {
    try {
      final location = await Location().getLocation();
      return LatLng(location.latitude, location.longitude);
    } catch (e) {
      if(e is MissingPluginException) {
        return LatLng(90.0, 90.0);
      }
      else throw e;
    }
  }
}