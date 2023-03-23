import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_app_settings.dart';
import 'package:hmi_core/hmi_core_translate.dart';
///
class FailuresPage extends StatelessWidget {
  final DateTime? beginningTime;
  final DateTime? endingTime;
  static const routeName = '/failures';
  ///
  const FailuresPage({super.key, this.beginningTime, this.endingTime});
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final padding = const Setting('padding', factor: 3).toDouble;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          const Localized('Failures').v,
          style: theme.textTheme.headlineSmall,
        ),
        actions: [
          Row(
            children: [
              SizedBox(
                width: 220,
                child: TextFormField(
                  initialValue: beginningTime?.toIso8601String(),
                  decoration: InputDecoration(
                    labelText: const Localized('Beginning').v,
                  ),
                ),
              ),
              SizedBox(width: padding),
              SizedBox(
                width: 220,
                child: TextFormField(
                  initialValue: endingTime?.toIso8601String(),
                  decoration: InputDecoration(
                    labelText: const Localized('Ending').v,
                  ),
                ),
              ),
              SizedBox(width: padding),
            ],
          ),
        ],
      ),
    );
  }
}