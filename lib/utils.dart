import 'package:latlong/latlong.dart';
import 'dart:math';
import 'package:flutter_map/flutter_map.dart';
import 'gps.dart';

const numberPattern = r'-?\d{1,3}(?:\.\d+)?';

final latLngMatcher = RegExp('\\(($numberPattern), ?($numberPattern)\\)');

List<LatLng> stringToPoints(String string) {
  final matches = latLngMatcher.allMatches(string);
  if (matches == null) throw FormatException("Match not found in: $string");
  return matches
      .map((match) =>
          LatLng(double.parse(match.group(1)), double.parse(match.group(2))))
      .toList();
}

String latLngToString(LatLng latLng) =>
    "(${latLng.latitude}, ${latLng.longitude})";

String pointsToString(List<LatLng> points) =>
    "${points.map(latLngToString).join(", ")}";

bool listEquals(List<dynamic> list1, List<dynamic> list2) {
  if (list1.length != list2.length) return false;
  for (int i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) return false;
  }
  return true;
}

//final millisMatcher = RegExp(r'\.\d+[zZ]?');

DateTime parseDateString(String date) {
  return DateTime.parse(date);
}

void centerMap(MapController mapController) async {
  final position = await GPS.location();
  mapController.move(position, 15.0);
}

final capsMatcher = RegExp("[A-Z]");

String camelCaseToSpaceCase(String camelCase) =>
    camelCase[0].toUpperCase() +
    camelCase
        .substring(1)
        .replaceAllMapped(capsMatcher, (match) => " ${match[0]}");

double distanceBetween(LatLng point1, LatLng point2) => sqrt((point1.longitude -
            point2.longitude) *
        (point1.longitude - point2.longitude) +
    (point1.latitude - point2.latitude) * (point1.latitude - point2.latitude));

void showDialogBox() {

}