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
  /// Maximum lifting load value during all operating cycle.
  double get maxLoad;
  /// Average lifting load value during all operating cycle.
  double get averageLoad;
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
  // TODO swap to json field when it'll be ready on backend
  @override
  double get averageLoad => 0;
  // TODO swap to json field when it'll be ready on backend
  @override
  double get maxLoad => 0;
}