import 'package:flutter/cupertino.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_core/hmi_core_translate.dart';

import 'error_message_widget.dart';
/// 
/// Default indicator builder for [FutureBuilderWidget] loading state
Widget _defaultCaseLoading(BuildContext _) => const Center(
  child: CupertinoActivityIndicator(),
);
///
/// Default indicator builder for [FutureBuilderWidget] error state
Widget _defaultCaseError(BuildContext _, Object error, void Function() __) => ErrorMessageWidget(
  message: const Localized('Data loading error').v,
);
///
/// Default indicator builder for [FutureBuilderWidget] empty-data state
Widget _defaultCaseNothing(BuildContext _, void Function() __) => ErrorMessageWidget(
  message: const Localized('No data').v,
);
///
class FutureBuilderWidget<T> extends StatefulWidget {
  final Widget Function(BuildContext) _caseLoading;
  final Widget Function(BuildContext, T, void Function()) _caseData;
  final Widget Function(BuildContext, Object, void Function()) _caseError;
  final Widget Function(BuildContext, void Function()) _caseNothing;
  final bool Function(T)? _validateData;
  final Future<ResultF<T>> Function() _onFuture;
  ///
  const FutureBuilderWidget({
    super.key, 
    required Future<ResultF<T>> Function() onFuture,
    Widget Function(BuildContext context) caseLoading = _defaultCaseLoading,
    required Widget Function(BuildContext context, T data, void Function() retry) caseData,
    Widget Function(BuildContext context, Object error, void Function() retry) caseError = _defaultCaseError,
    Widget Function(BuildContext context, void Function() retry) caseNothing = _defaultCaseNothing, 
    bool Function(T data)? validateData,
  }) : 
    _validateData = validateData, 
    _caseLoading = caseLoading,
    _caseData = caseData,
    _caseError = caseError,
    _caseNothing = caseNothing,
    _onFuture = onFuture;
  //
  @override
  State<FutureBuilderWidget> createState() => _FutureBuilderWidgetState<T>(
    caseLoading: _caseLoading,
    caseData:  _caseData,
    caseError: _caseError,
    caseNothing: _caseNothing,
    onFuture: _onFuture,
    validateData: _validateData,
  );
}
///
class _FutureBuilderWidgetState<T> extends State<FutureBuilderWidget<T>> {
  final Widget Function(BuildContext) _caseLoading;
  final Widget Function(BuildContext, T, void Function()) _caseData;
  final Widget Function(BuildContext, Object, void Function()) _caseError;
  final Widget Function(BuildContext, void Function()) _caseNothing;
  final bool Function(T)? _validateData;
  final Future<ResultF<T>> Function() _onFuture;
  late Future<ResultF<T>> _future;
  ///
  _FutureBuilderWidgetState({
    required Widget Function(BuildContext) caseLoading,
    required Widget Function(BuildContext, T, void Function()) caseData,
    required Widget Function(BuildContext, Object, void Function()) caseError,
    required Widget Function(BuildContext, void Function()) caseNothing,
    required bool Function(T)? validateData,
    required Future<ResultF<T>> Function() onFuture,
  }) : 
    _caseLoading = caseLoading,
    _caseData = caseData,
    _caseError = caseError,
    _caseNothing = caseNothing,
    _onFuture = onFuture,
    _validateData = validateData;
  //
  @override
  void initState() {
    _future = _onFuture();
    super.initState();
  }
  ///
  void _retry() {
    setState(() {
      _future = _onFuture();
    });
  }
  //
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future, 
      builder: (context, snapshot) {
        final snapshotState = _AsyncSnapshotState.fromSnapshot(
          snapshot,
          _validateData,
        );
        return switch(snapshotState) {
          _LoadingState() => _caseLoading.call(context),
          _NothingState() => _caseNothing.call(context, _retry),
          _DataState<T>(:final data) => _caseData.call(context, data, _retry),
          _ErrorState(:final error) => _caseError.call(context, error, _retry),
        };
      },
    );
  }
}
///
sealed class _AsyncSnapshotState<T> {
  factory _AsyncSnapshotState.fromSnapshot(
    AsyncSnapshot<ResultF<T>> snapshot,
    bool Function(T)? validateData,
  ) {
    return switch(snapshot) {
      AsyncSnapshot(
        connectionState: ConnectionState.waiting,
      ) => const _LoadingState(),
      AsyncSnapshot(
        connectionState: != ConnectionState.waiting,
        hasData: true,
        requireData: final result,
      ) => switch(result) {
        Ok(:final value) => switch(validateData?.call(value) ?? true) {
          true => _DataState(value),
          false => _ErrorState(
            Failure(
              message: 'Invalid data',
              stackTrace: StackTrace.current,
            ),
          ) as _AsyncSnapshotState<T>,
        },
        Err(:final error) => _ErrorState(error),
      },
      AsyncSnapshot(
        connectionState: != ConnectionState.waiting,
        hasData: false,
        hasError: true,
        :final error,
        :final stackTrace,
      ) => _ErrorState(
        Failure(
          message: error?.toString() ?? 'Something went wrong',
          stackTrace: stackTrace ?? StackTrace.current,
        ),
      ),
      _ => const _NothingState(),
    };
  }
}
///
final class _LoadingState implements _AsyncSnapshotState<Never> {
  const _LoadingState();
}
///
final class _NothingState implements _AsyncSnapshotState<Never> {
  const _NothingState();
}
///
final class _DataState<T> implements _AsyncSnapshotState<T> {
  final T data;
  const _DataState(this.data);
}
///
final class _ErrorState implements _AsyncSnapshotState<Never> {
  final Failure error;
  const _ErrorState(this.error);
}