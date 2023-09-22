import 'package:cma_registrator/core/models/field/field_data.dart';
import 'package:cma_registrator/core/validation/date_validation_case.dart';
import 'package:cma_registrator/core/validation/int_validation_case.dart';
import 'package:cma_registrator/core/validation/real_validation_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class CancelableField extends StatefulWidget {
  final FieldType _fieldType;
  final String _initialValue;
  final TextEditingController? _controller;
  final String? _label;
  final String? _sendError;
  final void Function(String)? _onChanged;
  final void Function(String)? _onCanceled;
  final Future<Result<String>>  Function(String?)? _onSaved;
  final Validator? _validator;
  ///
  const CancelableField({
    super.key,
    String? label,
    String? sendError,
    String initialValue = '',
    TextEditingController? controller,
    FieldType fieldType = FieldType.string,
    void Function(String)? onChanged,
    void Function(String)? onCanceled,
    Future<Result<String>>  Function(String?)? onSaved,
    Validator? validator, 
  }) : _controller = controller, 
    _label = label,
    _sendError = sendError,
    _initialValue = initialValue,
    _onChanged = onChanged,
    _onCanceled = onCanceled,
    _onSaved = onSaved,
    _validator = validator,
    _fieldType = fieldType;

  @override
  State<CancelableField> createState() => _CancelableFieldState(
    label: _label,
    sendError: _sendError,
    initialValue: _initialValue,
    onChanged: _onChanged,
    onCanceled: _onCanceled,
    onSaved: _onSaved,
    validator: _validator,
    fieldType: _fieldType,
  );
}
///
class _CancelableFieldState extends State<CancelableField> {
  late final TextEditingController _controller;
  final FieldType _fieldType;
  final String? _label;
  final void Function(String)? _onChanged;
  final void Function(String)? _onCanceled;
  final Future<Result<String>> Function(String?)? _onSaved;
  final Validator? _validator;
  String _initialValue;
  String? _sendError;
  bool _isInProcess = false;

  _CancelableFieldState({
    required String initialValue, 
    required Validator? validator,
    required FieldType fieldType,
    required String? label, 
    required String? sendError, 
    required void Function(String)? onChanged, 
    required void Function(String)? onCanceled, 
    required Future<Result<String>>  Function(String?)? onSaved, 
  }) : 
    _initialValue = initialValue,
    _label = label,
    _sendError = sendError,
    _onChanged = onChanged,
    _onCanceled = onCanceled,
    _onSaved = onSaved,
    _validator = validator,
    _fieldType = fieldType;

  @override
  void initState() {
    _controller = widget._controller ?? TextEditingController(text: _initialValue);
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final suffixIconSize = IconTheme.of(context).size;
    final validator = _validator ?? Validator(
      cases: switch(_fieldType) {
        FieldType.int => [const IntValidationCase()],
        FieldType.real => [const RealValidationCase()],
        FieldType.string => [
          const MinLengthValidationCase(0),
          const MaxLengthValidationCase(255),
        ],
        FieldType.date => [const DateValidationCase()],
      },
    );
    return TextFormField(
      onTap: switch(_fieldType) {
        FieldType.date => () async {
          DateTime? pickedDate = await showDatePicker(
              context: context, 
              initialDate: DateTime.parse(_initialValue),
              firstDate: DateTime.fromMillisecondsSinceEpoch(0),
              lastDate: DateTime.now(),
          );
          if(pickedDate != null ){
            final day = pickedDate.day.toString().padLeft(2, '0');
            final month = pickedDate.month.toString().padLeft(2, '0');
            final year = pickedDate.year.toString().padLeft(4, '0');
            final formattedDate = '$year-$month-$day';
            _controller.text = formattedDate;
            setState(() {
              _onChanged?.call(formattedDate);
            });
          }
        },
        _ => null,
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (string) {
        final message =  validator.editFieldValidator(string);
        return message != null 
          ? Localized(message).v
          : null;
      },
      controller: _controller,
      onChanged: (value) {
        setState(() {
          _onChanged?.call(value);
        });
      },
      onSaved: (value) {
        if (_initialValue != _controller.text) {
          setState(() {
            _isInProcess = true;
            _sendError = null;
          });
          _onSaved?.call(value)
          .then((result) => result.fold(
            onError: (failure) => setState(() {
              _sendError = failure.message;
              _isInProcess = false;
            }), 
            onData: (_) => setState(() {
              _initialValue = _controller.text;
              _isInProcess = false;
            }),
          ));
        }
      },
      decoration: InputDecoration(
        labelText: _label,
        suffix: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _SuffixIcon(
              isVisible:  _initialValue != _controller.text,
              size: suffixIconSize,
              visibleChild: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {
                  setState(() {
                    _controller.text = _initialValue;
                    _controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: _initialValue.length),
                    );
                    _sendError = null;
                  });
                  _onCanceled?.call(_initialValue);
                },
                child: Icon(
                  Icons.replay,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            _SuffixIcon(
              size: suffixIconSize,
              isVisible: _sendError != null,
              visibleChild: Tooltip(
                message: _sendError ?? '',
                child: Icon(
                  Icons.info_outline, 
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
              invisibleChild: _SuffixIcon(
                size: suffixIconSize,
                isVisible: _isInProcess,
                visibleChild: const CupertinoActivityIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuffixIcon extends StatelessWidget {
  final double? size;
  final bool isVisible;
  final Widget? visibleChild;
  final Widget? invisibleChild;
  const _SuffixIcon({
    required this.isVisible, 
    this.visibleChild, 
    this.invisibleChild,
    this.size, 
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: isVisible ? visibleChild : invisibleChild,
    );
  }
}