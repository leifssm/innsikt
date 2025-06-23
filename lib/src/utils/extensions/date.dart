extension PrettyDate on DateTime {
  /// Returns a formatted date string in the format "dd.MM.yyyy".
  String get prettyDate {
    return "${day.toString().padLeft(2, '0')}.${month.toString().padLeft(2, '0')}.$year";
  }

  /// Returns a formatted date string in the format "HH:mm".
  String get prettyTime {
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }

  /// Returns a formatted date string in the format "dd.MM.yyyy HH:mm".
  String get prettyDateTime {
    return "$prettyDate ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }
}