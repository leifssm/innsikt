import 'package:dart_mappable/dart_mappable.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/voting_suggestion.dart';

part 'voting_suggestions.mapper.dart';

@MappableClass()
class VotingSuggestions with VotingSuggestionsMappable {
  /// Identifikator for spesifisert votering
  @MappableField(key: 'votering_id')
  final int voteId;

  /// Inneholder elementer for alle voteringsforslag for angitt votering
  @MappableField(key: 'voteringsforslag_liste')
  final List<VotingSuggestion> suggestions;

  const VotingSuggestions({
    required this.voteId,
    required this.suggestions,
  });

  static final fromJson = VotingSuggestionsMapper.fromJson;
}