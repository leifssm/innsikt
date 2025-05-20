import 'package:dart_mappable/dart_mappable.dart';

class DateTranslator extends MappingHook {
  const DateTranslator();

  @override
  DateTime? beforeDecode(Object? value) {
    if (value == null) return null;
    if (value is! String) throw ArgumentError('Value must be a String, but got $value');
    RegExp exp = RegExp(r'^/Date\((-?\d+)\+(\d{4})\)/$');

    var v = exp.firstMatch(value);
    if (v == null) {
      throw ArgumentError(
        "Invalid date format, expected '/Date(nn..nn+nnnn)/', but got '$value'",
      );
    }

    var timestamp = int.parse(v.group(1)!);
    var offset = int.parse(v.group(2)!);

    var date = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);

    return date.add(Duration(hours: offset ~/ 100, minutes: offset % 100));
  }

  @override
  String? beforeEncode(Object? value) {
    if (value == null) return null;
    if (value is! DateTime) throw ArgumentError('Value must be a DateTime');
    var hh = value.timeZoneOffset.inHours.toString().padLeft(2, '0');
    var mm = value.timeZoneOffset.inMinutes.toString().padLeft(2, '0');
    
    return '/Date(${value.millisecondsSinceEpoch}+$hh$mm)/';
  }
}

class FlipBool extends MappingHook {
  const FlipBool();
  
  _flip(Object? value) {
    if (value is! bool) throw ArgumentError('Value must be a bool');
    return !value;
  }

  @override
  bool beforeDecode(Object? value) {
    return _flip(value);
  }

  @override
  bool beforeEncode(Object? value) {
    return _flip(value);
  }
}

class DefaultValue extends MappingHook {
  const DefaultValue(this.defaultValue);
  
  final Object defaultValue;

  @override
  Object beforeDecode(Object? value) {
    return value ?? defaultValue;
  }
}