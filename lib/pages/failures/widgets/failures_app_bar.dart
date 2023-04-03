import 'package:cma_registrator/core/widgets/app_bar_widget.dart';
import 'package:cma_registrator/core/widgets/button/dropdown_multiselect_button.dart';
import 'package:cma_registrator/core/widgets/field/submitable_field.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';
///
class FailuresAppBar extends StatelessWidget {
  final DateTime? _beginningTime;
  final DateTime? _endingTime;
  final Map<String, bool> _columnsVisibility;
  final void Function(String, bool?)? _onChanged;
  final double _dropdownButtonHeight;
  final double _dropdownMenuItemHeight;
  final double _dropdownMenuWidth;
  final double _dateFieldWIdth;
  final double _height;
  ///
  const FailuresAppBar({
    super.key,
    required Map<String, bool> columnsVisibility,
    DateTime? beginningTime,
    DateTime? endingTime, 
    void Function(String key, bool? value)? onChanged, 
    double dropdownButtonHeight = 40, 
    double dropdownMenuItemHeight = 50, 
    double dropdownMenuWidth = 200, 
    double dateFieldWIdth = 220, 
    double height = 84, 
  }) : 
    _height = height, 
    _dateFieldWIdth = dateFieldWIdth, 
    _dropdownMenuWidth = dropdownMenuWidth, 
    _dropdownMenuItemHeight = dropdownMenuItemHeight, 
    _dropdownButtonHeight = dropdownButtonHeight, 
    _columnsVisibility = columnsVisibility, 
    _onChanged = onChanged, 
    _endingTime = endingTime, 
    _beginningTime = beginningTime;
  //
  @override
  Widget build(BuildContext context) {
    return AppBarWidget(
      title: const Localized('Failures').v,
      height: _height,
      leftWidgets: [
        DropdownMultiselectButton(
          onChanged: _onChanged,
          height: _dropdownButtonHeight,
          label: const Localized('Columns').v,
          items: _columnsVisibility,
          itemHeight: _dropdownMenuItemHeight,
          menuWidth: _dropdownMenuWidth,
        ),
      ],
      rightWidgets: [
        SizedBox(
          width: _dateFieldWIdth,
          child: SubmitableField<DateTime>(
            initialValue: _beginningTime,
            label: const Localized('Beginning').v,
            parse: (str) => DateTime.tryParse(str?.split('.').reversed.join() ?? ''),
          ),
        ),
        SizedBox(
          width: _dateFieldWIdth,
          child: SubmitableField<DateTime>(
            initialValue: _endingTime,
            label: const Localized('Ending').v,
            parse: (str) => DateTime.tryParse(str ?? ''),
          ),
        ),
      ],
    );
  }
}
