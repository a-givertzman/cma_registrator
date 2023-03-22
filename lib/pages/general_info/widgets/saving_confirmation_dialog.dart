import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_translate.dart';
///
class SavingConfirmationDialog extends StatelessWidget {
  const SavingConfirmationDialog({
    super.key,
  });
  //
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(const Localized('Data saving').v),
      content: Text(const Localized('Data will be persisted on the server. Do you want to proceed?').v),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), 
          child: Text(const Localized('Cancel').v),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true), 
          child: Text(const Localized('Save').v),
        ),
      ],
    );
  }
}