import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class GeneralInfoField extends StatelessWidget {
  final String _initialValue;
  final TextEditingController _controller;
  final String? _label;
  final String? _sendError;
  final void Function(String)? _onChanged;
  final void Function(String)? _onCanceled;
  final Validator _validator;
  ///
  GeneralInfoField({
    super.key,
    String? label,
    String? sendError,
    String initialValue = '',
    TextEditingController? controller,
    void Function(String)? onChanged,
    void Function(String)? onCanceled,
    Validator validator = const Validator(
      cases: [
        MinLengthValidationCase(5),
        MaxLengthValidationCase(255),
      ],
    ),
  }) : 
    _label = label,
    _sendError = sendError,
    _initialValue = initialValue,
    _controller = controller ?? TextEditingController(text: initialValue),
    _onChanged = onChanged,
    _onCanceled = onCanceled,
    _validator = validator;
  //
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (string) {
        final message =  _validator.editFieldValidator(string);
        return message != null 
          ? Localized(message).v
          : null;
      },
      controller: _controller,
      onChanged: (value) {
        _onChanged?.call(value);
      },
      decoration: InputDecoration(
        labelText: _label,
        suffix: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _initialValue != _controller.text
            ? InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  _controller.text = _initialValue;
                  _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: _initialValue.length),
                  );
                  _onCanceled?.call(_initialValue);
                },
                child: Icon(
                  Icons.replay,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
              : const Icon(null),
            _sendError != null
              ? Tooltip(
                  message: _sendError,
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: Icon(
                      Icons.info_outline, 
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                )
              : const Icon(null),
          ],
        ),
      ),
    );
  }
}