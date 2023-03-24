import 'dart:math';
import 'package:cma_registrator/core/widgets/field/submitable_field.dart';
import 'package:cma_registrator/pages/failures/widgets/failures_body.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
///
class FailuresPage extends StatelessWidget {
  final DateTime? beginningTime;
  final DateTime? endingTime;
  static const routeName = '/failures';
  ///
  const FailuresPage({super.key, this.beginningTime, this.endingTime});
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = const Setting('padding', factor: 3).toDouble;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          const Localized('Failures').v,
          style: theme.textTheme.headlineSmall,
        ),
        actions: [
          Row(
            children: [
              SizedBox(
                width: 220,
                child: SubmitableField<DateTime>(
                  initialValue: beginningTime,
                  label: const Localized('Beginning').v,
                  parse: (str) => DateTime.tryParse(str?.split('.').reversed.join() ?? ''),
                ),
              ),
              SizedBox(width: padding),
              SizedBox(
                width: 220,
                child: SubmitableField<DateTime>(
                  initialValue: endingTime,
                  label: const Localized('Ending').v,
                  parse: (str) => DateTime.tryParse(str ?? ''),
                ),
              ),
              SizedBox(width: padding),
            ],
          ),
        ],
      ),
      body: FailuresBody(
        points: _generateRandomPoints(),
      ),
    );
  }
  List<DsDataPoint> _generateRandomPoints() {
    final names = ['Signal 1', 'Signal 2', 'Signal 3', 'Signal 4', 'Signal 5'];
    final random = Random();
    final points = <DsDataPoint>[];
    for(int i = 0; i<100; i++) {
      points.add(
        DsDataPoint(
          type: DsDataType.real, 
          name: DsPointName('/${names[random.nextInt(names.length)]}'), 
          value: random.nextDouble(), 
          status: DsStatus.ok, 
          timestamp: DsTimeStamp.now().toString(),
        ),
      );
    }
    return points;
  }
}