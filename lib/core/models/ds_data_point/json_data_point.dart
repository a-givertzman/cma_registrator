import 'dart:convert';

import 'package:hmi_core/hmi_core.dart';
///
final class JsonDataPoint<T> implements DsDataPoint<T> {
  final Map<String, dynamic> _json;
  ///
  const JsonDataPoint({
    required Map<String, dynamic> json,
  }) : _json = json;
  //
  @override
  int get alarm => throw UnimplementedError();
  //
  @override
  int get history => throw UnimplementedError();
  //
  @override
  DsPointName get name => DsPointName(_json['name']);
  //
  @override
  DsStatus get status => DsStatus.ok;
  //
  @override
  String get timestamp => _json['timestamp'];
  //
  @override
  DsDataType get type => DsDataType.fromString(_json['type']);
  //
  @override
  T get value => switch(type) {
    DsDataType.real => double.parse(_json['value']) as T,
    DsDataType.integer || DsDataType.dInt || DsDataType.lInt || DsDataType.uInt || DsDataType.word => double.parse(_json['value']).toInt() as T,
    DsDataType.bool => double.parse(_json['value']).toInt() > 0 as T,
    DsDataType.time => DateTime.parse(_json['value']) as T,
    DsDataType.dateAndTime => DateTime.parse(_json['value']) as T,
  };
  //
  @override
  String toJson() {
    return json.encode(_json);
  }
}