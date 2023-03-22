import 'package:cma_registrator/pages/general_info/general_info_page.dart';
import 'package:cma_registrator/pages/tensosensor_calibration/tensosensor_calibration_page.dart';
import 'package:flutter/material.dart';
///
final appRoutes = {
  GeneralInfoPage.routeName: (BuildContext context) => const GeneralInfoPage(),
  TensosensorCalibrationPage.routeName: (BuildContext context) => const TensosensorCalibrationPage(),
};