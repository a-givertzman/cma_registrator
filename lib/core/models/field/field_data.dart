import 'package:cma_registrator/core/models/field/field_type.dart';
import 'package:cma_registrator/core/models/persistable/database_field.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
/// 
/// Model that holds data for [TextFormField] or [TextField].
class FieldData {
  final String id;
  final FieldType type;
  final String label;
  String _initialValue;
  final DatabaseField _record;
  final TextEditingController _controller; 
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
    _controller = TextEditingController(text: initialValue);
  /// 
  /// Initial content of the target field.
  String get initialValue => _initialValue;
  /// 
  /// Controller for FormField's.
  TextEditingController get controller => _controller;
  /// 
  /// Whether content of the target changed or not.
  bool get isChanged => _initialValue != _controller.text;
  /// 
  /// Pull data from the database through provided [record].
  Future<ResultF<String>> fetch() => 
    _record.fetch()
    .then((result) {
      if(result case Ok(value:final data)) {
        _initialValue = data;
        _controller.text = data;
      }
      return result;
    });
  /// 
  /// Persist data to the database through provided [record].
  Future<ResultF<String>> save() => 
    _record.persist(_controller.text)
    .then((result) {
      if (result case Ok()) {
        refreshWith(_controller.text);
      }
      return result;
    });
  ///
  /// Sets initialValue to provided value.
  void refreshWith(String text) {
    _initialValue = text;
  }
  /// 
  /// Set current [value] to its [initialState].
  void cancel() {
    _controller.text = _initialValue;
  }
  /// 
  /// Set current [value] with provided [newValue].
  // void update(String newValue) {
  //   _controller.text = newValue;
  // }
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