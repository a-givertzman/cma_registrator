import 'package:cma_registrator/core/models/work_cycle/work_cycle_points.dart';
import 'package:cma_registrator/core/widgets/error_message_widget.dart';
import 'package:cma_registrator/core/widgets/future_builder_widget.dart';
import 'package:cma_registrator/pages/work_cycles/widgets/work_cycles_table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_translate.dart';

class WorkCyclesBody extends StatelessWidget {
  final WorkCyclePoints _points;
  const WorkCyclesBody({
    super.key, 
    required WorkCyclePoints points,
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
      caseLoading: (_) => const Center(
        child: CupertinoActivityIndicator(),
      ),
      validateData: (data) {
        return !data.hasError;
      },
      caseData: (context, data) => WorkCyclesTable(
        workCycles: data.data,
        timeColumnWidth: 200,
      ),
      caseError: (_, error) => ErrorMessageWidget(
        message: const Localized('Data loading error').v,
      ),
      caseNothing: (context) => ErrorMessageWidget(
        message: const Localized('No data').v,
      ),
    );
  }
}