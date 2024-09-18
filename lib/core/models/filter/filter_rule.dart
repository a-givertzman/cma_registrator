enum FilterRuleType {
  equal('='),
  notEqual('<>'),
  greater('>'),
  greaterOrEqual('>='),
  lesser('<'),
  lesserOrEqual('<='),
  likewise('LIKE');
  ///
  final String _sign;
  ///
  const FilterRuleType(String sign) : _sign = sign;
  //
  @override
  String toString() => _sign;
}
class FilterRule {
  final String value;
  final FilterRuleType type;
  ///
  const FilterRule({
    required this.value,
    required this.type,
  });
  factory FilterRule.fromString(String source) {
    if(source.isEmpty) {
      throw ArgumentError.value(source);
    }
    final firstSymbolsPair = (source[0], source.length > 1 ? source[1] : null);
    return switch(firstSymbolsPair) {
      ('>', '=') => FilterRule(value: source.substring(2), type: FilterRuleType.greaterOrEqual),
      ('>', _) => FilterRule(value: source.substring(1), type: FilterRuleType.greater),
      ('<', '=') => FilterRule(value: source.substring(2), type: FilterRuleType.lesserOrEqual),
      ('<', '>') => FilterRule(value: source.substring(2), type: FilterRuleType.notEqual),
      ('<', _) => FilterRule(value: source.substring(1), type: FilterRuleType.lesser),
      ('"' || "'", _) => FilterRule(value: source.substring(1, source.length-1), type: FilterRuleType.likewise),
      ('=', _) => FilterRule(value: source.substring(1), type: FilterRuleType.equal),
      _ => FilterRule(value: source, type: FilterRuleType.equal),
    };
  }
  ///
  String toSqlRule() => switch(type) {
    FilterRuleType.likewise => "$type '%$value%'",
    _ => "$type $value"
  };
  //
  @override
  String toString() => toSqlRule();
}
