import 'package:cma_registrator/pages/general_info/general_info_page.dart';
import 'package:cma_registrator/pages/tensosensor_calibration/tensosensor_calibration_page.dart';
import 'package:cma_registrator/pages/work_cycles/work_cycles_page.dart';
import 'package:flutter/material.dart';
///
final appRoutes = {
  GeneralInfoPage.routeName: (BuildContext context) => const GeneralInfoPage(),
  TensosensorCalibrationPage.routeName: (BuildContext context) => const TensosensorCalibrationPage(),
  WorkCyclesPage.routeName: (BuildContext context) => const WorkCyclesPage(),
};