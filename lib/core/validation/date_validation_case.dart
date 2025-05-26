import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_core/hmi_core_translate.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

class DateValidationCase implements ValidationCase {
  const DateValidationCase();
  @override
  ResultF<void> isSatisfiedBy(String? value) {
    final datePattern = RegExp(r'^[\d]{4}-[\d]{2}-[\d]{2}$');
    if (value != null && datePattern.hasMatch(value)) {
      return const Ok(null);
    } else {
      return Err(
        Failure(
          message: const Localized("Invalid date").toString(), 
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
}