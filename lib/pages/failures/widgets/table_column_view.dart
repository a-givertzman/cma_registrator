import 'package:cma_registrator/core/widgets/table/table_cell_widget.dart';
import 'package:flutter/material.dart';
///
class TableColumnView extends StatefulWidget {
  final double _columnWidth;
  final double _cellHeight;
  final Set<int> _selectedRows;
  final ScrollController? _controller;
  final List<String> _rowKeys;
  final Map<String, dynamic> _rowContents;
  final void Function(int)? _onCellTap;
  final void Function(int)? _onCellDoubleTap;
  ///
  const TableColumnView({
    super.key, 
    ScrollController? controller, 
    List<String> rowKeys = const [], 
    Map<String, dynamic> rowContents = const {}, 
    double columnWidth = 200, 
    double cellHeight = 40,
    void Function(int rowIndex)? onCellTap,
    void Function(int rowIndex)? onCellDoubleTap, 
    Set<int> selectedRows = const {},
  }) : _selectedRows = selectedRows, 
    _columnWidth = columnWidth, 
    _cellHeight = cellHeight, 
    _controller = controller,
    _rowKeys = rowKeys, 
    _rowContents = rowContents,
    _onCellTap = onCellTap,
    _onCellDoubleTap = onCellDoubleTap;
  //
  @override
  State<TableColumnView> createState() => _TableColumnViewState(
    columnWidth: _columnWidth,
    cellHeight: _cellHeight,
    rowKeys: _rowKeys, 
    rowContents: _rowContents,
    controller: _controller,
    onCellTap: _onCellTap,
    onCellDoubleTap: _onCellDoubleTap,
  );
}
///
class _TableColumnViewState extends State<TableColumnView> {
  final Key _key = UniqueKey();
  final double _columnWidth;
  final double _cellHeight;
  final ScrollController? _controller;
  final List<String> _rowKeys;
  final Map<String, dynamic> _rowContents;
  final void Function(int)? _onCellTap;
  final void Function(int)? _onCellDoubleTap;
  //
  _TableColumnViewState({
    ScrollController? controller,
    void Function(int)? onCellTap,
    void Function(int)? onCellDoubleTap,
    required double columnWidth, 
    required double cellHeight,
    required List<String> rowKeys,
    required Map<String, dynamic> rowContents,
  }) : 
    _controller = controller,
    _columnWidth = columnWidth,
    _cellHeight = cellHeight,
    _rowKeys = rowKeys,
    _rowContents = rowContents,
    _onCellTap = onCellTap,
    _onCellDoubleTap = onCellDoubleTap;
  //
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
  //
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _columnWidth,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ListView.builder(
          key: _key,
          controller: _controller,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: _rowKeys.length,
          itemBuilder: (context, rowIndex) {
            final rowKey = _rowKeys[rowIndex];
            final content = _rowContents[rowKey]?.toString() ?? '-';
            return GestureDetector(
              onTap: () => _onCellTap?.call(rowIndex),
              onDoubleTap: () => _onCellDoubleTap?.call(rowIndex),
              child: SizedBox(
                height: _cellHeight,
                child: TableCellWidget(
                  content: content,
                  isSelected: widget._selectedRows.contains(rowIndex),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}