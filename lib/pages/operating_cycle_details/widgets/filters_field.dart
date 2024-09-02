import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';
///
class Filters {
  final Iterable<Filter> _filters;
  ///
  const Filters({
    required Iterable<Filter> filters,
  }) : _filters = filters;
  ///
  factory Filters.fromString(String source, RegExp regexp) => Filters(
    filters: regexp
      .allMatches(source)
      .map(
        (match) => Filter.fromString(
          source.substring(match.start, match.end),
        ),
      ),
  );
  ///
  Iterable<Filter> enumerate() => _filters;
}
class Filter {
  final String name;
  final String rule;
  const Filter({required this.name, required this.rule});
  factory Filter.fromString(String source) {
    final parts = source.split(':');
    return Filter(name: parts[0], rule: parts[1]);
  }
  @override
  String toString() {
    return '$Filter($name with $rule)';
  }
  //
  String toSqlCondition() {
    return name+rule;
  }
}
///
class FiltersField extends StatefulWidget {
  const FiltersField({
    super.key,
  });

  @override
  State<FiltersField> createState() => _FiltersFieldState();
}
///
class _FiltersFieldState extends State<FiltersField> {
  final TextEditingController _controller = TextEditingController();
  final _regexp = RegExp(r'(Start|start|End|end|Signal1|Signal2|Signal\.3):(\x22|\x27)(.+?)\2(?:[ \t]+|$)');
  //
  @override
  void initState() {
    _controller.addListener(_parseFilters);
    super.initState();
  }
  //
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  //
  void _parseFilters() {
    final query = _controller.text;
    print(Filters.fromString(query, _regexp).enumerate());
  }
  //
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: const Localized('Filters').v,
        hintText: const Localized('Input filtration params, e.g. Start:26.08.2024 End:27.08.2024 Signal1:>=100 Signal2:0').v,
        hintStyle: TextStyle(color: Theme.of(context).disabledColor.withOpacity(0.5)),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
      ),
    );
  }
}