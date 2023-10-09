import 'package:cma_registrator/core/repositories/operating_cycle/operating_cycles.dart';
import 'package:cma_registrator/core/widgets/future_builder_widget.dart';
import 'package:cma_registrator/pages/operating_cycles/widgets/operating_cycles_table.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_translate.dart';

class OperatingCyclesBody extends StatelessWidget {
  final OperatingCycles _points;
  const OperatingCyclesBody({
    super.key, 
    required OperatingCycles points,
  }) : _points = points;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilderWidget(
      onFuture: () => _points.fetchAll(),
      retryLabel: Padding(
        padding: EdgeInsets.symmetric(
          vertical: const Setting('padding').toDouble,
        ),
        child: Text(
          const Localized('Retry').v,
          style: theme.textTheme.titleLarge?.copyWith(
            height: 1,
            color: theme.colorScheme.onPrimary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      validateData: (data) {
        return !data.hasError;
      },
      caseData: (context, data) => OperatingCyclesTable(
        operatingCycles: data.data,
        timeColumnWidth: 200,
      ),
    );
  }
}