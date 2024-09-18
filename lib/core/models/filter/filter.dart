import 'package:cma_registrator/core/models/filter/filter_rule.dart';

///
class Filter {
  final String name;
  final FilterRule rule;
  ///
  const Filter({required this.name, required this.rule});
  ///
  factory Filter.fromStrings(String name, String rule) => Filter(
    name: name,
    rule: FilterRule.fromString(rule),
  );
  //
  @override
  String toString() {
    return '$Filter($name $rule)';
  }
  //
  String toSqlCondition() => "event_id = '$name' AND value ${rule.toSqlRule()}";
  //
  @override
  bool operator ==(Object other) {
    return other is Filter
      && other.name == name
      && other.rule == rule;
  }
  //
  @override
  int get hashCode => name.hashCode ^ rule.hashCode;
  
}