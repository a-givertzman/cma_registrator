import 'package:hmi_core/hmi_core_result.dart';
///
abstract class Fetchable<T> {
  ///
  Future<Result<T>> fetch();
}