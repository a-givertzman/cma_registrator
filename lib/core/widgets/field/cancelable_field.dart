import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

///
class CancelableField extends StatefulWidget {
  final String _initialValue;
  final String? _label;
  final String? _sendError;
  final void Function(String)? _onChanged;
  final void Function(String)? _onCanceled;
  final Future<Result<String>>  Function(String?)? _onSaved;
  final Validator _validator;
  ///
  const CancelableField({
    super.key,
    String? label,
    String? sendError,
    String initialValue = '',
    void Function(String)? onChanged,
    void Function(String)? onCanceled,
    Future<Result<String>>  Function(String?)? onSaved,
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
    _onChanged = onChanged,
    _onCanceled = onCanceled,
    _onSaved = onSaved,
    _validator = validator;

  @override
  State<CancelableField> createState() => _CancelableFieldState(
    label: _label,
    sendError: _sendError,
    initialValue: _initialValue,
    onChanged: _onChanged,
    onCanceled: _onCanceled,
    onSaved: _onSaved,
    validator: _validator,
  );
}
///
class _CancelableFieldState extends State<CancelableField> {
  late final TextEditingController _controller;
  final String? _label;
  final void Function(String)? _onChanged;
  final void Function(String)? _onCanceled;
  final Future<Result<String>> Function(String?)? _onSaved;
  final Validator _validator;
  String _initialValue;
  String? _sendError;
  bool _isInProcess = false;

  _CancelableFieldState({
    required String initialValue, 
    required Validator validator,
    String? label, 
    String? sendError, 
    void Function(String)? onChanged, 
    void Function(String)? onCanceled, 
    Future<Result<String>>  Function(String?)? onSaved, 
  }) : 
    _initialValue = initialValue,
    _label = label,
    _sendError = sendError,
    _onChanged = onChanged,
    _onCanceled = onCanceled,
    _onSaved = onSaved,
    _validator = validator;

  @override
  void initState() {
    _controller = TextEditingController(text: _initialValue);
    super.initState();
  }
  //
  @override
  Widget build(BuildContext context) {
    final suffixIconSize = IconTheme.of(context).size;
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