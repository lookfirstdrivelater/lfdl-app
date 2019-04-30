import 'package:latlong/latlong.dart';

import 'package:location/location.dart';

//Wrapper class for getting location data on user
class GPS {
  static Future<LatLng> location() async {
    final location = await Location().getLocation();
    return LatLng(location.latitude, location.longitude);
  }
}