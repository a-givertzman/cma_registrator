import 'package:cma_registrator/core/extensions/date_time_formatted_extension.dart';
import 'package:cma_registrator/core/models/work_cycle/work_cycle_point.dart';
import 'package:cma_registrator/pages/failures/failures_page.dart';
import 'package:cma_registrator/core/widgets/table/table_view.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'work_cycles_app_bar.dart';
///
class WorkCyclesTable extends StatefulWidget {
  final double _timeColumnWidth;
  final List<WorkCyclePoint> _workCycles;
  ///
  const WorkCyclesTable({
    super.key,
    required List<WorkCyclePoint> workCycles, 
    double timeColumnWidth = 220,
  }) : 
    _timeColumnWidth = timeColumnWidth, 
    _workCycles = workCycles;
  //
  @override
  State<WorkCyclesTable> createState() => _WorkCyclesTableState(
    workCycles: _workCycles,
    timeColumnWidth: _timeColumnWidth,
  );
}
///
class _WorkCyclesTableState extends State<WorkCyclesTable> {
  final Set<(DateTime, DateTime?, DsPointName)> _selectedTimestamps = {};
  final double _timeColumnWidth;
  final List<WorkCyclePoint> _workCycles;
  late final DaviModel<WorkCyclePoint> _model;
  ///
  _WorkCyclesTableState({
    required List<WorkCyclePoint>  workCycles,
    required double timeColumnWidth,
  }) :
    _workCycles = workCycles,
    _timeColumnWidth = timeColumnWidth;
  //
  @override
  // ignore: long-method
  void initState() {
    _model = DaviModel(
      columns: [
        DaviColumn<WorkCyclePoint>(
          resizable: true,
          grow: 2,
          width: _timeColumnWidth,
          name: const Localized('Beginning').v,
          pinStatus: PinStatus.left,
          stringValue: (workCycle) => workCycle.start.toFormatted(),
          dataComparator: (a, b, column) => a.start.compareTo(b.start),
          cellStyleBuilder: (row) => _buildCellStyle(row),
        ),
        DaviColumn<WorkCyclePoint>(
          grow: 2,
          resizable: true,
          width: _timeColumnWidth,
          name: const Localized('Ending').v,
          pinStatus: PinStatus.left,
          stringValue: (workCycle) => workCycle.stop?.toFormatted() ?? '-',
          dataComparator: (a, b, column) {
            final otherEnding = b.stop;
            if (otherEnding == null) {
              return 1;
            }
            return a.stop?.compareTo(otherEnding) ?? -1;
          },
          cellStyleBuilder: (row) => _buildCellStyle(row),
        ),
        DaviColumn<WorkCyclePoint>(
          grow: 2,
          name: const Localized('Point name').v,
          stringValue: (workCycle) => workCycle.name.name,
          cellStyleBuilder: (row) => _buildCellStyle(row),
        ),
      ]
      .followedBy(
        _workCycles.first.metrics.map(
          (metric) => DaviColumn<WorkCyclePoint>(
            name: Localized(metric.name).v,
            doubleValue: (workCycle) => workCycle.metrics
              .firstWhere((m) => m.name == metric.name).value,
            cellStyleBuilder: (row) => _buildCellStyle(row),
          ),
        ),
      )
      .toList(),
      rows: _workCycles,
      alwaysSorted: true,
    );
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const WorkCyclesAppBar(
          // beginningTime: _beginningTime, 
          // endingTime: _endingTime,
        ),
        Expanded(
          child: TableView<WorkCyclePoint>(
            model: _model,
            columnWidthBehavior: ColumnWidthBehavior.fit,
            onRowTap: (workCycle) {
              final dateRange = _representWorkCycle(workCycle);
              setState(() {
                if(_selectedTimestamps.contains(dateRange)) {
                  _selectedTimestamps.remove(dateRange);
                } else {
                  _selectedTimestamps.add(dateRange);
                }
              });
            },
            onRowDoubleTap: (workCycle) => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FailuresPage(
                  beginningTime: workCycle.start,
                  endingTime: workCycle.stop,
                ),
              ),
            ),
            rowColor: (row) => _selectedTimestamps.contains(_representWorkCycle(row.data))
              ? Theme.of(context).colorScheme.onBackground.withOpacity(0.7)
              : null,
          ),
        ),
      ],
    );
  }
  ///
  CellStyle _buildCellStyle(DaviRow<WorkCyclePoint> row) {
    return CellStyle(
      textStyle: _selectedTimestamps.contains(_representWorkCycle(row.data)) 
        ? TextStyle(color: Theme.of(context).colorScheme.background)
        : null, 
    );
  }
  ///
  (DateTime, DateTime?, DsPointName) _representWorkCycle(WorkCyclePoint workCycle) => (workCycle.start, workCycle.stop, workCycle.name); 
    // '${workCycle.start}_'
    // '${workCycle.stop}_'
    // '${workCycle.name.name}';
}
