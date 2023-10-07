import 'dart:collection';
import 'package:cma_registrator/core/models/operating_cycle/operating_cycle.dart';
import 'package:cma_registrator/core/widgets/table/table_view.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'operating_cycle_details_app_bar.dart';
///
class OperatingCycleDetailsRecord {
  final String timestamp;
  final Map<String, dynamic> signals;
  ///
  OperatingCycleDetailsRecord(this.timestamp, this.signals);
}
///
class OperatingCycleDetailsBody extends StatefulWidget {
  final OperatingCycle _operatingCycle;
  final List<DsDataPoint> _points;
  final double _timeColumnWidth;
  ///
  const OperatingCycleDetailsBody({
    super.key,
    required List<DsDataPoint> points,
    required OperatingCycle operatingCycle,
    double timeColumnWidth = 220, 
  }) : 
    _timeColumnWidth = timeColumnWidth, 
    _operatingCycle = operatingCycle, 
    _points = points;
  //
  @override
  State<OperatingCycleDetailsBody> createState() => _OperatingCycleDetailsBodyState(
    points: _points,
    operatingCycle: _operatingCycle,
    timeColumnWidth: _timeColumnWidth,
  );
}
///
class _OperatingCycleDetailsBodyState extends State<OperatingCycleDetailsBody> {
  final double _timeColumnWidth;
  final Set<String> _selectedTimestamps = {};
  late final Map<String, bool> _columnsVisibility;
  final List<DsDataPoint> _points;
  late final DaviModel<OperatingCycleDetailsRecord> _model;
  late final List<DaviColumn<OperatingCycleDetailsRecord>> _columns;
  final OperatingCycle _operatingCycle;
  ///
  _OperatingCycleDetailsBodyState({
    required double timeColumnWidth,
    required List<DsDataPoint> points,
    required OperatingCycle operatingCycle,
  }) : 
    _timeColumnWidth = timeColumnWidth,
    _points = points,
    _operatingCycle = operatingCycle;
  //
  @override
  void initState() {
    final detailsRecords = _extractDetailsRecords(_points);
    final signalNames = _extractSignalNames(detailsRecords);
    _columns = [
      DaviColumn<OperatingCycleDetailsRecord>(
        width: _timeColumnWidth,
        name: const Localized('Time').v,
        stringValue: (record) => record.timestamp,
        pinStatus: PinStatus.left,
        cellStyleBuilder: (row) => CellStyle(
          textStyle: _selectedTimestamps.contains(row.data.timestamp) 
            ? TextStyle(color: Theme.of(context).colorScheme.background)
            : null, 
        ),
      ),
      ...signalNames.map(
        (signalName) => DaviColumn<OperatingCycleDetailsRecord>(
          name: signalName,
          stringValue: (record) {
            final recordValue = record.signals[signalName] as Object?;
            if (recordValue == null) {
              return '-';
            }
            return recordValue is double 
              ? recordValue.toStringAsFixed(3)
              : recordValue.toString();
          },
          cellStyleBuilder: (row) => CellStyle(
            textStyle: _defineCellTextStyle(signalName, row.data.timestamp), 
          ),
        ),
      ),
    ];
    _model = DaviModel(rows: detailsRecords, columns: _columns, alwaysSorted: true);
    _columnsVisibility = Map.fromEntries(
      signalNames.map((signal) => MapEntry(signal, true)),
    );
    super.initState();
  }
  //
  List<OperatingCycleDetailsRecord> _extractDetailsRecords(List<DsDataPoint> points) {
    final detailsRecords = <OperatingCycleDetailsRecord>[];
    for (int i = 0; i < points.length; i++) {
      final timestamp = points[i].timestamp;
      final pointName = points[i].name.name;
      final recordSignals = <String, dynamic>{};
      if (detailsRecords.isNotEmpty) {
        recordSignals.addAll(detailsRecords[i-1].signals);
      }
      recordSignals[pointName] = points[i].value;
      detailsRecords.add(OperatingCycleDetailsRecord(timestamp, recordSignals));
    }
    return detailsRecords;
  }
  //
  List<String> _extractSignalNames(List<OperatingCycleDetailsRecord> records) {
    return records.isEmpty 
      ? <String>[]
      : records.last.signals.keys.toList()..sort(
        _compareSignalNames,
      );
  }
  //
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OperatingCycleDetailsAppBar(
          beginningTime: _operatingCycle.start, 
          endingTime: _operatingCycle.stop,
          dropdownMenuWidth: 220,
          columnsVisibility: SplayTreeMap.from(
            _columnsVisibility,
            _compareSignalNames,
          ),
          onChanged: (key, value) {
            final assignedValue = value ?? false;
            final visibleColumns = _columns.where(
              (element) => _columnsVisibility[element.name] ?? false,
            );
            if (assignedValue) {
              for(final column in visibleColumns) {
                _model.removeColumn(column);
              }
              _columnsVisibility[key] = assignedValue;
              _model.addColumns(
                _columns.where(
                  (element) => _columnsVisibility[element.name] ?? false,
                ),
              );
            } else {
              _model.removeColumn(
                visibleColumns.firstWhere((element) => element.name == key),
              );
              _columnsVisibility[key] = assignedValue;
            }
          },
        ),
        Expanded(
          child: TableView<OperatingCycleDetailsRecord>(
            model: _model,
            onRowTap: (record) => setState(() {
              if (_selectedTimestamps.contains(record.timestamp)) {
                _selectedTimestamps.remove(record.timestamp);
              } else {
                _selectedTimestamps.add(record.timestamp);
              }
            }),
            rowColor: (row) => _selectedTimestamps.contains(row.data.timestamp)
              ? Theme.of(context).colorScheme.onBackground.withOpacity(0.7)
              : null,
            rowCursor: (row) => _selectedTimestamps.contains(row.data.timestamp) 
              ? SystemMouseCursors.basic 
              : SystemMouseCursors.click,
          ),
        ),
      ],
    );
  }
  ///
  TextStyle? _defineCellTextStyle(String columnName, String timestamp) {
    if (_columnsVisibility[columnName] ?? false) {
      return _selectedTimestamps.contains(timestamp) 
            ? TextStyle(color: Theme.of(context).colorScheme.background)
            : null;
    }
    return const TextStyle(color: Colors.transparent);
  }
  ///
  int _compareSignalNames(String a, String b) {
    return a.compareTo(b);
  }
}
