import 'package:cma_registrator/core/models/work_cycle.dart';
import 'package:cma_registrator/pages/failures/failures_page.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';

import 'work_cycles_app_bar.dart';
///
class WorkCyclesBody extends StatefulWidget {
  final List<WorkCycle> _workCycles;
  ///
  const WorkCyclesBody({
    super.key,
    required List<WorkCycle> workCycles,
  }) : _workCycles = workCycles;
  //
  @override
  State<WorkCyclesBody> createState() => _WorkCyclesBodyState(_workCycles);
}
///
class _WorkCyclesBodyState extends State<WorkCyclesBody> {
  final List<WorkCycle> _workCycles;
  static const _tableHeaders = [
    'Начало', 'Окончание','Класс аварии', 
    'Макс', 'Среднее', 'Данные',
  ];
  _WorkCyclesBodyState(this._workCycles);
  ///
  void onCellDoubleTap(WorkCycle workCycle) { 
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FailuresPage(
          beginningTime: workCycle.beginning,
          endingTime: workCycle.ending,
        ),
      ),
    );
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
          child: SingleChildScrollView(
            child: Table(
              border: TableBorder.all(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
              ),
              columnWidths: _tableHeaders.map((header) {
                if (header == 'Начало' || header == 'Окончание') {
                  return const FixedColumnWidth(230);
                }
                else {
                  return const FlexColumnWidth(1);
                }
              }).toList().asMap(),
              children: [
                TableRow(
                  children: _tableHeaders.map(
                    (header) => TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(header),
                      ),
                    ),
                  ).toList(),
                ),
                ..._workCycles.reversed.map((workCycle) {
                  return TableRow(
                    children: [
                      TapableTableCell(
                        onDoublePressed: () => onCellDoubleTap(workCycle),
                        child: Text(
                          workCycle.beginning.toIso8601String(),
                        ),
                      ),
                      TapableTableCell(
                        onDoublePressed: () => onCellDoubleTap(workCycle),
                        child: Text(
                          workCycle.ending?.toIso8601String() ?? '-',
                        ),
                      ),
                      TapableTableCell(
                        onDoublePressed: () => onCellDoubleTap(workCycle),
                        child: Text(
                          workCycle.failureClass.toString(),
                        ),
                      ),
                      TapableTableCell(
                        onDoublePressed: () => onCellDoubleTap(workCycle),
                        child: Text(
                          workCycle.max.toStringAsFixed(5),
                        ),
                      ),
                      TapableTableCell(
                        onDoublePressed: () => onCellDoubleTap(workCycle),
                        child: Text(
                          workCycle.mean.toStringAsFixed(5),
                        ),
                      ),
                      TapableTableCell(
                        onDoublePressed: () => onCellDoubleTap(workCycle),
                        child: Text(
                          workCycle.data.toStringAsFixed(5),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TapableTableCell extends StatelessWidget {
  final Widget? child;
  final void Function()? onDoublePressed;
  final void Function()? onPressed;
  const TapableTableCell({
    super.key, 
    this.child, 
    this.onPressed,
    this.onDoublePressed, 
  });

  @override
  Widget build(BuildContext context) {
    final padding = const Setting('padding').toDouble;
    return TableCell(
      child: TableRowInkWell(
        onDoubleTap: onDoublePressed,
        onTap: onPressed,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: child,
        ),
      ),
    );
  }
}
