import 'package:cma_registrator/core/widgets/table/table_cell_widget.dart';
import 'package:flutter/material.dart';

///
class TableColumnWidget extends StatelessWidget {
  final String? _columnName;
  final List<String> _cellsContent;
  ///
  const TableColumnWidget({
    super.key,
    String? columnName,
    required List<String> cellsContent,
  }) :
    _columnName = columnName,
    _cellsContent = cellsContent; 
  //
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_columnName != null)
          TableCellWidget(content: _columnName!),
        ..._cellsContent.map(
          (content) => TableCellWidget(content: content),
        ),
      ],
    );
  }
}