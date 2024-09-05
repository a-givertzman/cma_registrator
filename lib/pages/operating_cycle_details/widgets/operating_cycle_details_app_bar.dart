import 'package:cma_registrator/core/widgets/app_bar_widget.dart';
import 'package:cma_registrator/core/widgets/button/dropdown_multiselect_button.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';
///
class OperatingCycleDetailsAppBar extends StatelessWidget {
  final Map<String, bool> _columnsVisibility;
  final void Function(String, bool?)? _onChanged;
  final double _dropdownButtonHeight;
  final double _dropdownMenuItemHeight;
  final double _dropdownMenuWidth;
  final double _height;
  final bool _showOnlyTitle;
  ///
  const OperatingCycleDetailsAppBar({
    super.key,
    required Map<String, bool> columnsVisibility,
    void Function(String key, bool? value)? onChanged, 
    double dropdownButtonHeight = 40, 
    double dropdownMenuItemHeight = 50, 
    double dropdownMenuWidth = 200, 
    double height = 84, 
    bool showOnlyTitle = false,
  }) : 
    _height = height, 
    _dropdownMenuWidth = dropdownMenuWidth, 
    _dropdownMenuItemHeight = dropdownMenuItemHeight, 
    _dropdownButtonHeight = dropdownButtonHeight, 
    _columnsVisibility = columnsVisibility, 
    _onChanged = onChanged, 
    _showOnlyTitle = showOnlyTitle;
  //
  @override
  Widget build(BuildContext context) {
    return AppBarWidget(
      title: const Localized('Events').v,
      height: _height,
      showLeading: false,
      leftWidgets: _showOnlyTitle
      ? const [] 
      : [
        DropdownMultiselectButton(
          onChanged: _onChanged,
          height: _dropdownButtonHeight,
          label: const Localized('Columns').v,
          items: _columnsVisibility,
          itemHeight: _dropdownMenuItemHeight,
          menuWidth: _dropdownMenuWidth,
        ),
      ],
    );
  }
}
