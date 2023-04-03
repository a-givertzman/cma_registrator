import 'package:flutter/material.dart';
///
class ActionButton extends StatelessWidget {
  final double? _height;
  final double? _width;
  final String? _label;
  final double _labelLineHeight;
  final void Function()? _onPressed;
  ///
  const ActionButton({
    super.key,
    required void Function()? onPressed, 
    String? label, 
    double? height, 
    double? width, 
    double labelLineHeight = 1.0,
  }) : 
    _labelLineHeight = labelLineHeight, 
    _width = width, 
    _height = height, 
    _label = label, 
    _onPressed = onPressed;
  //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);  
    return SizedBox(
      height: _height,
      width: _width,
      child: ElevatedButton(
        onPressed: _onPressed,
        style: ButtonStyle(
          textStyle: MaterialStateProperty.resolveWith<TextStyle?>(
            (states) => theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
              height: _labelLineHeight,
            ),
          ),
        ),
        child: Text(
          _label ?? '',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}