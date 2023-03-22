import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';
import 'widgets/tensosensor_calibration_body.dart';
///
class TensosensorCalibrationPage extends StatelessWidget {
  static const routeName = '/tensosensorCalibration';
  ///
  const TensosensorCalibrationPage({super.key});
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          const Localized('Tensosensor calibration').v,
          style: theme.textTheme.headlineSmall,
        ),
      ),
      body: const TensosensorCalibrationBody(),
    );
  }
}