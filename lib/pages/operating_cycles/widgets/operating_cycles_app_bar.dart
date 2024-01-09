import 'package:cma_registrator/core/widgets/app_bar_widget.dart';
import 'package:cma_registrator/core/widgets/field/submitable_field.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';
///
class OperatingCyclesAppBar extends StatelessWidget {
  final DateTime? _beginningTime;
  final DateTime? _endingTime;
  final double _height;
  final double _dateFieldWidth;
  final bool _showOnlyTitle;
  ///
  const OperatingCyclesAppBar({
    super.key,
    DateTime? beginningTime,
    DateTime? endingTime,
    double dateFieldWidth = 220,
    double height = 72,
    bool showOnlyTitle = false,
  }) : 
    _endingTime = endingTime, 
    _beginningTime = beginningTime,
    _dateFieldWidth = dateFieldWidth,
    _height = height,
    _showOnlyTitle = showOnlyTitle;
  //
  @override
  Widget build(BuildContext context) {
    return AppBarWidget(
      title: const Localized('Operating cycles').v,
      height: _height,
      rightWidgets: _showOnlyTitle 
      ? const[] 
      : [
        SizedBox(
          width: _dateFieldWidth,
          child: SubmitableField<DateTime>(
            initialValue: _beginningTime,
            label: const Localized('Beginning').v,
            parse: (str) => DateTime.tryParse(str?.split('.').reversed.join() ?? ''),
          ),
        ),
        SizedBox(
          width: _dateFieldWidth,
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
