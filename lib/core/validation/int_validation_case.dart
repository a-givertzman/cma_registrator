import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_core/hmi_core_translate.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

class IntValidationCase implements ValidationCase {
  const IntValidationCase();
  @override
  Result<void> isSatisfiedBy(String? value) {
    final intPattern = RegExp(r'^[+-]?[\d]*$');
    if (value != null && intPattern.hasMatch(value)) {
      return const Result(data: true);
    } else {
      return Result(
        error: Failure(
          message: const Localized("Invalid integer value").toString(), 
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
}