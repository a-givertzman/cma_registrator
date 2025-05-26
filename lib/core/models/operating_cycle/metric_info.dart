abstract interface class MetricInfo {
  String get id;
  String get name;
  String get description;
}
/// 
/// [MetricInfo] that parses itself from json map.
final class JsonMetricInfo implements MetricInfo {
  final Map<String, dynamic> _json;
  /// 
  /// [MetricInfo] that parses itself from json map.
  const JsonMetricInfo({
    required Map<String, dynamic> json,
  }) : _json = json;
  //
  @override
  String get id => _json['id'];
  //
  @override
  String get name => _json['name'];
  //
  @override
  String get description => _json['description'];
}
