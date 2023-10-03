import 'package:cma_registrator/core/models/work_cycle/work_cycle_points.dart';
import 'package:cma_registrator/pages/work_cycles/widgets/work_cycles_body.dart';
import 'package:dart_api_client/dart_api_client.dart';
import 'package:flutter/material.dart';
///
class WorkCyclesPage extends StatelessWidget {
  static const routeName = '/workCycles';
  ///
  const WorkCyclesPage({super.key});
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WorkCyclesBody(
        points: WorkCyclePoints(
          dbName: 'registrator', 
          tableName: 'operating_cycle_metric_value_view', 
          apiAddress: ApiAddress.localhost(port: 8080),
        ),
      ),
    );
  }
}