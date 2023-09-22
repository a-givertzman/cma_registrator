import 'package:flutter/material.dart';
import 'package:cma_registrator/core/theme/app_theme_switch.dart';
import 'package:cma_registrator/pages/tensosensor_calibration/general_info_page.dart';
import 'package:cma_registrator/pages/failures/failures_page.dart';
import 'package:cma_registrator/pages/tensosensor_calibration/tensosensor_calibration_page.dart';
import 'package:cma_registrator/pages/work_cycles/work_cycles_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
///
final appRoutes = {
  GeneralInfoPage.routeName: (BuildContext context) => const GeneralInfoPage(),
  TensosensorCalibrationPage.routeName: (BuildContext context) => const TensosensorCalibrationPage(),
  WorkCyclesPage.routeName: (BuildContext context) => const WorkCyclesPage(),
  FailuresPage.routeName: (BuildContext context) => const FailuresPage(),
};
///
class AppWidget extends StatelessWidget {
  final AppThemeSwitch _themeSwitch;
  ///
  const AppWidget({
    super.key, 
    required AppThemeSwitch themeSwitch,
  }) : _themeSwitch = themeSwitch;
  //
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: GeneralInfoPage.routeName,
      routes: appRoutes,
      theme: _themeSwitch.themeData,
      supportedLocales: const [Locale('ru'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
    );
  }
}