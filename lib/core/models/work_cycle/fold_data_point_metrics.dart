import 'package:cma_registrator/core/models/work_cycle/work_cycle_point.dart';
/// 
/// Aggregates metrics in work cycles by cycle id and data point name.
class FoldDataPointMetrics {
  final List<Map<String, dynamic>> _jsons;
  /// Aggregates metrics in work cycles by cycle id and data point name.
  const FoldDataPointMetrics({
    required List<Map<String, dynamic>> jsons,
  }) : _jsons = jsons;
  /// 
  List<WorkCyclePoint> workCycles() {
    return _jsons.fold(
      <(int, String), WorkCyclePoint>{}, 
      (previousValue, json) {
        final workCycleId = json['operating_cycle_id'] as int;
        final pointName = json['point_name'] as String;
        final key = (workCycleId, pointName);
        return previousValue..addAll({
            key: JsonWorkCyclePoint(
              json: json,
              additionalMetrics: previousValue.containsKey(key) 
                ? previousValue[key]!.metrics
                : null,
            ),
          });
      },
    ).values.toList();
  }
}