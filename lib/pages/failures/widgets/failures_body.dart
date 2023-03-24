import 'dart:collection';
import 'package:cma_registrator/core/widgets/table/list_column_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';

class FailuresBody extends StatefulWidget {
  final List<DsDataPoint> _points;
  const FailuresBody({
    super.key,
    required List<DsDataPoint> points,
  }) : _points = points;

  @override
  State<FailuresBody> createState() => _FailuresBodyState(
    points: _points,
  );
}

class _FailuresBodyState extends State<FailuresBody> {
  final Map<String, SplayTreeMap<String, dynamic>> _columns = {};
  final List<String> _timestamps = [];
  final List<DsDataPoint> _points;
  _FailuresBodyState({
    required List<DsDataPoint> points,
  }) : _points = points;

  @override
  void initState() {
    for  (final point in _points) {
      final timestamp = point.timestamp;
      final pointName = point.name.name;
      _timestamps.add(timestamp);
      for (final column in _columns.values) {
        column[timestamp] = column.values.last;
      }
      if(!_columns.containsKey(pointName)) {
        _columns[pointName] = SplayTreeMap();
      }
      _columns[pointName]![timestamp] = point.value;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final signalNames = _columns.keys.toList();
    signalNames.sort();
    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 230,
            child: ListColumnWidget(
                  columnName: 'Time',
                  cellsContent: _timestamps,
            ),
          ),
          ...signalNames.map(
            (signalName) => Expanded(
              child: ListColumnWidget(
                columnName: signalName,
                cellsContent: _timestamps.map(
                  (timestamp) => _columns[signalName]![timestamp]?.toString() ?? '-',
                ).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}