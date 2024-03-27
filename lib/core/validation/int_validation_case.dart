import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_core/hmi_core_translate.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

class IntValidationCase implements ValidationCase {
  const IntValidationCase();
  @override
  ResultF<void> isSatisfiedBy(String? value) {
    final intPattern = RegExp(r'^[+-]?[\d]*$');
    if (value != null && intPattern.hasMatch(value)) {
      return const Ok(null);
    } else {
      return Err(
        Failure(
          message: const Localized("Invalid integer value").toString(), 
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
}