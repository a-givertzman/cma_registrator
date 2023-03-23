import 'package:cma_registrator/core/models/work_cycle.dart';
import 'package:flutter/material.dart';
import 'list_row_widget.dart';
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
  static const _columnFlexes = [
    2, 2, 1, 1, 1, 1,
  ];
  static const _tableHeaders = [
    'Начало', 'Окончание', 'Класс аварии', 
    'Макс', 'Среднее', 'Данные',
  ];
  _WorkCyclesBodyState(this._workCycles);
  //
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ListRowWidget(
          columnFlexes: _columnFlexes, 
          cellsContent: _tableHeaders,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _workCycles.length,
            itemBuilder: (_, index) {
              final workCycle = _workCycles[index];
              final cellsContent = [
                workCycle.beginning.toIso8601String(),
                workCycle.ending?.toIso8601String() ?? '-',
                workCycle.failureClass.toString(),
                workCycle.max.toStringAsFixed(5),
                workCycle.mean.toStringAsFixed(5),
                workCycle.data.toStringAsFixed(5),
              ];
              return InkWell(
                onTap: () { return; },
                child: ListRowWidget(
                  columnFlexes: _columnFlexes,
                  cellsContent: cellsContent,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
