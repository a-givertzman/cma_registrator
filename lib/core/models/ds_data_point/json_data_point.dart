import 'dart:convert';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
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
  DsCot get cot => DsCot.fromString(_json['cot']);
  //
  @override
  T get value => switch(type) {
    DsDataType.real => _json['value'] as T,
    DsDataType.integer || DsDataType.dInt || DsDataType.lInt || DsDataType.uInt || DsDataType.word => _json['value'] as T,
    DsDataType.bool => _json['value'] > 0 as T,
    DsDataType.time => DateTime.fromMicrosecondsSinceEpoch(_json['value']) as T,
    DsDataType.dateAndTime => DateTime.fromMicrosecondsSinceEpoch(_json['value']) as T,
    DsDataType.string => _json['value'].toString() as T,
  };
  //
  @override
  String toJson() {
    return json.encode(_json);
  }
  //
  @override
  ResultF<DsDataPoint<T>> toResult() => switch(cot) {
    DsCot.act    ||
    DsCot.req    ||
    DsCot.inf    ||
    DsCot.reqCon ||
    DsCot.actCon => Ok(this),
    DsCot.reqErr || DsCot.actErr => Err(
      Failure(
        message: value, 
        stackTrace: 
        StackTrace.current,
      ),
    )
  };
}