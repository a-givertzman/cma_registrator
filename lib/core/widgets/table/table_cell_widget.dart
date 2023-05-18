import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';

///
class TableCellWidget  extends StatelessWidget {
  final bool isSelected;
  final String content;
  final Setting padding;
  ///
  const TableCellWidget ({
    super.key, 
    required this.content, 
    this.padding = const Setting('padding'), this.isSelected = false,
  });
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(padding.toDouble),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white10),
        color: isSelected ? Theme.of(context).disabledColor.withOpacity(0.5) : null,
      ),
      child: Text(
        content, 
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.fade,
        style: TextStyle(
          color: isSelected ? theme.disabledColor : null,
        ),
      ),
    );
  }
}