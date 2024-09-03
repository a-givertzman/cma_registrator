import 'package:cma_registrator/core/models/event/event.dart';
import 'package:hmi_core/hmi_core.dart';
///
class JsonEvent implements Event {
  final Map<String, dynamic> _json;
  ///
  const JsonEvent({
    required Map<String, dynamic> json,
  }) : _json = json;
  //
  @override
  int get id => _json['id'];
  //
  @override
  String get name => _json['event_id'];
  //
  @override
  DsStatus get status => DsStatus.fromValue(_json['status']);
  //
  @override
  String get timestamp => _json['timestamp'];
  //
  @override
  double get value => double.tryParse(_json['value']) ?? 0;
}