import 'package:cma_registrator/core/extensions/date_time_formatted_extension.dart';
import 'package:cma_registrator/core/models/filter/filter.dart';
import 'package:cma_registrator/core/models/filter/filter_rule.dart';
import 'package:cma_registrator/core/models/filter/filters.dart';
import 'package:cma_registrator/core/widgets/button/dropdown_multiselect_button.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';
///
class FiltersSelectionButton extends StatelessWidget {
  final List<String> _filterNames;
  final ValueNotifier<Filters> _filtersNotifier;
  // final double _buttonWidth;
  ///
  const FiltersSelectionButton({
    super.key,
    required List<String> filterNames,
    required ValueNotifier<Filters> filtersNotifier,
    // required double buttonWidth,
  }) :
    // _buttonWidth = buttonWidth,
    _filtersNotifier = filtersNotifier,
    _filterNames = filterNames;
  //
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _filtersNotifier,
      builder: (context, filters, _) {
        final filtersList = filters.enumerate().toList();
        return DropdownMultiselectButton(
          label: const Localized('Filters').toString(),
          height: 50, 
          itemHeight: 50, 
          menuWidth: 200, 
          items: {
            for(final filterName in ['Start', 'End', ..._filterNames])
              Localized(filterName).toString(): filtersList.any((filter) => filter.name == filterName),
          },
          onChanged: _toggleFilter,
        );
      },
    );
  }
  ///
  void _toggleFilter(String filterName, bool? value) {
    final actualValue = value ?? false;
    final alreadyContainsFilter = _filtersNotifier.value
      .enumerate()
      .any((filter) => filter.name == filterName);
    if (alreadyContainsFilter && !actualValue) {
      _removeFilter(filterName);
    }
    if (!alreadyContainsFilter && actualValue) {
      _addFilter(filterName);
    }
  }
  ///
  void _removeFilter(String filterName) {
    _filtersNotifier.value = Filters(
      filters: _filtersNotifier.value.enumerate().where(
        (filter) => filter.name != filterName,
      ),
    );
  }
  ///
  void _addFilter(String filterName) {
    final filter = Filter(
      name: filterName,
      rule: switch(filterName) {
        'Start' || 'End' => FilterRule(
          value: DateTime.now().toFormatted(),
          type: FilterRuleType.likewise,
        ),
        _ => const FilterRule(
          value: '0',
          type: FilterRuleType.equal,
        ),
      },
    );
    _filtersNotifier.value = Filters(
      filters: [..._filtersNotifier.value.enumerate(), filter],
    );
  }
}