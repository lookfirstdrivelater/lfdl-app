import 'package:latlong/latlong.dart';
import 'dart:math';
import 'package:flutter_map/flutter_map.dart';
import 'gps.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';


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

DateTime parseDateString(String date) {
  return DateTime.parse(date);
}

LatLngBounds extendBounds(LatLngBounds bounds) {
  try {
    return LatLngBounds(add(bounds.sw, subtract(bounds.sw, bounds.ne)),
        add(bounds.ne, subtract(bounds.ne, bounds.sw)));
  } catch (e) {
    return bounds;
  }
}

LatLng subtract(LatLng point1, LatLng point2) => LatLng(point1.latitude - point2.latitude, point1.longitude - point2.longitude);

LatLng add(LatLng point1, LatLng point2) => LatLng(point1.latitude + point2.latitude, point1.longitude + point2.longitude);

LatLng multiply(LatLng point1, double scaler) => LatLng(point1.latitude * scaler, point1.longitude * scaler);

LatLng safeLatLng(double latitude, double longitude) => LatLng(max(min(latitude, -90.0), 90.0), max(min(longitude, -180.0), 180.0));

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

void showConfirmationDialog({BuildContext context, String title, String content, Function onYesPressed}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          FlatButton(
            child: Text("Yes"),
            onPressed: () {
              onYesPressed();
              Navigator.of(context).pop();
            }
          ),
          FlatButton(
            child: Text("No"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showErrorDialog({BuildContext context, String content}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text("Error"),
        content: Text(content),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          FlatButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              }
          ),
        ],
      );
    },
  );
}