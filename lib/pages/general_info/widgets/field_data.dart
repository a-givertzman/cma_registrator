import 'package:flutter/material.dart';
///
class FieldData {
  final String viewLabel;
  final String? sendLabel;
  String initialValue;
  String? receivedError;
  final TextEditingController controller;
  ///
  FieldData({
    required this.viewLabel, 
    required this.initialValue, 
    this.sendLabel, 
    this.receivedError,
    TextEditingController? controller,
  }) : 
    controller = controller ?? TextEditingController(text: initialValue);
}