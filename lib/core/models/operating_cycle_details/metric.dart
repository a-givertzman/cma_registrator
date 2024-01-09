abstract interface class Metric {
  String get name;
  double get value;
}
/// 
/// [Metric] that parses itself from json map.
final class JsonMetric implements Metric {
  final Map<String, dynamic> _json;
  /// 
  /// [Metric] that parses itself from json map.
  const JsonMetric({
    required Map<String, dynamic> json,
  }) : _json = json;
  //
  @override
  String get name => _json['metric_name'];
  //
  @override
  double get value => double.parse(_json['value']);
}