import 'package:cma_registrator/core/extensions/date_time_formatted_extension.dart';
import 'package:cma_registrator/core/models/work_cycle.dart';
import 'package:cma_registrator/pages/failures/failures_page.dart';
import 'package:cma_registrator/core/widgets/table/table_view.dart';
import 'package:davi/davi.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';

import 'work_cycles_app_bar.dart';
///
class WorkCyclesBody extends StatefulWidget {
  final double _timeColumnWidth;
  final List<WorkCycle> _workCycles;
  ///
  const WorkCyclesBody({
    super.key,
    required List<WorkCycle> workCycles, 
    double timeColumnWidth = 220,
  }) : 
    _timeColumnWidth = timeColumnWidth, 
    _workCycles = workCycles;
  //
  @override
  State<WorkCyclesBody> createState() => _WorkCyclesBodyState(
    workCycles: _workCycles,
    timeColumnWidth: _timeColumnWidth,
  );
}
///
class _WorkCyclesBodyState extends State<WorkCyclesBody> {
  final Set<String> _selectedTimestamps = {};
  final double _timeColumnWidth;
  final List<WorkCycle> _workCycles;
  late final DaviModel<WorkCycle> _model;
  ///
  _WorkCyclesBodyState({
    required List<WorkCycle>  workCycles,
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
        DaviColumn<WorkCycle>(
          resizable: true,
          width: _timeColumnWidth,
          name: const Localized('Beginning').v,
          pinStatus: PinStatus.left,
          stringValue: (workCycle) => workCycle.beginning.toFormatted(),
          dataComparator: (a, b, column) => a.beginning.compareTo(b.beginning),
          cellStyleBuilder: (row) => _buildCellStyle(row),
        ),
        DaviColumn<WorkCycle>(
          resizable: true,
          width: _timeColumnWidth,
          name: const Localized('Ending').v,
          pinStatus: PinStatus.left,
          stringValue: (workCycle) => workCycle.ending?.toFormatted() ?? '-',
          dataComparator: (a, b, column) {
            final otherEnding = b.ending;
            if (otherEnding == null) {
              return 1;
            }
            return a.ending?.compareTo(otherEnding) ?? -1;
          },
          cellStyleBuilder: (row) => _buildCellStyle(row),
        ),
        DaviColumn<WorkCycle>(
          name: const Localized('Failure class').v,
          intValue: (workCycle) => workCycle.failureClass,
          cellStyleBuilder: (row) => _buildCellStyle(row),
        ),
        DaviColumn<WorkCycle>(
          name: const Localized('Max').v,
          doubleValue: (workCycle) => workCycle.max,
          fractionDigits: 3,
          cellStyleBuilder: (row) => _buildCellStyle(row),
        ),
        DaviColumn<WorkCycle>(
          name: const Localized('Mean').v,
          doubleValue: (workCycle) => workCycle.mean,
          fractionDigits: 3,
          cellStyleBuilder: (row) => _buildCellStyle(row),
        ),
        DaviColumn<WorkCycle>(
          name: const Localized('Data').v,
          doubleValue: (workCycle) => workCycle.data,
          fractionDigits: 3,
          cellStyleBuilder: (row) => _buildCellStyle(row),
        ),
      ],
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
          child: TableView<WorkCycle>(
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
                  beginningTime: workCycle.beginning,
                  endingTime: workCycle.ending,
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
  CellStyle _buildCellStyle(DaviRow<WorkCycle> row) {
    return CellStyle(
      textStyle: _selectedTimestamps.contains(_representWorkCycle(row.data)) 
        ? TextStyle(color: Theme.of(context).colorScheme.background)
        : null, 
    );
  }
  ///
  String _representWorkCycle(WorkCycle workCycle) => '${workCycle.beginning}_'
    '${workCycle.ending}_'
    '${workCycle.data}';
}
