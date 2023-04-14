import 'package:davi/davi.dart';
import 'package:flutter/material.dart';

///
class TableView<T> extends StatefulWidget {
  final DaviModel<T> _model;
  final void Function(T)? _onRowTap;
  final void Function(T)? _onRowDoubleTap;
  final Color? Function(DaviRow<T>)? _rowColor;
  final MouseCursor? Function(DaviRow<T>)? _rowCursor;
  final Border? _outerBorder;
  final double _tableBorderThickness;
  final Color? _tableBorderColor;
  final Color? _scrollbarBackgroundColor;
  final Color? _controlElementColor;
  final Color? _thumbColor;
  final ColumnWidthBehavior _columnWidthBehavior;
  ///
  const TableView({
    super.key, 
    required DaviModel<T> model, 
    void Function(T)? onRowTap,
    void Function(T)? onRowDoubleTap, 
    Color? Function(DaviRow<T>)? rowColor, 
    MouseCursor? Function(DaviRow<T>)? rowCursor, 
    Border? outerBorder, 
    double tableBorderThickness = 2.0, 
    Color? tableBorderColor, 
    Color? scrollbarBackgroundColor, 
    Color? controlElementColor, 
    Color? thumbColor, 
    ColumnWidthBehavior columnWidthBehavior = ColumnWidthBehavior.scrollable, 
    Color? selectedRowColor, 
  }) : 
    _rowColor = rowColor, 
    _columnWidthBehavior = columnWidthBehavior, 
    _thumbColor = thumbColor, 
    _controlElementColor = controlElementColor, 
    _scrollbarBackgroundColor = scrollbarBackgroundColor, 
    _tableBorderColor = tableBorderColor, 
    _tableBorderThickness = tableBorderThickness, 
    _onRowTap = onRowTap,
    _onRowDoubleTap = onRowDoubleTap,
    _rowCursor = rowCursor, 
    _outerBorder = outerBorder, 
    _model = model;
  //
  @override
  State<TableView<T>> createState() => _TableViewState<T>(
    model: _model,
    onRowTap: _onRowTap,
    onRowDoubleTap: _onRowDoubleTap,
    rowColor: _rowColor,
    rowCursor: _rowCursor,
    outerBorder: _outerBorder,
    tableBorderThickness: _tableBorderThickness,
    tableBorderColor: _tableBorderColor,
    scrollbarBackgroundColor: _scrollbarBackgroundColor,
    controlElementColor: _controlElementColor,
    thumbColor: _thumbColor,
    columnWidthBehavior: _columnWidthBehavior,
  );
}
///
class _TableViewState<T> extends State<TableView<T>> {
  final DaviModel<T> _model;
  final void Function(T)? _onRowTap;
  final void Function(T)? _onRowDoubleTap;
  final MouseCursor? Function(DaviRow<T>)? _rowCursor;
  final Color? Function(DaviRow<T>)? _rowColor;
  final Border? _outerBorder;
  final double _tableBorderThickness;
  final Color? _tableBorderColor;
  final Color? _scrollbarBackgroundColor;
  final Color? _controlElementColor;
  final Color? _thumbColor;
  final ColumnWidthBehavior _columnWidthBehavior;
  ///
  _TableViewState({
    required DaviModel<T> model,
    required void Function(T)? onRowTap,
    required void Function(T)? onRowDoubleTap, 
    required Color? Function(DaviRow<T>)? rowColor,
    required MouseCursor? Function(DaviRow<T>)? rowCursor,
    required Border? outerBorder,
    required double tableBorderThickness,
    required Color? tableBorderColor,
    required Color? scrollbarBackgroundColor,
    required Color? controlElementColor,
    required Color? thumbColor,
    required ColumnWidthBehavior columnWidthBehavior,

  }) : 
    _model = model,
    _rowColor = rowColor,
    _rowCursor = rowCursor, 
    _onRowTap = onRowTap,
    _onRowDoubleTap = onRowDoubleTap,
    _outerBorder = outerBorder,
    _tableBorderThickness = tableBorderThickness,
    _tableBorderColor = tableBorderColor,
    _scrollbarBackgroundColor = scrollbarBackgroundColor,
    _controlElementColor = controlElementColor,
    _thumbColor = thumbColor,
    _columnWidthBehavior = columnWidthBehavior;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controlElementColor = _controlElementColor 
      ?? theme.colorScheme.primary;
    final tableBorderColor = _tableBorderColor 
      ?? theme.disabledColor.withOpacity(0.3);
    final scrollbarBackgroundColor = _scrollbarBackgroundColor
      ?? theme.disabledColor.withOpacity(0.07);
    final thumbColor = _thumbColor ?? theme.disabledColor.withOpacity(0.3);
    final outerBorder = _outerBorder ?? Border.all(
      color:  tableBorderColor,
      width: 1,
    );
    return DaviTheme(
      data: DaviThemeData(
        decoration: BoxDecoration(
          border: outerBorder,
        ),
        columnDividerColor: tableBorderColor,
        columnDividerThickness: _tableBorderThickness,
        headerCell: HeaderCellThemeData(
          sortIconColors: SortIconColors(
            ascending: controlElementColor, 
            descending: controlElementColor,
          ),
        ),
        header: HeaderThemeData(
          bottomBorderColor: tableBorderColor,
          bottomBorderHeight: _tableBorderThickness,
          columnDividerColor: tableBorderColor,
        ),
        row: RowThemeData(
          dividerColor: tableBorderColor,
          dividerThickness: _tableBorderThickness,
        ),
        cell: const CellThemeData(
          alignment: Alignment.center,
        ),
        scrollbar: TableScrollbarThemeData(
          margin: theme.scrollbarTheme.mainAxisMargin
            ?? TableScrollbarThemeDataDefaults.margin,
          thickness: theme.scrollbarTheme.thickness?.resolve({MaterialState.hovered}) 
            ?? TableScrollbarThemeDataDefaults.thickness,
          verticalColor: scrollbarBackgroundColor,
          verticalBorderColor: Colors.transparent,
          pinnedHorizontalColor: scrollbarBackgroundColor,
          pinnedHorizontalBorderColor: Colors.transparent,
          unpinnedHorizontalColor: scrollbarBackgroundColor,
          unpinnedHorizontalBorderColor: Colors.transparent,
          columnDividerColor: tableBorderColor,
          thumbColor: thumbColor,
        ),
        topCornerColor: Colors.transparent,
        bottomCornerColor: scrollbarBackgroundColor,
        topCornerBorderColor: Colors.transparent,
        bottomCornerBorderColor: Colors.transparent,
      ),
      child: Davi<T>(
        _model,
        onRowTap:_onRowTap,
        onRowDoubleTap: _onRowDoubleTap,
        rowColor: _rowColor,
        rowCursor: _rowCursor,
        columnWidthBehavior: _columnWidthBehavior,
      ),
    );
  }
}
