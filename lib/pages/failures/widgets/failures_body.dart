import 'dart:collection';
import 'package:cma_registrator/core/widgets/table/table_column_widget.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'failures_app_bar.dart';
///
class FailuresBody extends StatefulWidget {
  final DateTime? _beginningTime;
  final DateTime? _endingTime;
  final List<DsDataPoint> _points;
  ///
  const FailuresBody({
    super.key,
    required List<DsDataPoint> points, 
    DateTime? beginningTime, 
    DateTime? endingTime,
  }) : 
    _endingTime = endingTime, 
    _beginningTime = beginningTime, 
    _points = points;
  //
  @override
  State<FailuresBody> createState() => _FailuresBodyState(
    points: _points,
    beginningTime: _beginningTime,
    endingTime: _endingTime,
  );
}
///
class _FailuresBodyState extends State<FailuresBody> {
  final Map<String, SplayTreeMap<String, dynamic>> _columns = {};
  late final Map<String, bool> _columnsVisibility;
  final List<String> _timestamps = [];
  final List<DsDataPoint> _points;
  final DateTime? _beginningTime;
  final DateTime? _endingTime;
  ///
  _FailuresBodyState({
    required List<DsDataPoint> points,
    DateTime? beginningTime, 
    DateTime? endingTime,
  }) : _points = points,
    _beginningTime = beginningTime,
    _endingTime = endingTime;
  //
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
    _columnsVisibility = Map.fromEntries(
      _columns.keys.map((signal) => MapEntry(signal, true)),
    );
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final signalNames = _columns.keys.toList();
    signalNames.sort();
    return Column(
      children: [
        FailuresAppBar(
          beginningTime: _beginningTime, 
          endingTime: _endingTime,
          columnsVisibility: Map.fromEntries(
            signalNames.map((signal) => MapEntry(signal, true)),
          ),
          onChanged: (key, value) {
            setState(() {
              _columnsVisibility[key] = value ?? false;
            });
          },
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 230,
                  child: TableColumnWidget(
                        columnName: const Localized('Time').v,
                        cellsContent: _timestamps,
                  ),
                ),
                ...signalNames
                  .where((signal) => _columnsVisibility[signal] ?? false)
                  .map(
                    (signalName) => Expanded(
                      child: TableColumnWidget(
                        columnName: signalName,
                        cellsContent: _timestamps.map(
                          (timestamp) => _columns[signalName]![timestamp]?.toString() ?? '-',
                        ).toList(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}