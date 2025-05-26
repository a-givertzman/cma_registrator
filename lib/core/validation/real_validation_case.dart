import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result_new.dart';
import 'package:hmi_core/hmi_core_translate.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

class RealValidationCase implements ValidationCase {
  const RealValidationCase();
  @override
  ResultF<void> isSatisfiedBy(String? value) {
    final realPattern = RegExp(r'^[+-]?[\d]*[.]?[\d]*$');
    if (value != null && realPattern.hasMatch(value)) {
      return const Ok(null);
    } else {
      return Err(
        Failure(
          message: const Localized("Invalid real value").toString(), 
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
}