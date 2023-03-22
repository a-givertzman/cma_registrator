import 'package:cma_registrator/pages/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:hmi_widgets/hmi_widgets.dart';
import 'general_info/general_info_page.dart';
///
class AppWidget extends StatelessWidget {
  ///
  const AppWidget({super.key});
  //
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: GeneralInfoPage.routeName,
      routes: appRoutes,
      theme: appThemes[AppTheme.dark],
    );
  }
}