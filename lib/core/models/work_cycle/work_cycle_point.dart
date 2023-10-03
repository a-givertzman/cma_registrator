import 'package:cma_registrator/core/models/work_cycle/metric.dart';
import 'package:hmi_core/hmi_core.dart';

class WorkCyclePoint {
  final DateTime start;
  final DateTime? stop;
  final DsPointName name;
  final List<Metric> metrics;
  const WorkCyclePoint({
    required this.start, 
    this.stop, 
    required this.name, 
    required this.metrics,
  });
}