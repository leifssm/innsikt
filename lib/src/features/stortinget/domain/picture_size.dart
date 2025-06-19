enum PictureSize {
  /// 80x107
  small("lite"),
  /// 158x211
  medium("middels"),
  /// 500x668
  large("stort");

  final String value;
  
  const PictureSize(this.value);
  @override
  String toString() => value;
}