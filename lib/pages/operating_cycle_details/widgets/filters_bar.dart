import 'package:cma_registrator/core/models/filter/filters.dart';
import 'package:cma_registrator/pages/operating_cycle_details/widgets/filters_field.dart';
import 'package:cma_registrator/pages/operating_cycle_details/widgets/filters_selection_button.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';

class FiltersBar extends StatelessWidget {
  final List<String> _filterNames;
  final ValueNotifier<Filters> _filtersNotifier;
  // final double _buttonWidth;
  const FiltersBar({
    super.key,
    required List<String> filterNames,
    required ValueNotifier<Filters> filtersNotifier,
    // required double buttonWidth,
  }) :
    // _buttonWidth = buttonWidth,
    _filtersNotifier = filtersNotifier,
    _filterNames = filterNames;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FiltersSelectionButton(
          // buttonWidth: _buttonWidth,
          filterNames: _filterNames,
          filtersNotifier: _filtersNotifier,
        ),
        SizedBox(width: const Setting('padding').toDouble),
        Expanded(
          child: FiltersField(
            filterNames: _filterNames,
            filtersNotifier: _filtersNotifier,
          ),
        ),
      ],
    );
  }
}