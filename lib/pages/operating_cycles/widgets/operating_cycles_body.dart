import 'package:cma_registrator/core/repositories/operating_cycle/operating_cycles.dart';
import 'package:cma_registrator/core/widgets/future_builder_scaffold.dart';
import 'package:cma_registrator/pages/operating_cycles/widgets/operating_cycles_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';

class OperatingCyclesBody extends StatelessWidget {
  final OperatingCycles _points;
  const OperatingCyclesBody({
    super.key, 
    required OperatingCycles points,
  }) : _points = points;

  @override
  Widget build(BuildContext context) {
    return FutureBuilderScaffold(
      title: const Localized('Operating cycles').v,
      appBarHeight: 72.0,
      onFuture: () => _points.fetchAll(),
      caseData: (context, data) => OperatingCyclesTable(
        operatingCycles: data,
        timeColumnWidth: 200,
      ),
    );
  }
}