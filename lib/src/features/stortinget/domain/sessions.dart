import 'package:dart_mappable/dart_mappable.dart';
import 'package:innsikt/src/features/stortinget/domain/time_range.dart';

part 'sessions.mapper.dart';

@MappableClass()
class Sessions with SessionsMappable {
  /// Inneholder elementer som definerer den inneværende sesjonen
  @MappableField(key: 'innevaerende_sesjon')
  final TimeRange range;

  /// Inneholder elementer for alle definerte sesjoner
  @MappableField(key: 'sesjoner_liste')
  final List<TimeRange> sessions;

  Sessions({required this.range, required this.sessions});

  static final fromJson = SessionsMapper.fromJson;
}
