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
  runZonedGuarded(
    () async {
      runApp(const AppWidget());
    },
    (error, stackTrace) {
      final trace = stackTrace.toString().isEmpty ? StackTrace.current : stackTrace.toString();
      const Log('main').error('message: $error\nstackTrace: $trace'); 
    },
  );  
}
