import 'package:flutter/material.dart';
import 'list_cell_widget.dart';

///
class ListRowWidget extends StatelessWidget {
  final List<String> _cellsContent;
  final List<int> _columnFlexes;
  ///
  const ListRowWidget({
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
          child: ListCellWidget(
            content: entry.value,
          ),
        ),
      ).toList(),
    );
  }
}