import 'package:cma_registrator/core/models/persistable/sql_field.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
enum FieldType {
  int,
  real,
  string,
  date;
  const FieldType();
  factory FieldType.from(String value) {
    return switch(value) {
      "int" => FieldType.int,
      "real" => FieldType.real,
      "date" => FieldType.date,
      _ => FieldType.string,
    };
  }
}
/// 
/// Model that holds data for [TextFormField] or [TextField].
class FieldData {
  final String id;
  final FieldType type;
  final String label;
  String _initialValue;
  String _value;
  final DatabaseField _record;
  /// 
  /// Model that holds data for [TextFormField] or [TextField].
  /// 
  ///   - [label] - text with which the target field will be labeled.
  ///   - [initialValue] - initial content of the target field. Also will be set to [value].
  ///   - [record] - database field from which we can read or to which we can write data.
  FieldData({
    required this.id,
    required this.label,
    required this.type, 
    required String initialValue, 
    required DatabaseField record,
  }) : _initialValue = initialValue, 
    _record = record, 
    _value = initialValue;
  /// 
  /// Initial content of the target field.
  String get initialValue => _initialValue;
  /// 
  /// Current content of the target field.
  String get value => _value;
  /// 
  /// Whether content of the target changed or not.
  bool get isChanged => _initialValue != _value;
  /// 
  /// Pull data from the database through provided [record].
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
  /// Persist data to the database through provided [record].
  Future<Result<String>> save() => 
    _record.persist(_value)
    .then((result) {
      if (!result.hasError) {
        _initialValue = _value;
      }
      return result;
    });
  /// 
  /// Set current [value] to its [initialState].
  void cancel() {
    _value = _initialValue;
  }
  /// 
  /// Set current [value] with provided [newValue].
  void update(String newValue) {
    _value = newValue;
  }
  ///
  FieldData copyWith({
    String? id,
    String? label,
    FieldType? type, 
    String? initialValue, 
    DatabaseField? record,
  }) {
    return FieldData(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label, 
      initialValue: initialValue ?? _initialValue, 
      record: record ?? _record,
    );
  }
}