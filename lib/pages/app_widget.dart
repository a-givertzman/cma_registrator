import 'package:cma_registrator/core/theme/app_theme_switch.dart';
import 'package:cma_registrator/pages/app_routes.dart';
import 'package:flutter/material.dart';
import 'general_info/general_info_page.dart';
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
    );
  }
}