///
class WorkCycle {
  final DateTime beginning;
  final DateTime? ending;
  final int failureClass;
  final double max;
  final double mean;
  final double data;
  ///
  WorkCycle({
    required this.beginning, 
    this.ending, 
    required this.failureClass, 
    required this.max, 
    required this.mean, 
    required this.data,
  });
}