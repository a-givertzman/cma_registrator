import 'package:cma_registrator/core/models/filter/filters.dart';
import 'package:cma_registrator/core/repositories/metric/metric_infos.dart';
import 'package:cma_registrator/core/repositories/operating_cycle/operating_cycles.dart';
import 'package:cma_registrator/core/widgets/future_builder_widget.dart';
import 'package:cma_registrator/pages/operating_cycle_details/widgets/filters_field.dart';
import 'package:cma_registrator/pages/operating_cycles/widgets/operating_cycles_table.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_log.dart';
///
class QueriableOperatingCycles extends StatefulWidget {
  final OperatingCycles _operatingCycles;
  final MetricInfos _metricInfos;
  ///
  const QueriableOperatingCycles({
    super.key,
    required OperatingCycles operatingCycles,
    required MetricInfos metricInfos,
  }) :
    _operatingCycles = operatingCycles,
    _metricInfos = metricInfos;
  //
  @override
  State<QueriableOperatingCycles> createState() => _QueriableOperatingCyclesState();
}
///
class _QueriableOperatingCyclesState extends State<QueriableOperatingCycles> {
  static const _log = Log('_QueriableOperatingCyclesState');
  late final ValueNotifier<Filters> _filtersNotifier;
  //
  @override
  void initState() {
    _filtersNotifier = ValueNotifier(const Filters.empty());
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(
            const Setting('blockPadding').toDouble,
          ),
          child: FutureBuilderWidget(
            onFuture: widget._metricInfos.fetchAll,
            caseData: (context, metricInfos, _) => FiltersField(
              filtersNotifier: _filtersNotifier,
              filterNames: metricInfos.map((info) => info.id).toList(),
            ),
          ),
        ),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: _filtersNotifier,
            builder: (context, filters, child) {
              _log.debug('ValueListenableBuilder: ${filters.enumerate()}');
              return FutureBuilderWidget(
                key: ValueKey(filters),
                onFuture: () => widget._operatingCycles.fetchAll(),
                caseData: (context, points, _) => OperatingCyclesTable(
                  operatingCycles: points,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}