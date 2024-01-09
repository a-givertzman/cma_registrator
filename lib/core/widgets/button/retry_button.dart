import 'package:flutter/material.dart';

class RetryButton extends StatelessWidget {
  final Widget? _retryLabel;
  final void Function()? _onRetry;
  const RetryButton({
    super.key, 
    Widget? retryLabel, 
    void Function()? onRetry,
  }) : 
    _onRetry = onRetry, 
    _retryLabel = retryLabel;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _onRetry, 
      icon: const Icon(Icons.replay), 
      label: _retryLabel ?? const Text('Retry'),
    );
  }
}