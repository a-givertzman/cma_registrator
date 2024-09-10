import 'dart:developer';

import 'package:cma_registrator/core/models/filter/filters.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';
///
class FiltersField extends StatefulWidget {
  final List<String> _signalNames;
  final ValueNotifier<Filters> _filtersNotifier;
  const FiltersField({
    super.key,
    required ValueNotifier<Filters> filtersNotifier,
    required List<String> signalNames,
  }) :
    _filtersNotifier = filtersNotifier,
    _signalNames = signalNames;

  @override
  State<FiltersField> createState() => _FiltersFieldState();
}
///
class _FiltersFieldState extends State<FiltersField> {
  final TextEditingController _controller = TextEditingController();
  late final RegExp _regexp;
  //
  @override
  void initState() {
    final escapedSignalNames = widget._signalNames.map((signalName) => signalName.replaceAll('.', r'\.'));
    final signalNamesPattern = escapedSignalNames.isEmpty ? '' : '|${escapedSignalNames.join('|')}';
    _regexp = RegExp(
      '(Start|start|End|end$signalNamesPattern)'
      r':(\x22|\x27|)(.+?)\2(?:[ \t]+|$)',
    );
    log('RegExp: ${'(Start|start|End|end$signalNamesPattern)'r':(\x22|\x27|)(.+?)\2(?:[ \t]+|$)'}');
    _controller.addListener(_parseFilters);
    widget._filtersNotifier.addListener(_printFilters);
    super.initState();
  }
  //
  @override
  void dispose() {
    _controller.dispose();
    widget._filtersNotifier.removeListener(_printFilters);
    super.dispose();
  }
  //
  void _printFilters() {
    log(widget._filtersNotifier.value.enumerate().toString());
  }
  //
  void _parseFilters() {
    final query = _controller.text;
    widget._filtersNotifier.value = Filters.fromString(query, _regexp);
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