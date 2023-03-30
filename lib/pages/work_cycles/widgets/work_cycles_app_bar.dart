import 'package:cma_registrator/core/widgets/app_bar_widget.dart';
import 'package:cma_registrator/core/widgets/field/submitable_field.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';
///
class WorkCyclesAppBar extends StatelessWidget {
  final DateTime? _beginningTime;
  final DateTime? _endingTime;
  ///
  const WorkCyclesAppBar({
    super.key,
    DateTime? beginningTime,
    DateTime? endingTime, 
  }) : 
    _endingTime = endingTime, 
    _beginningTime = beginningTime;
  //
  @override
  Widget build(BuildContext context) {
    const dateFieldWidth = 220.0;
    return AppBarWidget(
      title: const Localized('Work cycles').v,
      height: kTextTabBarHeight * 1.5,
      rightWidgets: [
        SizedBox(
          width: dateFieldWidth,
          child: SubmitableField<DateTime>(
            initialValue: _beginningTime,
            label: const Localized('Beginning').v,
            parse: (str) => DateTime.tryParse(str?.split('.').reversed.join() ?? ''),
          ),
        ),
        SizedBox(
          width: dateFieldWidth,
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
