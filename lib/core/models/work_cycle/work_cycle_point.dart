import 'package:cma_registrator/core/models/work_cycle/metric.dart';
import 'package:hmi_core/hmi_core.dart';
/// 
/// Metrics for data point in the corresponding work cycle.
abstract interface class WorkCyclePoint {
  /// Starting time of the corresponding work cycle.
  DateTime get start;
  /// Ending time of the corresponding work cycle.
  DateTime? get stop;
  /// Name of data point observed in the work cycle.
  DsPointName get name;
  /// Metrics of the observed data point.
  List<Metric> get metrics;
}
/// 
/// [WorkCyclePoint] that parses itself from json map.
final class JsonWorkCyclePoint implements WorkCyclePoint {
  final Map<String, dynamic> _json;
  final List<Metric>? _additionalMetrics;
  /// [WorkCyclePoint] that parses itself from json map.
  /// 
  /// In json map coming from database there are only one metric,
  /// so you can add metrics through [additionalMetrics] param 
  /// if you are grouping some maps together. 
  const JsonWorkCyclePoint({
    required Map<String, dynamic> json,
    List<Metric>? additionalMetrics,
  }) : 
    _json = json,
    _additionalMetrics = additionalMetrics;
  //
  @override
  List<Metric> get metrics => [...?_additionalMetrics, JsonMetric(json: _json)];
  //
  @override
  DsPointName get name => DsPointName(_json['point_name']);
  //
  @override
  DateTime get start => DateTime.parse(_json['start']);
  //
  @override
  DateTime? get stop => DateTime.tryParse(_json['stop']);
}