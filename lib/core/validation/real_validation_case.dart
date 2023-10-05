import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_result.dart';
import 'package:hmi_core/hmi_core_translate.dart';
import 'package:hmi_widgets/hmi_widgets.dart';

class RealValidationCase implements ValidationCase {
  const RealValidationCase();
  @override
  Result<void> isSatisfiedBy(String? value) {
    final realPattern = RegExp(r'^[+-]?[\d]*[.]?[\d]*$');
    if (value != null && realPattern.hasMatch(value)) {
      return const Result(data: true);
    } else {
      return Result(
        error: Failure(
          message: const Localized("Invalid real value").toString(), 
          stackTrace: StackTrace.current,
        ),
      );
    }
  }
}