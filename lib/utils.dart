import 'package:latlong/latlong.dart';
import 'dart:math';

final latLngMatcher = RegExp('\\(($numberPattern), ?($numberPattern)\\)');

List<LatLng> stringToPoints(String string) {
  final matches = latLngMatcher.allMatches(string);
  if (matches == null) throw FormatException("Match not found in: $string");
  return matches.map((match) => LatLng(double.parse(match.group(1)), double.parse(match.group(2)))).toList();
}

String latLngToString(LatLng latLng) =>
    "(${latLng.latitude}, ${latLng.longitude})";

String pointsToString(List<LatLng> list) =>
    "${list.map(latLngToString).join(", ")}";

const numberPattern = r'-?\d{1,3}(?:\.\d{1,9})?';

bool listEquals(List<dynamic> list1, List<dynamic> list2) {
  if (list1.length != list2.length) return false;
  for (int i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) return false;
  }
  return true;
}

final millisMatcher = RegExp(r'\.\d+[zZ]?');

DateTime parseDateString(String date) {
  final millisMatch = millisMatcher.firstMatch(date);
  String millis = millisMatch[0];
  millis = millis.substring(0, min(7, millis.length));
  return DateTime.parse(date.substring(0, millisMatch.start) + millis + date.substring(millisMatch.end));
}