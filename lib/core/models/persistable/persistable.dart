import 'package:hmi_core/hmi_core.dart';

///
abstract class Persistable<T> {
  ///
  Future<Result<T>> persist(String value);
}