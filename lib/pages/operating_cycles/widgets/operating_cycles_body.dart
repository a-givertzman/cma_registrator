import 'package:cma_registrator/core/repositories/metric/metric_infos.dart';
import 'package:cma_registrator/core/repositories/operating_cycle/operating_cycles.dart';
import 'package:cma_registrator/core/widgets/future_builder_scaffold.dart';
import 'package:cma_registrator/pages/operating_cycles/widgets/queriable_operating_cycles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_core/hmi_core_translate.dart';

class OperatingCyclesBody extends StatelessWidget {
  final OperatingCycles _cycles;
  final MetricInfos _metricInfos;
  const OperatingCyclesBody({
    super.key, 
    required OperatingCycles cycles,
    required MetricInfos metricInfos
  }) :
    _cycles = cycles,
    _metricInfos = metricInfos;

  @override
  Widget build(BuildContext context) {
    return FutureBuilderScaffold(
      title: const Localized('Operating cycles').v,
      appBarHeight: 72.0,
      // Fake future to trigger full page reload
      onFuture: () => Future.value(const Ok(true)),
      caseData: (context, _) => QueriableOperatingCycles(
        operatingCycles: _cycles,
        metricInfos: _metricInfos,
      ),
    );
  }
}