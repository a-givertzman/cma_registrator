abstract interface class Metric {
  String? get name;
  double? get value;
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
  String? get name => _json['name'];
  //
  @override
  double? get value => double.tryParse("${_json['value']}");
}
///
final class RawMetric implements Metric {
  @override
  final String? name;
  @override
  final double? value;
  ///
  const RawMetric({required this.name, required this.value});
}