import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';
import 'widgets/general_info_body.dart';
///
class GeneralInfoPage extends StatelessWidget {
  ///
  const GeneralInfoPage({super.key});
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
          const Localized('General info').v,
          style: theme.textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            tooltip: const Localized('Work cycles').v,
            onPressed:  null, 
            icon: const Icon(Icons.table_chart_outlined),
          ),
          IconButton(
            tooltip: const Localized('Failures').v,
            onPressed:  null, 
            icon: const Icon(Icons.table_rows_outlined),
          ),
          IconButton(
            tooltip: const Localized('Tensosensor calibration').v,
            onPressed:  null, 
            icon: const Icon(Icons.settings_applications_outlined),
          ),
        ],
      ),
      body: const GeneralInfoBody(),
    );
  }
}