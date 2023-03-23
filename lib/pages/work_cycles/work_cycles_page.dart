import 'dart:math';
import 'package:cma_registrator/core/models/work_cycle.dart';
import 'package:cma_registrator/pages/work_cycles/widgets/work_cycles_body.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';
///
class WorkCyclesPage extends StatelessWidget {
  static const routeName = '/workCycles';
  ///
  const WorkCyclesPage({super.key});
  //
  @override
  Widget build(BuildContext context) {
    final random = Random();
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          const Localized('Work cycles').v,
          style: theme.textTheme.headlineSmall,
        ),
      ),
      body: WorkCyclesBody(
        workCycles: [
          for(int i = 0; i < 50; i++)
            WorkCycle(
              beginning: DateTime.now(),
              ending: DateTime.now(),
              failureClass: random.nextInt(6)+1,
              max: random.nextDouble(), 
              mean: random.nextDouble(), 
              data: random.nextDouble(),
            ),
          WorkCycle(
            beginning: DateTime.now(), 
            failureClass: random.nextInt(6)+1,
            max: random.nextDouble(), 
            mean: random.nextDouble(), 
            data: random.nextDouble(),
          ),
        ],
      ),
    );
  }
}