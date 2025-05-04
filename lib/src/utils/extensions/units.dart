extension Units on int {
  static const double _unitSize = 16;
  double get unit => toDouble() * _unitSize;
  double get halfUnit => toDouble() * (_unitSize / 2.0);
  double get quarterUnit => toDouble() * (_unitSize / 4.0);
}