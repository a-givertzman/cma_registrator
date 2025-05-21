import 'package:cma_registrator/core/models/filter/filters.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';
///
class FiltersField extends StatelessWidget {
  final List<String> _filterNames;
  final ValueNotifier<Filters> _filtersNotifier;
  ///
  const FiltersField({
    super.key,
    required ValueNotifier<Filters> filtersNotifier,
    required List<String> filterNames,
  }) :
    _filtersNotifier = filtersNotifier,
    _filterNames = filterNames;
  //
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _filtersNotifier,
      builder: (context, filters, _) =>
        TextField(
          controller: TextEditingController(
            text: filters
            .enumerate()
            .map((filter) => filter.toString())
            .join(' '),
          ),
          onChanged: _parseFilters,
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
        ),
      //  _FiltersTextField(
      //     posibleNames: _filterNames,
      //     initialFilters: filters,
      //     onNewFilters: (filters) {
      //       _filtersNotifier.value = filters;
      //     },
      //   ),
    );
  }
  //
  void _parseFilters(String text) {
    final escapedSignalNames = _filterNames
      .map((filterName) => filterName.replaceAll('.', r'\.'));
    final signalNamesPattern = escapedSignalNames.isEmpty ? '' : '|${escapedSignalNames.join('|')}';
    final regexp = RegExp(
      '(Start|start|End|end$signalNamesPattern)'
      r':(\x22|\x27|)(.+?)\2(?:[ \t]+|$)',
    );
    _filtersNotifier.value = Filters.fromString(text, regexp);
  }
}
// ///
// class _FiltersTextField extends StatefulWidget {
//   final List<String> _posibleNames;
//   final Filters _initialFilters;
//   final void Function(Filters) _onNewFilters;
//   ///
//   const _FiltersTextField({
//     required Filters initialFilters,
//     required void Function(Filters) onNewFilters,
//     required List<String> posibleNames,
//   }) :
//     _posibleNames = posibleNames,
//     _onNewFilters = onNewFilters,
//     _initialFilters = initialFilters;
//   //
//   @override
//   State<_FiltersTextField> createState() => __FiltersTextFieldState();
// }
// ///
// class __FiltersTextFieldState extends State<_FiltersTextField> {
//   late final TextEditingController _controller;
//   late final RegExp _regexp;
//   //
//   @override
//   void initState() {
//     final escapedSignalNames = widget._posibleNames
//       .map((filterName) => filterName.replaceAll('.', r'\.'));
//     final signalNamesPattern = escapedSignalNames.isEmpty ? '' : '|${escapedSignalNames.join('|')}';
//     _regexp = RegExp(
//       '(Start|start|End|end$signalNamesPattern)'
//       r':(\x22|\x27|)(.+?)\2(?:[ \t]+|$)',
//     );
//     _controller = TextEditingController.fromValue(
//       TextEditingValue(
//         text: widget._initialFilters
//           .enumerate()
//           .map((filter) => filter.toString())
//           .join(' '),
//       ),
//     );
//     _controller.addListener(_parseFilters);
//     super.initState();
//   }
//   //
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//   //
//   void _parseFilters() {
//     setState(() {
//       widget._onNewFilters(Filters.fromString(_controller.text, _regexp));
//     });
//   }
//   //
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: _controller,
//       onChanged: ,
//       decoration: InputDecoration(
//         labelText: const Localized('Filters').v,
//         hintText: const Localized('Input filtration params, e.g. Start:26.08.2024 End:27.08.2024 Signal1:>=100 Signal2:0').v,
//         hintStyle: TextStyle(color: Theme.of(context).disabledColor.withOpacity(0.5)),
//         border: const OutlineInputBorder(
//           borderRadius: BorderRadius.all(
//             Radius.circular(16),
//           ),
//         ),
//       ),
//     );
//   }
// }