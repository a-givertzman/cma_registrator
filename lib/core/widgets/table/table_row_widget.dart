import 'package:flutter/material.dart';
import 'table_cell_widget.dart';

///
class TableRowWidget extends StatelessWidget {
  final List<String> _cellsContent;
  final List<int> _columnFlexes;
  ///
  const TableRowWidget({
    super.key,
    required List<int> columnFlexes,
    required List<String> cellsContent,
  }) :
    _columnFlexes = columnFlexes,
    _cellsContent = cellsContent; 
  //
  @override
  Widget build(BuildContext context) {
    return Row(
      children: _cellsContent.asMap().entries.map(
        (entry) => Expanded(
          flex: _columnFlexes[entry.key],
          child: TableCellWidget(
            content: entry.value,
          ),
        ),
      ).toList(),
    );
  }
}