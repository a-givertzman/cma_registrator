import 'dart:collection';

import 'package:cma_registrator/core/extensions/date_time_formatted_extension.dart';
import 'package:cma_registrator/core/models/operating_cycle/operating_cycle.dart';
import 'package:cma_registrator/core/models/operating_cycle_details/metric.dart';
import 'package:cma_registrator/core/repositories/operating_cycle_details/operating_cycle_details.dart';
import 'package:cma_registrator/pages/operating_cycle_details/operating_cycle_details_page.dart';
import 'package:cma_registrator/core/widgets/table/table_view.dart';
import 'package:davi/davi.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
///
class OperatingCyclesTable extends StatefulWidget {
  final double _timeColumnWidth;
  final double _metricColumnWidth;
  final List<OperatingCycle> _operatingCycles;
  ///
  const OperatingCyclesTable({
    super.key,
    required List<OperatingCycle> operatingCycles, 
    double timeColumnWidth = 240,
    double metricColumnWidth = 200,
  }) : 
    _timeColumnWidth = timeColumnWidth, 
    _metricColumnWidth = metricColumnWidth, 
    _operatingCycles = operatingCycles;
  //
  @override
  State<OperatingCyclesTable> createState() => _OperatingCyclesTableState(
    operatingCycles: _operatingCycles,
    timeColumnWidth: _timeColumnWidth,
    metricColumnWidth: _metricColumnWidth,
  );
}
///
class _OperatingCyclesTableState extends State<OperatingCyclesTable> {
  final Set<int> _selectedTimestamps = {};
  final double _timeColumnWidth;
  final double _metricColumnWidth;
  final List<OperatingCycle> _operatingCycles;
  late final DaviModel<OperatingCycle> _model;
  ///
  _OperatingCyclesTableState({
    required List<OperatingCycle>  operatingCycles,
    required double timeColumnWidth,
    required double metricColumnWidth,
  }) :
    _operatingCycles = operatingCycles,
    _metricColumnWidth = metricColumnWidth,
    _timeColumnWidth = timeColumnWidth;
  //
  @override
  // ignore: long-method
  void initState() {
    final metrics = HashSet<Metric>(
      equals: (metric1, metric2) => metric1.name == metric2.name,
      hashCode: (metric) => metric.name.hashCode,
    )..addAll(
      _operatingCycles
        .map((cycle) => cycle.metrics.values)
        .expand((e) => e),
    );
    _model = DaviModel(
      columns: [
        DaviColumn<OperatingCycle>(
          resizable: true,
          // grow: 2,
          width: _timeColumnWidth,
          name: const Localized('Beginning').v,
          pinStatus: PinStatus.left,
          stringValue: (operatingCycle) => operatingCycle.start.toFormatted(),
          dataComparator: (a, b, column) => a.start.compareTo(b.start),
          cellStyleBuilder: (row) => _buildCellStyle(row),
        ),
        DaviColumn<OperatingCycle>(
          // grow: 2,
          resizable: true,
          width: _timeColumnWidth,
          name: const Localized('Ending').v,
          pinStatus: PinStatus.left,
          stringValue: (operatingCycle) => operatingCycle.stop?.toFormatted() ?? '-',
          dataComparator: (a, b, column) {
            final otherEnding = b.stop;
            if (otherEnding == null) {
              return 1;
            }
            return a.stop?.compareTo(otherEnding) ?? -1;
          },
          cellStyleBuilder: (row) => _buildCellStyle(row),
        ),
        DaviColumn<OperatingCycle>(
          width: 140,
          resizable: true,
          name: const Localized('Duration, s').v,
          doubleValue: (operatingCycle) => (operatingCycle.stop?.difference(operatingCycle.start).inMilliseconds ?? 0) / 1000,
          dataComparator: (a, b, column) {
            final otherDifference = b.stop?.difference(b.start);
            if (otherDifference == null) {
              return 1;
            }
            return a.stop?.difference(a.start).compareTo(otherDifference) ?? -1;
          },
          cellStyleBuilder: (row) => _buildCellStyle(row),
        ),
        DaviColumn<OperatingCycle>(
          width: 120,
          name: const Localized('Alarm class').v,
          intValue: (operatingCycle) => operatingCycle.alarmClass,
          cellStyleBuilder: (row) => _buildCellStyle(row),
        ),
        ...metrics.map(
          (metric) => DaviColumn<OperatingCycle>(
            width: _metricColumnWidth,
            name: Localized(metric.name).v,
            doubleValue: (operatingCycle) => operatingCycle.metrics[metric.name]?.value,
            stringValue: (operatingCycle) => operatingCycle.metrics[metric.name]?.value.toString() ?? '-',
            cellStyleBuilder: (row) => _buildCellStyle(row),
          ),
        ),
      ],
      rows: _operatingCycles,
      alwaysSorted: true,
    );
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    return TableView<OperatingCycle>(
      model: _model,
      onRowTap: (operatingCycle) {
        final operatingCycleId = operatingCycle.id;
        setState(() {
          if(_selectedTimestamps.contains(operatingCycleId)) {
            _selectedTimestamps.remove(operatingCycleId);
          } else {
            _selectedTimestamps.add(operatingCycleId);
          }
        });
      },
      onRowDoubleTap: (operatingCycle) => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OperatingCycleDetailsPage(
            operatingCycle: operatingCycle,
            operatingCycleDetails: OperatingCycleDetails(
              apiAddress: ApiAddress.localhost(port: 8080),
              dbName: 'crane_data_server',
              tableName: 'public.rec_operating_event',
              
              operatingCycle: operatingCycle,
            ),
          ),
        ),
      ),
      rowColor: (row) => _selectedTimestamps.contains(row.data.id)
        ? Theme.of(context).colorScheme.onBackground.withOpacity(0.7)
        : null,
    );
  }
  ///
  CellStyle _buildCellStyle(DaviRow<OperatingCycle> row) {
    return CellStyle(
      textStyle: _selectedTimestamps.contains(row.data.id) 
        ? TextStyle(color: Theme.of(context).colorScheme.background)
        : null, 
    );
  }
}
