import 'package:cma_registrator/core/models/filter/filter.dart';
import 'package:flutter/foundation.dart';
import 'package:hmi_core/hmi_core.dart';
///
class Filters {
  final Iterable<Filter> _filters;
  ///
  const Filters({
    required Iterable<Filter> filters,
  }) : _filters = filters;
  ///
  const Filters.empty() : this(filters: const []);
  ///
  factory Filters.fromString(String source, RegExp regexp) => Filters(
    filters: regexp
      .allMatches(source)
      .map((match) => match.groupCount == 3 ? Some<RegExpMatch>(match) : const None())
      .whereType<Some<RegExpMatch>>()
      .map((some) => some.value)
      .map(
        (match) => Filter.fromStrings(match[1]!, match[3]!),
      ),
  );
  ///
  Iterable<Filter> enumerate() => _filters;
  //
  @override
  bool operator ==(Object other) {
    return other is Filters
      && setEquals(Set.from(_filters), Set.from(other.enumerate()));
  }
  //
  @override
  int get hashCode => Set.from(_filters).hashCode;
}