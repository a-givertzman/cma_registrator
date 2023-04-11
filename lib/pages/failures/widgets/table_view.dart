import 'dart:collection';
import 'package:cma_registrator/core/widgets/table/table_cell_widget.dart';
import 'package:flutter/material.dart';
import 'linked_scroll_controller.dart';
import 'table_column_view.dart';

///
class TableView extends StatefulWidget {
  final double _cellHeight;
  final double _columnWidth;
  final double _keyColumnWidth;
  final List<String> _visibleColumns;
  final List<String> _rowKeys;
  final String _keyColumnName;
  final Map<String, SplayTreeMap<String, dynamic>> _rowsContent;
  ///
  const TableView({
    super.key,
    required List<String> visibleColumns,
    required List<String> rowKeys,
    required Map<String, SplayTreeMap<String, dynamic>> rowContent, 
    double cellHeight = 40, 
    double columnWidth = 150, 
    String keyColumnName = '', 
    double keyColumnWidth = 200,
  }) : 
    _columnWidth = columnWidth, 
    _keyColumnWidth = keyColumnWidth, 
    _cellHeight = cellHeight, 
    _keyColumnName = keyColumnName, 
    _visibleColumns = visibleColumns, 
    _rowKeys = rowKeys, 
    _rowsContent = rowContent;
  //
  @override
  State<TableView> createState() => _TableViewState(
    cellHeight: _cellHeight, 
    columnWidth: _columnWidth, 
    keyColumnWidth: _keyColumnWidth,
    rowKeys: _rowKeys, 
    keyColumnName: _keyColumnName,
    rowsContent: _rowsContent, 
  );
}
///
class _TableViewState extends State<TableView> {
  final double _cellHeight;
  final double _columnWidth;
  final double _keyColumnWidth;
  final List<String> _rowKeys;
  final String _keyColumnName;
  final Set<int> _selectedRows = {};
  final Map<String, SplayTreeMap<String, dynamic>> _rowsContent;
  late final ScrollController _scrollbarVertical;
  final _horizontalGroup = LinkedScrollControllerGroup();
  late final ScrollController _scrollbarHorizontal;
  final _verticalGroup = LinkedScrollControllerGroup();
  ///
  _TableViewState({
    required double cellHeight, 
    required double columnWidth, 
    required double keyColumnWidth,
    required List<String> rowKeys,
    required String keyColumnName,
    required Map<String, SplayTreeMap<String, dynamic>> rowsContent,
  }) : 
    _cellHeight = cellHeight,
    _columnWidth = columnWidth,
    _keyColumnWidth = keyColumnWidth,
    _rowKeys = rowKeys,
    _keyColumnName = keyColumnName,
    _rowsContent = rowsContent;
  //
  @override
  void initState() {
    _scrollbarHorizontal = _horizontalGroup.addAndGet();
    _scrollbarVertical = _verticalGroup.addAndGet();
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            SizedBox(
              width: _keyColumnWidth,
              height: _cellHeight,
              child: TableCellWidget(
                content: _keyColumnName,
              ),
            ),
            Expanded(
              child: TableColumnView(
                selectedRows: _selectedRows,
                columnWidth: _keyColumnWidth,
                cellHeight: _cellHeight,
                controller: _scrollbarVertical,
                rowKeys: _rowKeys,
                rowContents: SplayTreeMap.fromIterables(
                  _rowKeys,
                  _rowKeys,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Column(
            children: [
              SizedBox(
                height: _cellHeight,
                child: ListView.builder(
                  key: UniqueKey(),
                  controller: _horizontalGroup.addAndGet(),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget._visibleColumns.length,
                  itemBuilder: (context, index) => SizedBox(
                      width: _columnWidth,
                      child: TableCellWidget(
                      content: widget._visibleColumns[index],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Scrollbar(
                  controller: _scrollbarVertical,
                  thumbVisibility: true,
                  notificationPredicate: (notification) => notification.depth==1,
                  child: Scrollbar(
                    controller: _scrollbarHorizontal,
                    thumbVisibility: true,
                    child: ListView.builder(
                      key: UniqueKey(),
                      controller:  _scrollbarHorizontal,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget._visibleColumns.length,
                      itemBuilder: (context, columnIndex) {
                        final columnName = widget._visibleColumns[columnIndex];
                        return TableColumnView(
                          selectedRows: _selectedRows,
                          columnWidth: _columnWidth,
                          cellHeight: _cellHeight,
                          controller: _verticalGroup.addAndGet(),
                          rowKeys: _rowKeys,
                          rowContents: _rowsContent[columnName] ?? const {},
                          onCellTap: (rowIndex) {
                            if(_selectedRows.contains(rowIndex)) {
                              setState(() {
                                _selectedRows.remove(rowIndex);
                              });
                            } else {
                              setState(() {
                                _selectedRows.add(rowIndex);
                              });
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
