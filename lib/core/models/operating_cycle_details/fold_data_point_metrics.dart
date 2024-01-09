import 'package:cma_registrator/core/models/operating_cycle_details/data_point_metrics.dart';
/// 
/// Aggregates metrics in work cycles by data point name.
class FoldDataPointMetrics {
  final List<Map<String, dynamic>> _jsons;
  /// Aggregates metrics in work cycles by data point name.
  const FoldDataPointMetrics({
    required List<Map<String, dynamic>> jsons,
  }) : _jsons = jsons;
  /// 
  List<DataPointMetrics> metrics() {
    return _jsons.fold(
      <String, DataPointMetrics>{}, 
      (previousValue, json) {
        final pointName = json['point_name'] as String;
        return previousValue..addAll({
          pointName: JsonDataPointMetrics(
            json: json,
            additionalMetrics: previousValue.containsKey(pointName) 
              ? previousValue[pointName]!.metrics
              : null,
          ),
        });
      },
    ).values.toList();
  }
}