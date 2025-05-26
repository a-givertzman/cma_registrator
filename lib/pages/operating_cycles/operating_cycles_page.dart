import 'package:cma_registrator/core/repositories/metric/metric_infos.dart';
import 'package:cma_registrator/core/repositories/operating_cycle/operating_cycles.dart';
import 'package:cma_registrator/pages/operating_cycles/widgets/operating_cycles_body.dart';
import 'package:ext_rw/ext_rw.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
///
class OperatingCyclesPage extends StatelessWidget {
  static const routeName = '/operatingCycles';
  ///
  const OperatingCyclesPage({super.key});
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OperatingCyclesBody(
        cycles: OperatingCycles(
          dbName: const Setting('api-database').toString(), 
          operatingCyclesTableName: 'public.rec_operating_cycle',
          metricsTableName: 'public.rec_operating_metric',
          metricNamesTableName: 'public.rec_name',
          apiAddress: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
        ),
        metricInfos: MetricInfos(
          dbName: const Setting('api-database').toString(), 
          metricInfoTableName: 'public.rec_name',
          apiAddress: ApiAddress(host: const Setting('api-host').toString(), port: const Setting('api-port').toInt),
        ),
      ),
    );
  }
}