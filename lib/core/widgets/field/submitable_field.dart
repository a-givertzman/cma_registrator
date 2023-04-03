import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class SubmitableField<T> extends StatefulWidget {
  final T? _initialValue;
  final TextEditingController _controller;
  final String? _label;
  final T? Function(String?) _parse;
  final void Function(T?)? _onChanged;
  final void Function(T?)? _onCanceled;
  final void Function(T?)? _onComplete;
  final Validator _validator;
  ///
  SubmitableField({
    super.key,
    String? label,
    T? initialValue,
    TextEditingController? controller,
    required T? Function(String?) parse,
    void Function(T?)? onChanged,
    void Function(T?)? onCanceled,
    void Function(T?)? onComplete,
    Validator validator = const Validator(
      cases: [
        MinLengthValidationCase(5),
        MaxLengthValidationCase(255),
      ],
    ),
  }) : 
    _label = label,
    _initialValue = initialValue,
    _controller = controller ?? TextEditingController(text: initialValue?.toString()),
    _parse = parse,
    _onChanged = onChanged,
    _onCanceled = onCanceled,
    _onComplete = onComplete,
    _validator = validator;
  //
  @override
  State<SubmitableField<T>> createState() => _SubmitableFieldState<T>(
    label: _label,
    initialValue: _initialValue,
    controller: _controller,
    parse: _parse,
    onChanged: _onChanged,
    onCanceled: _onCanceled,
    onComplete: _onComplete,
    validator: _validator,
  );
}
///
class _SubmitableFieldState<T> extends State<SubmitableField<T>> {
  final T? _initialValue;
  late final String _initialTextValue;
  final TextEditingController _controller;
  final String? _label;
  final T? Function(String?) _parse;
  final void Function(T?)? _onChanged;
  final void Function(T?)? _onCanceled;
  final void Function(T?)? _onComplete;
  final Validator _validator;
  T? _value;
  ///
  _SubmitableFieldState({
    String? label,
    T? initialValue,
    required TextEditingController controller,
    required T? Function(String?) parse,
    void Function(T?)? onChanged,
    void Function(T?)? onCanceled,
    void Function(T?)? onComplete,
    Validator validator = const Validator(
      cases: [
        MinLengthValidationCase(5),
        MaxLengthValidationCase(255),
      ],
    ),
  }) : 
    _label = label,
    _initialValue = initialValue,
    _controller = controller,
    _parse = parse,
    _onChanged = onChanged,
    _onCanceled = onCanceled,
    _onComplete = onComplete,
    _validator = validator;
  //
  @override
  void initState() {
    _initialTextValue = _initialValue?.toString() ?? '';
    super.initState();
  }
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
        setState(() {
          _value = _parse(value);
        });
          _onChanged?.call(_value);
      },
      onEditingComplete: () {
        _onComplete?.call(_value);
      },
      decoration: InputDecoration(
        labelText: _label,
        suffix: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _initialValue != _value 
            ? InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  _onComplete?.call(_value);
                },
                child: Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ) 
              : const Icon(null),
            _initialTextValue != _controller.text 
            ? InkWell(
              customBorder: const CircleBorder(),
              onTap: () {
                _controller.text = _initialTextValue;
                _controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: _initialTextValue.length),
                );
                setState(() {
                  _value = _initialValue;
                });
                _onCanceled?.call(_value);
              },
              child: Icon(
                Icons.replay,
                color: Theme.of(context).colorScheme.primary,
              ),
            ) : const Icon(null),
          ],
        ),
      ),
    );
  }
}