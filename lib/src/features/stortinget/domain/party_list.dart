import 'package:dart_mappable/dart_mappable.dart';
import 'package:innsikt/src/features/stortinget/domain/party.dart';

part 'party_list.mapper.dart';

@MappableClass()
class PartyList with PartyListMappable {
  /// Identifikator for spesifisert sesjon. 
  /// `null` dersom stortingsperiodeid er spesifisert
  @MappableField(key: 'sesjon_id')
  final String sessionId;

  /// Identifikator for spesifisert stortingsperiode
  @MappableField(key: 'stortingsperiode_id')
  final String periodId;

  /// Inneholder elementer for alle partier som er representert på Stortinget i angitt sesjon
  @MappableField(key: 'partier_liste')
  final List<Party> parties;

  PartyList({required this.sessionId, required this.periodId, required this.parties});

  static final fromJson = PartyListMapper.fromJson;
}