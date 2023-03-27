///
extension DateTimeToFormatted on DateTime {
  ///
  String toFormatted() {
    final dd = _padWithZeros(day, 2);
    final mm = _padWithZeros(month, 2);
    final yyyy = _padWithZeros(year, 4);
    final hh = _padWithZeros(hour, 2);
    final min = _padWithZeros(minute, 2);
    final sec = _padWithZeros(second, 2);
    final ms = _padWithZeros(millisecond, 3);
    final us = microsecond == 0 ? '' : _padWithZeros(microsecond, 3);
    return '$dd.$mm.$yyyy $hh:$min:$sec.$ms$us';
  }
  ///
  String toFormattedAsDate() {
    final dd = _padWithZeros(day, 2);
    final mm = _padWithZeros(month, 2);
    return '$dd.$mm.$year';
  }
  ///
  String _padWithZeros(int n, int padding) => '$n'.padLeft(padding, '0');
  
}