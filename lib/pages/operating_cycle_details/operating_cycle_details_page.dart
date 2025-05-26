import 'package:cma_registrator/core/models/operating_cycle/operating_cycle.dart';
import 'package:cma_registrator/core/repositories/operating_cycle_details/operating_cycle_details.dart';
import 'package:cma_registrator/core/repositories/operating_cycle_details/operating_cycle_events.dart';
import 'package:cma_registrator/core/repositories/operating_cycle_details/operating_cycle_metrics.dart';
import 'package:cma_registrator/pages/operating_cycle_details/widgets/operating_cycle_metrics_widget.dart';
import 'package:cma_registrator/pages/operating_cycle_details/widgets/queriable_operating_cycle_details.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
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
        apiAddress: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
        dbName: const Setting('api-database').toString(), 
        metricsTableName: 'public.rec_operating_metric',
        metricNamesTableName: 'public.rec_name',
        operatingCycle: _operatingCycle,
      ),
      child: QueriableOperatingCycleDetails(
        operatingCycleDetails: _operatingCycleDetails,
        operatingCycle: _operatingCycle,
        operatingCycleEventIds: OperatingCycleEventIds(
          apiAddress: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
          dbName: const Setting('api-database').toString(), 
          tableName: 'public.rec_operating_event',
          operatingCycle: _operatingCycle,
        ),
      ),
    );
  }
}