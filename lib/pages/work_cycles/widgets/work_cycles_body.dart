import 'package:cma_registrator/core/models/work_cycle.dart';
import 'package:cma_registrator/core/widgets/table/table_row_widget.dart';
import 'package:cma_registrator/pages/failures/failures_page.dart';
import 'package:flutter/material.dart';

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
        const WorkCyclesAppBar(
          // beginningTime: _beginningTime, 
          // endingTime: _endingTime,
        ),
        Expanded(
          child: Column(
            children: [
              const TableRowWidget(
                columnFlexes: _columnFlexes, 
                cellsContent: _tableHeaders,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _workCycles.length,
                  itemBuilder: (context, index) {
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
                      onDoubleTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => FailuresPage(
                            beginningTime: workCycle.beginning,
                            endingTime: workCycle.ending,
                          ),
                        ),
                      ),
                      child: TableRowWidget(
                        columnFlexes: _columnFlexes,
                        cellsContent: cellsContent,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
