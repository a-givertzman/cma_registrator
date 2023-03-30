import 'package:cma_registrator/core/theme/app_theme_switch.dart';
import 'package:flutter/material.dart' hide Localizations;
import 'package:hmi_core/hmi_core.dart';
import 'pages/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Log.initialize(level: LogLevel.all);
  await Localizations.initialize(
    AppLang.ru,
    jsonMap: JsonMap.fromTextFile(
      const TextFile.asset('assets/translations/translations.json'),
    ),
  );
  final appThemeSwitch = AppThemeSwitch();
  runApp(
    AppWidget(
      themeSwitch: appThemeSwitch,
    ),
  );
}
