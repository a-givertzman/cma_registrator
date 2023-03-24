import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';

///
class TableCellWidget  extends StatelessWidget {
  final String content;
  final Setting padding;
  ///
  const TableCellWidget ({
    super.key, 
    required this.content, 
    this.padding = const Setting('padding'),
  });
  //
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding.toDouble),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
      ),
      child: Text(
        content, 
        textAlign: TextAlign.center,
      ),
    );
  }
}