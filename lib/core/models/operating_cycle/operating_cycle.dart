import 'package:cma_registrator/core/models/operating_cycle_details/metric.dart';

/// 
/// Common data for corresponding operating cycle.
abstract interface class OperatingCycle {
  int get id;
  /// Starting time of the corresponding work cycle.
  DateTime get start;
  /// Ending time of the corresponding work cycle.
  DateTime? get stop;
  ///
  Duration get duration;
  ///
  int get alarmClass;
  ///
  List<Metric> get metrics;
}
/// 
/// [OperatingCycle] that parses itself from json map.
final class JsonOperatingCycle implements OperatingCycle {
  final Map<String, dynamic> _json;
  /// [OperatingCycle] that parses itself from json map. 
  const JsonOperatingCycle({
    required Map<String, dynamic> json,
  }) : 
    _json = json;
  //
  @override
  int get id => _json['id'];
  //
  @override
  DateTime get start => DateTime.parse(_json['timestamp_start']);
  //
  @override
  DateTime? get stop => DateTime.tryParse(_json['timestamp_stop']);
  //
  @override
  Duration get duration => (stop ?? DateTime.now()).difference(start);
  //
  @override
  int get alarmClass => int.parse(_json['alarm_class']);
  @override
  List<Metric> get metrics => (_json['metrics'] as List)
    .map((json) => JsonMetric(json: json))
    .toList();
}