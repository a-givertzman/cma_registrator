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
  ///
  const FailuresAppBar({
    super.key,
    required Map<String, bool> columnsVisibility,
    DateTime? beginningTime,
    DateTime? endingTime, 
    void Function(String key, bool? value)? onChanged, 
  }) : 
    _columnsVisibility = columnsVisibility, 
    _onChanged = onChanged, 
    _endingTime = endingTime, 
    _beginningTime = beginningTime;
  //
  @override
  Widget build(BuildContext context) {
    return AppBarWidget(
      title: const Localized('Failures').v,
      height: kTextTabBarHeight * 1.5,
      leftWidgets: [
        DropdownMultiselectButton(
          onChanged: _onChanged,
          height: 40,
          label: const Localized('Columns').v,
          items: _columnsVisibility,
          itemHeight: 50,
          menuWidth: 200,
        ),
      ],
      rightWidgets: [
        SizedBox(
          width: 220,
          child: SubmitableField<DateTime>(
            initialValue: _beginningTime,
            label: const Localized('Beginning').v,
            parse: (str) => DateTime.tryParse(str?.split('.').reversed.join() ?? ''),
          ),
        ),
        SizedBox(
          width: 220,
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
