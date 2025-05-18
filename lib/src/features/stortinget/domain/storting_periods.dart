import 'package:dart_mappable/dart_mappable.dart';
import 'package:innsikt/src/features/stortinget/domain/time_range.dart';

part 'storting_periods.mapper.dart';

@MappableClass()
class StortingPeriods with StortingPeriodsMappable {
  /// Inneholder elementer som definerer den inneværende stortingsperioden
  @MappableField(key: 'innevaerende_stortingsperiode')
  final TimeRange range;

  /// Inneholder elementer for alle definerte stortingsperioder
  @MappableField(key: 'stortingsperioder_liste')
  final List<TimeRange> periods;

  StortingPeriods({
    required this.range,
    required this.periods,
  });

  static final fromJson = StortingPeriodsMapper.fromJson;
}