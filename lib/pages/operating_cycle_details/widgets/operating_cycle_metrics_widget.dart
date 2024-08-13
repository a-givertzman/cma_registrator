import 'package:cma_registrator/core/repositories/operating_cycle_details/operating_cycle_metrics.dart';
import 'package:cma_registrator/core/widgets/future_builder_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_translate.dart';

class OperatingCycleMetricsWidget extends StatelessWidget {
  final OperatingCycleMetrics _metrics;
  final Widget? _child;
  const OperatingCycleMetricsWidget({
    super.key, 
    required OperatingCycleMetrics metrics,
    Widget? child,
  }) : 
    _metrics = metrics,
    _child = child;

  @override
  Widget build(BuildContext context) {
    return FutureBuilderScaffold(
      onFuture: _metrics.fetchAll,
      title: const Localized('Metrics').v,
      alwaysShowAppBarWidgets: true,
      caseData: (context, pointsMetrics) {
        final padding = const Setting('padding').toDouble;
        final blockPadding = const Setting('blockPadding').toDouble;
        final controller = ScrollController();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Scrollbar(
                thickness: 10,
                thumbVisibility: true,
                controller: controller,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                  child: ListView.builder(
                    controller: controller,
                    itemCount: pointsMetrics.length,
                    itemBuilder: (context, index) {
                      final point = pointsMetrics[index];
                      final theme = Theme.of(context);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            point.name.name,
                            style: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: padding,
                              bottom: blockPadding,
                            ),
                            child: Wrap(
                              spacing: padding,
                              runSpacing: padding,
                              children: point.metrics.map(
                                (metric) => Chip(
                                  padding: EdgeInsets.all(padding),
                                  label: Text('${metric.name}: ${metric.value}'),
                                ),
                              ).toList(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: _child ??  const SizedBox.expand(),
            ),
          ],
        );
      },
    );
  }
}