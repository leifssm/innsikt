import 'package:dart_mappable/dart_mappable.dart';
import 'package:innsikt/src/features/stortinget/domain/representative/representative.dart';

part 'voting_suggestion.mapper.dart';

@MappableEnum()
enum SuggestionType {
  /// Det som en enstemmig komité eller komiteens flertall foreslår at Stortinget
  /// skal vedta.
  @MappableValue(1)
  advisory("tilraading"),

  /// Det som et mindretall i komiteen foreslår at Stortinget skal vedta.
  @MappableValue(2)
  minorityProposal("mindretallsforslag"),

  /// Forslag i en sak som ikke står i innstillingen. Benyttes særlig av partier
  /// som ikke har medlemmer i den aktuelle komiteen som avgir innstillingen,
  /// men som likevel ønsker å fremme forslag i saken. Benyttes også dersom
  /// komiteens medlemmer ønsker å legge til / rette opp forslag etter at
  /// komiteen har avgitt innstillingen. Kan også benyttes i saker hvor det ikke
  /// foreligger en innstilling; slik som for eksempel i trontalen.
  @MappableValue(3)
  looseProposal("loest_forslag");

  final String name;
  const SuggestionType(this.name);

  @override
  String toString() => name;
}

@MappableClass()
class VotingSuggestion with VotingSuggestionMappable {
  /// Element som definerer identifikator for voteringsforslaget
  @MappableField(key: 'forslag_id')
  final int suggestionId;

  /// Element som definerer betegnelse for voteringsforslaget
  @MappableField(key: 'forslag_betegnelse')
  final String title;

  /// Element som definerer kort versjon av betegnelse for voteringsforslaget
  @MappableField(key: 'forslag_betegnelse_kort')
  final String shortTitle;

  /// Element som definerer person-id for eventuell representant som har
  /// levert voteringsforslaget
  @MappableField(key: 'forslag_levert_av_representant')
  final Representative? deliveredBy;

  /// Element som definerer «forslag på vegne av» tekst for voteringsforslaget
  @MappableField(key: 'forslag_paa_vegne_av_tekst')
  final String? onBehalfOf;

  /// Element som definerer sorteringsnummer for voteringsforslaget
  @MappableField(key: 'forslag_sorteringsnummer')
  final int sortingNumber;

  /// Vi gjør også oppmerksom på at forslagstekster i noen tilfeller mangler.
  /// Dette kan skyldes problemer med innlesing av innstillingsfil. Teksten vil
  /// finnes i tilhørende referat fra møtet, se
  /// https://www.stortinget.no/no/Saker-og-publikasjoner/Publikasjoner/Referater/
  /// eller [eksport at XML-fil av referat](https://data.stortinget.no/dokumentasjon-og-hjelp/publikasjoner/)
  @MappableField(key: 'forslag_tekst')
  final String? suggestionText;

  /// Element som definerer type voteringsforslag
  @MappableField(key: 'forslag_type')
  final SuggestionType suggestionType;

  const VotingSuggestion({
    required this.suggestionId,
    required this.title,
    required this.shortTitle,
    required this.deliveredBy,
    required this.onBehalfOf,
    required this.sortingNumber,
    required this.suggestionText,
    required this.suggestionType,
  });

  static final fromJson = VotingSuggestionMapper.fromJson;
}
