import 'dart:math';
import 'package:cma_registrator/pages/failures/widgets/failures_body.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
///
class FailuresPage extends StatelessWidget {
  final DateTime? _beginningTime;
  final DateTime? _endingTime;
  static const routeName = '/failures';
  ///
  const FailuresPage({
    super.key, 
    DateTime? beginningTime, 
    DateTime? endingTime,
  }) : 
    _endingTime = endingTime, 
    _beginningTime = beginningTime;
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FailuresBody(
        beginningTime: _beginningTime,
        endingTime: _endingTime,
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