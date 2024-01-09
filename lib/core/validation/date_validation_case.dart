import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_core/hmi_core_translate.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

class DateValidationCase implements ValidationCase {
  const DateValidationCase();
  @override
  Result<void> isSatisfiedBy(String? value) {
    final datePattern = RegExp(r'^[\d]{4}-[\d]{2}-[\d]{2}$');
    if (value != null && datePattern.hasMatch(value)) {
      return const Result(data: true);
    } else {
      return Result(
        error: Failure(
          message: const Localized("Invalid date").toString(), 
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
}