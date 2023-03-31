import 'package:cma_registrator/core/models/persistable/sql_record.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
class FieldData {
  final String label;
  String _initialValue;
  String _value;
  final SqlRecord _record;
  ///
  FieldData({
    required this.label, 
    required String initialValue, 
    required SqlRecord persistable,
  }) : _initialValue = initialValue, 
    _record = persistable, 
    _value = initialValue;
  ///
  String get initialValue => _initialValue;
  ///
  String get value => _value;
  ///
  bool get isUpdated => _initialValue != _value;
  ///
  Future<Result<String>> fetch() => 
    _record.fetch()
    .then((result) {
      if(!result.hasError) {
        _initialValue = result.data;
        _value = result.data;
      }
      return result;
    });
  ///
  Future<Result<String>> save() => 
    _record.persist(_value)
    .then((result) {
      if (!result.hasError) {
        _initialValue = _value;
      }
      return result;
    });
  ///
  void cancel() {
    _value = _initialValue;
  }
  ///
  void update(String value) {
    _value = value;
  }
}