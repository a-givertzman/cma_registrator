import 'package:cma_registrator/core/repositories/operating_cycle/operating_cycles.dart';
import 'package:cma_registrator/pages/operating_cycles/widgets/operating_cycles_body.dart';
import 'package:dart_api_client/dart_api_client.dart';
import 'package:flutter/material.dart';
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
        points: OperatingCycles(
          dbName: 'registrator', 
          tableName: 'operating_cycle', 
          apiAddress: ApiAddress.localhost(port: 8080),
        ),
      ),
    );
  }
}