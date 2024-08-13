import 'package:hmi_core/hmi_core.dart';
import 'metric.dart';
/// 
/// Metrics for data point in the corresponding work cycle.
abstract interface class DataPointMetrics {
  /// Name of data point observed in the work cycle.
  DsPointName get name;
  /// Metrics of the observed data point.
  List<Metric> get metrics;
}
/// 
/// [DataPointMetrics] that parses itself from json map.
final class JsonDataPointMetrics implements DataPointMetrics {
  final Map<String, dynamic> _json;
  final List<Metric>? _additionalMetrics;
  /// [DataPointMetrics] that parses itself from json map.
  /// 
  /// In json map coming from database there are only one metric,
  /// so you can add metrics through [additionalMetrics] param 
  /// if you are grouping some maps together. 
  const JsonDataPointMetrics({
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
  DsPointName get name => DsPointName('/${_json['point_name']}');
}