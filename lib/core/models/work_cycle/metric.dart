///
class Metric {
  final String name;
  final double value;
  ///
  const Metric({required this.name, required this.value});
  ///
  factory Metric.fromDbRow(Map<String, dynamic> row) {
    return Metric(name: row['metric_name'], value: double.parse(row['value']));
  }
}