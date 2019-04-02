// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'road_event.dart';

// **************************************************************************
// DsonGenerator
// **************************************************************************

abstract class _$RoadEventSerializable extends SerializableMap {
  DateTime get startTime;
  DateTime get endTime;
  List<RoadLine> get polyline;
  List<EventType> get type;
  Severity get severity;

  Duration duration();
  String toJsonString();

  operator [](Object __key) {
    switch (__key) {
      case 'startTime':
        return startTime;
      case 'endTime':
        return endTime;
      case 'polyline':
        return polyline;
      case 'type':
        return type;
      case 'severity':
        return severity;
      case 'duration':
        return duration;
      case 'toJsonString':
        return toJsonString;
    }
    throwFieldNotFoundException(__key, 'RoadEvent');
  }

  operator []=(Object __key, __value) {
    switch (__key) {
    }
    throwFieldNotFoundException(__key, 'RoadEvent');
  }

  Iterable<String> get keys => RoadEventClassMirror.fields.keys;
}

abstract class _$RoadLineSerializable extends SerializableMap {
  RoadPoint get start;
  RoadPoint get end;
  set start(RoadPoint v);
  set end(RoadPoint v);

  operator [](Object __key) {
    switch (__key) {
      case 'start':
        return start;
      case 'end':
        return end;
    }
    throwFieldNotFoundException(__key, 'RoadLine');
  }

  operator []=(Object __key, __value) {
    switch (__key) {
      case 'start':
        start = fromSerialized(__value, () => new RoadPoint());
        return;
      case 'end':
        end = fromSerialized(__value, () => new RoadPoint());
        return;
    }
    throwFieldNotFoundException(__key, 'RoadLine');
  }

  Iterable<String> get keys => RoadLineClassMirror.fields.keys;
}

abstract class _$RoadPointSerializable extends SerializableMap {
  double get latitude;
  double get longitude;
  set latitude(double v);
  set longitude(double v);

  operator [](Object __key) {
    switch (__key) {
      case 'latitude':
        return latitude;
      case 'longitude':
        return longitude;
    }
    throwFieldNotFoundException(__key, 'RoadPoint');
  }

  operator []=(Object __key, __value) {
    switch (__key) {
      case 'latitude':
        latitude = __value;
        return;
      case 'longitude':
        longitude = __value;
        return;
    }
    throwFieldNotFoundException(__key, 'RoadPoint');
  }

  Iterable<String> get keys => RoadPointClassMirror.fields.keys;
}

// **************************************************************************
// MirrorsGenerator
// **************************************************************************

_RoadEvent__Constructor([positionalParams, namedParams]) => new RoadEvent(
    positionalParams[0],
    positionalParams[1],
    positionalParams[2],
    positionalParams[3],
    positionalParams[4]);
_RoadEvent_fromJsonString_Constructor([positionalParams, namedParams]) =>
    new RoadEvent.fromJsonString(positionalParams[0]);

const $$RoadEvent_fields_startTime =
    const DeclarationMirror(name: 'startTime', type: DateTime, isFinal: true);
const $$RoadEvent_fields_endTime =
    const DeclarationMirror(name: 'endTime', type: DateTime, isFinal: true);
const $$RoadEvent_fields_polyline = const DeclarationMirror(
    name: 'polyline', type: const [List, RoadLine], isFinal: true);
const $$RoadEvent_fields_type = const DeclarationMirror(
    name: 'type', type: const [List, EventType], isFinal: true);
const $$RoadEvent_fields_severity =
    const DeclarationMirror(name: 'severity', type: Severity, isFinal: true);

const RoadEventClassMirror =
    const ClassMirror(name: 'RoadEvent', constructors: const {
  '': const FunctionMirror(
      name: '',
      positionalParameters: const [
        const DeclarationMirror(
            name: 'startTime', type: DateTime, isRequired: true),
        const DeclarationMirror(
            name: 'endTime', type: DateTime, isRequired: true),
        const DeclarationMirror(
            name: 'polyline', type: const [List, RoadLine], isRequired: true),
        const DeclarationMirror(
            name: 'type', type: const [List, EventType], isRequired: true),
        const DeclarationMirror(
            name: 'severity', type: Severity, isRequired: true)
      ],
      $call: _RoadEvent__Constructor),
  'fromJsonString': const FunctionMirror(
      name: 'fromJsonString',
      positionalParameters: const [
        const DeclarationMirror(name: 'json', type: String, isRequired: true)
      ],
      $call: _RoadEvent_fromJsonString_Constructor)
}, fields: const {
  'startTime': $$RoadEvent_fields_startTime,
  'endTime': $$RoadEvent_fields_endTime,
  'polyline': $$RoadEvent_fields_polyline,
  'type': $$RoadEvent_fields_type,
  'severity': $$RoadEvent_fields_severity
}, getters: const [
  'startTime',
  'endTime',
  'polyline',
  'type',
  'severity'
], methods: const {
  'duration': const FunctionMirror(
    name: 'duration',
    returnType: Duration,
  ),
  'toJsonString': const FunctionMirror(
    name: 'toJsonString',
    returnType: String,
  )
});

_RoadLine__Constructor([positionalParams, namedParams]) => new RoadLine();

const $$RoadLine_fields_start =
    const DeclarationMirror(name: 'start', type: RoadPoint);
const $$RoadLine_fields_end =
    const DeclarationMirror(name: 'end', type: RoadPoint);

const RoadLineClassMirror = const ClassMirror(
    name: 'RoadLine',
    constructors: const {
      '': const FunctionMirror(name: '', $call: _RoadLine__Constructor)
    },
    fields: const {
      'start': $$RoadLine_fields_start,
      'end': $$RoadLine_fields_end
    },
    getters: const [
      'start',
      'end'
    ],
    setters: const [
      'start',
      'end'
    ]);

_RoadPoint__Constructor([positionalParams, namedParams]) => new RoadPoint();

const $$RoadPoint_fields_latitude =
    const DeclarationMirror(name: 'latitude', type: double);
const $$RoadPoint_fields_longitude =
    const DeclarationMirror(name: 'longitude', type: double);

const RoadPointClassMirror =
    const ClassMirror(name: 'RoadPoint', constructors: const {
  '': const FunctionMirror(name: '', $call: _RoadPoint__Constructor)
}, fields: const {
  'latitude': $$RoadPoint_fields_latitude,
  'longitude': $$RoadPoint_fields_longitude
}, getters: const [
  'latitude',
  'longitude'
], setters: const [
  'latitude',
  'longitude'
]);
