import 'package:hmi_core/hmi_core.dart';

abstract interface class Event {
  int get id;
  String get name;
  String get timestamp;
  double get value;
  DsStatus get status;
}