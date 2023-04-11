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
        points: _generateRandomPoints(
          signalsCount: 20,
          entriesCount: 1000,
        ),
      ),
    );
  }
  List<DsDataPoint> _generateRandomPoints({
    int signalsCount = 5,
    int entriesCount = 100,
  }) {
    final names = List.generate(signalsCount, (index) => 'Signal $index');
    final random = Random();
    final points = <DsDataPoint>[];
    for(int i = 0; i<entriesCount; i++) {
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