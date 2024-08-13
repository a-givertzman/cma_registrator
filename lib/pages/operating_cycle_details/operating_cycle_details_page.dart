import 'package:cma_registrator/core/models/operating_cycle/operating_cycle.dart';
import 'package:cma_registrator/core/repositories/operating_cycle_details/operating_cycle_details.dart';
import 'package:cma_registrator/core/repositories/operating_cycle_details/operating_cycle_metrics.dart';
import 'package:cma_registrator/core/widgets/future_builder_widget.dart';
import 'package:cma_registrator/pages/operating_cycle_details/widgets/operating_cycle_details_body.dart';
import 'package:cma_registrator/pages/operating_cycle_details/widgets/operating_cycle_metrics_widget.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
///
class OperatingCycleDetailsPage extends StatelessWidget {
  final OperatingCycle _operatingCycle;
  final OperatingCycleDetails _operatingCycleDetails;
  static const routeName = '/operatingCycleDetails';
  ///
  const OperatingCycleDetailsPage({
    super.key, 
    required OperatingCycle operatingCycle,
    required OperatingCycleDetails operatingCycleDetails,
  }) : 
    _operatingCycle = operatingCycle,
    _operatingCycleDetails = operatingCycleDetails;
  //
  @override
  Widget build(BuildContext context) {
    return OperatingCycleMetricsWidget(
      metrics: OperatingCycleMetrics(
        apiAddress: ApiAddress.localhost(port: 8080),
        dbName: 'crane_data_server',
        tableName: 'operating_cycle_metric_value_view',
        operatingCycle: _operatingCycle,
      ),
      child: FutureBuilderWidget(
        onFuture: _operatingCycleDetails.fetchAll,
        caseData: (context, points, _) => OperatingCycleDetailsBody(
          operatingCycle: _operatingCycle,
          points: points,
        ),

      ),
    );
  }
}