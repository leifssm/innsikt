import 'package:dart_mappable/dart_mappable.dart';
import 'package:innsikt/src/features/stortinget/domain/voting/case_vote.dart';

part 'votings.mapper.dart';

@MappableClass()
class Votings with VotingsMappable {
  /// Identifikator for spesifisert sak
  @MappableField(key: 'sak_id')
  final int caseId;

  /// Inneholder elementer for alle voteringer for angitt sak
  @MappableField(key: 'sak_votering_liste')
  final List<CaseVote> caseVotings;

  const Votings({required this.caseId, required this.caseVotings});

  static final fromJson = VotingsMapper.fromJson;
}
