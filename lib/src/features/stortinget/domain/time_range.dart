import 'package:dart_mappable/dart_mappable.dart';
import 'package:innsikt/src/features/stortinget/domain/date_translator.dart';

part 'time_range.mapper.dart';

@MappableClass()
class TimeRange with TimeRangeMappable {
  final String id;
  @MappableField(key: 'fra', hook: DateTranslator())
  final DateTime from;
  @MappableField(key: 'til', hook: DateTranslator())
  final DateTime to;

  TimeRange({
    required this.id,
    required this.from,
    required this.to,
  });

  static final fromJson = TimeRangeMapper.fromJson;
}